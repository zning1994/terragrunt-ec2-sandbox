#!/bin/bash
# 基础环境
yum update -y
yum install -y git curl gcc gcc-c++ make

# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

# 安装 pyenv
curl https://pyenv.run | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv install 3.11.7
pyenv global 3.11.7

# 安装 poetry
curl -sSL https://install.python-poetry.org | python3 -

# 安装 gvm
bash < <(curl -sSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm
gvm install go1.21.5
gvm use go1.21.5 --default

# 完成
echo "Sandbox ready!"
