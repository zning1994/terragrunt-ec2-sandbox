output "sandbox_instance_id" {
  value = aws_instance.sandbox.id
}

output "sandbox_public_ip" {
  value = aws_instance.sandbox.public_ip
}
