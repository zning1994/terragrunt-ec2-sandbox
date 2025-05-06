#!/bin/bash
# 将所有初始化命令写入 /root/sandbox-init.sh，方便手动执行

cat <<'EOF' > /root/sandbox-init.sh
#!/bin/bash
# set -eux

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

echo "✅ Sandbox 初始化完成"
EOF

chmod +x /root/sandbox-init.sh

# 可选：自动执行一次初始化并记录日志（如需启用取消注释）
# bash /root/sandbox-init.sh | tee /root/sandbox-init.log