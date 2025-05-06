provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_key_pair" "sandbox_key" {
  key_name   = var.key_name
  public_key = file("${path.module}/${var.key_name}.pub")  # 本地生成的公钥
}

resource "aws_instance" "sandbox" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.sandbox_key.key_name
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "sandbox-ec2"
  }
}

resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg"
  description = "Allow SSH only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
