terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.private_key.public_key_openssh
  provisioner "local-exec" { 
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ~/.ssh/terraform.pem"
  }
}
resource "aws_instance" "server" {
  ami                     = var.ami
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.instance.id]
  key_name                = aws_key_pair.generated_key.key_name
  user_data               = templatefile("cloudinit.yaml",{bootstrap_expect = 1})
  tags = {
    Name = "nomad server"
  }
}
resource "aws_instance" "client" {
  ami                     = var.ami
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.instance.id]
  key_name                = aws_key_pair.generated_key.key_name
  user_data               =templatefile("cloudinit_client.yaml",{ server_ip = aws_instance.server.public_ip })
  tags = {
    Name = "nomad client"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name
  vpc_id = data.aws_vpc.default.id
  # ingress {
  #   from_port   = var.server_port
  #   to_port     = var.server_port
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}