#!/bin/bash

KEY_NAME="sandbox-key"

# 生成本地密钥对（OpenSSH格式）
ssh-keygen -t rsa -b 4096 -f $KEY_NAME -N ""

# 拷贝公钥到 Terraform 目录
cp ${KEY_NAME}.pub modules/ec2-sandbox/${KEY_NAME}.pub

echo "✅ SSH key pair generated:"
echo "- Private key: $KEY_NAME"
echo "- Public key: modules/ec2-sandbox/${KEY_NAME}.pub"
