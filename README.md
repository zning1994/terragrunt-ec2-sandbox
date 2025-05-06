# 🚀 Terragrunt EC2 Sandbox

A fully automated, secure, and disposable sandbox environment on AWS EC2 for testing, coding interviews, and script evaluation. This project provisions a temporary EC2 instance pre-configured with modern developer tools.

---

## 🧰 Pre-installed Tools

| Tool     | Version        | Install Method |
| -------- | -------------- | -------------- |
| Node.js  | Latest LTS     | via nvm        |
| Python   | 3.11.7         | via pyenv      |
| Poetry   | Latest         | via script     |
| Golang   | 1.21.5         | via gvm        |
| Git/Curl | System Default | Amazon Linux   |

---

## 📁 Project Structure

```
terragrunt-ec2-sandbox/
├── .env.example             # Template for environment variables
├── Makefile                 # Helper commands
├── create-keypair.sh        # Generate SSH key and public key
├── connect.sh               # Auto SSH login
├── terragrunt.hcl           # Root Terragrunt config
└── modules/
    └── ec2-sandbox/
        ├── main.tf
        ├── outputs.tf
        ├── userdata.sh
        └── variables.tf
```

---

## 💾 Requirements

Before you begin, make sure you have the following tools installed on your macOS system:

- **make** (build automation tool)
- **terragrunt** (for managing Terraform configurations)
- **terraform** (infrastructure as code tool)
- **awscli** (AWS Command Line Interface)

You can install all of these using Homebrew:

```bash
brew install make terraform terragrunt awscli
```

> **Note for macOS users:**
>
> When you install GNU make via Homebrew, it is named `gmake` by default. To use it as `make`, add the following to your shell profile (e.g., `~/.zshrc` or `~/.bashrc`):
>
> ```bash
> export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
> ```
>
> Then run `source ~/.zshrc` (或 `source ~/.bashrc`) to apply the change. This ensures the `make` command uses GNU make instead of the default BSD make.

If you don't have Homebrew, you can install it from https://brew.sh/

---

**Environment Variables Loading**

This project requires all configuration variables to be available as environment variables. You can use the provided `.env` file:

```bash
cp .env.example .env
```

Before running `make up` or any Terragrunt/Terraform command, load variables into your environment:

```bash
export $(cat .env | grep -v '^#' | xargs)
```

Or use tools like [`direnv`](https://direnv.net/) or [`dotenv`](https://github.com/motdotla/dotenv) for automatic loading.

## 🛠️ Setup Instructions

### 1️⃣ Clone the Project

```bash
git clone https://github.com/yourname/terragrunt-ec2-sandbox.git
cd terragrunt-ec2-sandbox
```

### 2️⃣ Prepare Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and fill in:

* `AWS_REGION`
* `VPC_ID`
* `MY_IP`

### 3️⃣ Generate SSH Key Pair

```bash
make key
```

Generates:

* `sandbox-key`: your private key (never commit to git)
* `sandbox-key.pub`: public key used in AWS EC2 key pair (auto-ignored by .gitignore)

### 4️⃣ Launch EC2 Sandbox

```bash
make up
```

This runs Terragrunt to create the EC2 instance and security group.

- During provisioning, all environment setup commands are written to `/root/sandbox-init.sh` on the EC2 instance.
- The script is automatically executed once during initialization. Output is saved to `/root/sandbox-init.log`.
- You can SSH in and manually re-run the initialization if needed:
  ```bash
  sudo bash /root/sandbox-init.sh | tee /root/sandbox-init.log && sudo source /root/.bash_profile
  ```
- If you want to customize environment setup, edit `modules/ec2-sandbox/userdata.sh` (which writes to `/root/sandbox-init.sh`).

### 5️⃣ Connect to Instance

```bash
make ssh
```

Automatically connects using the generated private key.

### 6️⃣ Destroy the Instance

```bash
make destroy
```

Cleans up all infrastructure.

---

## 🌏 Common AWS Regions - Latest Amazon Linux 2023 ECS-HVM AMIs

Below are the latest Amazon Linux 2023 **ecs-hvm** AMIs (as of 2025-05-07) for common AWS regions, for EC2 launch reference:

| Region        | Region Code     | Arch   | AMI ID                | Name                                                         | Creation Date |
|--------------|----------------|--------|-----------------------|--------------------------------------------------------------|---------------|
| Stockholm    | eu-north-1     | x86_64 | ami-01996b583d78e1e02 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-x86_64         | 2025-04-30    |
| Stockholm    | eu-north-1     | arm64  | ami-01598e029f70d422a | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-arm64          | 2025-04-30    |
| Tokyo        | ap-northeast-1 | x86_64 | ami-01f61ae3169ebca42 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-x86_64         | 2025-04-30    |
| Tokyo        | ap-northeast-1 | arm64  | ami-06d88755d71f53a57 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-arm64          | 2025-04-30    |
| Singapore    | ap-southeast-1 | x86_64 | ami-01a03878059167cb6 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-x86_64         | 2025-04-30    |
| Singapore    | ap-southeast-1 | arm64  | ami-0d47fa2c431cf6d45 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-arm64          | 2025-04-30    |
| US East      | us-east-1      | x86_64 | ami-01b56a55bb90b31ac | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-x86_64         | 2025-04-30    |
| US East      | us-east-1      | arm64  | ami-0d33842a33bae4fd3 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-arm64          | 2025-04-30    |
| US West      | us-west-1      | x86_64 | ami-0539259477458dc86 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-x86_64         | 2025-04-30    |
| US West      | us-west-1      | arm64  | ami-0be08d3f7f9fcadb0 | al2023-ami-ecs-hvm-2023.0.20250430-kernel-6.1-arm64          | 2025-04-30    |

> For the latest ECS-HVM AMIs, please re-run the `aws ec2 describe-images` command as needed.
---

## 🔐 Security Notes

* SSH access is restricted to your public IP
* Private key is **not stored or uploaded** to the cloud
* Instances are disposable by design

---

## 🧪 Use Cases

* Secure execution of untrusted scripts
* Coding interview sandbox
* Environment bootstrap testing
* Quick ephemeral dev VM

---

## 📦 Future Enhancements

* Support for spot instances
* Instance Connect (no SSH key)
* GUI (Web UI to manage and launch)

---

## 👨‍💻 Maintainer

* Ning Zhang (张宁)
* With ChatGPT technical assistant

> “Use disposable infrastructure. Trust nothing. Test everything.”
