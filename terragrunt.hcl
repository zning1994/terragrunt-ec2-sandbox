locals {
  region         = "us-east-1"
  instance_type  = "t3.micro"
  ami_id         = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2
  key_name       = "sandbox-key"           # 用你的密钥名字
  vpc_id         = "vpc-xxxxxxxx"           # 替换成你的 VPC ID
  my_ip          = "your.public.ip.address/32" # 自己的 IP
}

terraform {
  source = "./modules/ec2-sandbox"
}

inputs = {
  region        = local.region
  ami_id        = local.ami_id
  instance_type = local.instance_type
  key_name      = local.key_name
  vpc_id        = local.vpc_id
  my_ip         = local.my_ip
}
