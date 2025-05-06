# 自动加载 .env 环境变量，适配 Terragrunt/Terraform/AWS CLI
ifneq (,$(wildcard .env))
  include .env
  export
endif

PROJECT_DIR=terragrunt-ec2-sandbox
KEY_NAME=$(shell grep KEY_NAME .env | cut -d '=' -f2)
MY_IP=$(shell grep MY_IP .env | cut -d '=' -f2)

.PHONY: all env key up ssh destroy clean

all: up

# 0. Create .env if missing
env:
	cp -n .env.example .env

# 1. Create SSH Key Pair
key:
	bash create-keypair.sh

# 2. Deploy EC2 Sandbox
up:
	@echo "[INFO] Loading environment variables from .env"
	set -a; [ -f .env ] && . ./.env; set +a; \
	cd ../$(PROJECT_DIR) && terragrunt init && terragrunt apply -auto-approve

# 3. SSH into Sandbox
ssh:
	@echo "[INFO] Loading environment variables from .env"
	set -a; [ -f .env ] && . ./.env; set +a; \
	bash connect.sh

# 4. Destroy Sandbox
destroy:
	@echo "[INFO] Loading environment variables from .env"
	set -a; [ -f .env ] && . ./.env; set +a; \
	cd ../$(PROJECT_DIR) && terragrunt destroy -auto-approve

# 5. Clean up generated keys
clean:
	rm -f $(KEY_NAME) modules/ec2-sandbox/$(KEY_NAME).pem.pub
	echo "✅ SSH keys cleaned."
