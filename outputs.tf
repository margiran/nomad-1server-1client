output "private_key_pem" {
  description = "The private key (save this in a .pem file) for ssh to instances"
  value       = tls_private_key.private_key.private_key_pem
  sensitive   = true
}

output "server_public_ip" {
  description = "The public IP of the EC2 Instance "
  value       = aws_instance.server[*].public_ip
}

output "server_private_ip" {
  description = "The private IP of the EC2 Instance "
  value       = aws_instance.server[*].private_ip
}

output "client_public_ip" {
  description = "The public IP of the EC2 Instance client "
  value       = aws_instance.client.public_ip
}

output "client_private_ip" {
  description = "The private IP of the EC2 Instance client"
  value       = aws_instance.client.private_ip
}

output "ssh_server_public_ip" {
  description = "Command for ssh to the Server public IP of the EC2 Instance"
  value       = [ 
    for k in aws_instance.server : "ssh ubuntu@${k.public_ip} -i ~/.ssh/terraform.pem"
  ]
}

output "ssh_client_public_ip" {
  description = "Command for ssh to the Client public IP of the EC2 Instance"
  value       = "ssh ubuntu@${aws_instance.client.public_ip} -i ~/.ssh/terraform.pem"
}
