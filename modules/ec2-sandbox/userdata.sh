#!/bin/bash
# 将所有初始化命令写入 /root/sandbox-init.sh，方便手动执行

cat <<'EOF' > /root/sandbox-init.sh
#!/bin/bash
# set -eux

start=$(date +%s)

mkdir ~/Codes
echo "📦 正在更新系统..."
yum update -y

echo "🔧 安装开发工具和依赖..."
yum install -y bison git gcc glibc-devel gcc-c++ make \
  zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel \
  libffi-devel xz-devel tk-devel gdbm-devel lzma \
  libuuid-devel libtirpc-devel findutils

echo "⬇️ 安装 nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

echo "🐍 安装 pyenv..."
curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv install 3.11.7
pyenv global 3.11.7

echo "📦 安装 poetry..."
curl -sSL https://install.python-poetry.org | python3 -

echo "🐹 安装 GVM + Go 1.21.5（ARM64）..."
wget https://go.dev/dl/go1.21.5.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-arm64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm
gvm install go1.21.5 --binary
gvm use go1.21.5 --default

echo "🧹 清理 bootstrap Go..."
sudo rm -rf /usr/local/go
rm -f go1.21.5.linux-arm64.tar.gz

echo "📝 写入 nvm / pyenv / gvm 环境变量到 /root/.bash_profile..."
cat <<'EOPROF' >> /root/.bash_profile

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
EOPROF

if [ -z "$CODE_SERVER_PASSWORD" ]; then
  CODE_SERVER_PASSWORD="changeme"
fi
curl -fsSL https://code-server.dev/install.sh | sh
cat >/etc/systemd/system/code-server.service <<EOF2
[Unit]
Description=code-server
After=network.target

[Service]
Type=simple
User=root
Environment=PASSWORD=$CODE_SERVER_PASSWORD
ExecStart=/usr/bin/code-server --bind-addr 0.0.0.0:8080 --auth password --disable-telemetry --disable-update-check
Restart=always

[Install]
WantedBy=multi-user.target
EOF2
systemctl daemon-reload
systemctl enable code-server
systemctl restart code-server

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

META() {
  curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/$1
}

end=$(date +%s)
duration=$((end - start))
minutes=$((duration / 60))
seconds=$((duration % 60))
echo "Userdata script duration: ${minutes} min ${seconds} sec"
echo "Userdata executed at: $(date '+%Y-%m-%d %H:%M:%S %Z')"

echo "✅ Sandbox 初始化完成, 实例详细信息如下：
Instance ID:       $(META instance-id)
Private IP:        $(META local-ipv4)
Public IP:         $(META public-ipv4)
Region:            $(META placement/region)
Availability Zone: $(META placement/availability-zone)
Instance Type:     $(META instance-type)
请通过 http://$(META public-ipv4):8080/?folder=/root/Codes 访问 code-server"

EOF

chmod +x /root/sandbox-init.sh

# 可选：自动执行一次初始化并记录日志（如需启用取消注释）
# bash /root/sandbox-init.sh | tee /root/sandbox-init.log