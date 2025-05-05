#!/bin/bash

# Load .env
source .env

KEY_PATH="./$KEY_NAME"
USER="ec2-user"

PUBLIC_IP=$(terragrunt output -raw sandbox_public_ip)

if [ ! -f "$KEY_PATH" ]; then
  echo "❌ SSH private key not found at $KEY_PATH"
  exit 1
fi

if [ -z "$PUBLIC_IP" ]; then
  echo "❌ Failed to retrieve public IP from Terragrunt output"
  exit 1
fi

chmod 400 "$KEY_PATH"

echo "🚀 Connecting to $PUBLIC_IP..."
ssh -i "$KEY_PATH" "$USER@$PUBLIC_IP"
