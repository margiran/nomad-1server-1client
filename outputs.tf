output "instance_public_ip" {
  value       = aws_instance.server.public_ip
  description = "The public IP of the EC2 Instance "
}
output "instance_private_ip" {
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