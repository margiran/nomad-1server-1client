output "private_key_pem" {
  value       = tls_private_key.private_key.private_key_pem
  description = "The private key (save this in a .pem file) for ssh to instances"
  sensitive   = true
}

output "server_public_ip" {
  value       = aws_instance.server.public_ip
  description = "The public IP of the EC2 Instance "
}

output "server_private_ip" {
  value       = aws_instance.server.private_ip
  description = "The private IP of the EC2 Instance "
}

output "client_public_ip" {
  value       = aws_instance.client.public_ip
  description = "The public IP of the EC2 Instance client "
}

output "client_private_ip" {
  value       = aws_instance.client.private_ip
  description = "The private IP of the EC2 Instance client"
}
output "ssh_server_public_ip" {
  value       = "ssh ubuntu@${aws_instance.server.public_ip} -i ~/.ssh/terraform.pem"
  description = "Command for ssh to the Server public IP of the EC2 Instance"
}
