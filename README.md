# 🚀 Terragrunt EC2 Sandbox Setup

This project provides a fully automated **temporary sandbox environment** on AWS EC2 using **Terragrunt**. The instance is pre-configured with:

* Node.js (via nvm)
* Python 3.11 + poetry (via pyenv)
* Golang 1.21 (via gvm)
* Git, Curl, Docker ready

Built for secure, isolated, disposable test runs (e.g., executing unknown scripts, interview questions, experiments).

---

## 📦 Project Structure

```
terragrunt-sandbox/
├── terragrunt.hcl
├── create-keypair.sh
├── connect.sh
└── modules/
    └── ec2-sandbox/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── userdata.sh
```

---

## ⚙️ Prerequisites

* AWS CLI configured (`aws configure`)
* Terraform & Terragrunt installed
* Your AWS account and VPC ID ready

---

## 🚀 Quick Start

### 1. Generate SSH key pair

```bash
bash create-keypair.sh
```

This creates:

* `sandbox-key` (private key)
* `modules/ec2-sandbox/sandbox-key.pem.pub` (public key for AWS)

### 2. Initialize Terragrunt

```bash
cd terragrunt-sandbox
terragrunt init
```

### 3. Deploy Sandbox EC2

```bash
terragrunt apply
```

Follow prompts to create resources.

### 4. Connect to EC2 Instance

```bash
./connect.sh
```

Auto-fetches public IP and SSH into the instance.

### 5. Destroy Sandbox

```bash
terragrunt destroy
```

Cleans up everything!

---

## 📚 What is installed inside the EC2?

| Tool              | Version        | Notes               |
| ----------------- | -------------- | ------------------- |
| Node.js           | Latest LTS     | via nvm             |
| Python            | 3.11.7         | via pyenv           |
| Poetry            | Latest         | for Python projects |
| Golang            | 1.21.5         | via gvm             |
| Git, Curl, Docker | System default | Ready to use        |

All preloaded via cloud-init (userdata.sh).

---

## 🛡️ Security Notes

* Only your IP is allowed to SSH via security group.
* Private key (`sandbox-key`) must be stored securely (not in Git).
* Sandbox instance is **stateless**; all changes are ephemeral.

---

## 📦 Potential Extensions

* Add cloudwatch logging
* Use spot instances for cheaper cost
* Integrate with SSM Session Manager (no SSH key needed)

---

## 👨‍💻 Author

* Designed by Ning Zhang
* Assisted by ChatGPT (prompt engineering)

> "Build safe, clean, disposable environments for better security and productivity!" 🚀
