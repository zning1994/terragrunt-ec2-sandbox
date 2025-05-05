#!/bin/bash

KEY_NAME="sandbox-key"

# 生成本地密钥对
ssh-keygen -t rsa -b 4096 -m PEM -f $KEY_NAME -N ""

# 导出 PEM 格式公钥
openssl rsa -in $KEY_NAME -pubout -out modules/ec2-sandbox/${KEY_NAME}.pem.pub

echo "✅ SSH key pair generated:"
echo "- Private key: $KEY_NAME"
echo "- Public key: modules/ec2-sandbox/${KEY_NAME}.pem.pub"
