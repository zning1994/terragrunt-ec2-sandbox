locals {
  region         = get_env("AWS_REGION", "us-east-1")
  instance_type  = get_env("INSTANCE_TYPE", "t3.micro")
  ami_id         = get_env("AMI_ID", "ami-0c2b8ca1dad447f8a")
  key_name       = get_env("KEY_NAME", "sandbox-key")
  vpc_id         = get_env("VPC_ID", "vpc-xxxxxxxx")
  my_ip          = get_env("MY_IP", "your.public.ip.address/32")
  profile        = get_env("AWS_PROFILE", "default")
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
  profile       = local.profile
}
