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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  key_name               = aws_key_pair.generated_key.key_name
  user_data              = templatefile("cloudinit_server.yaml", { bootstrap_expect = 1 })
  tags = {
    Name = "nomad server "
  }
}

resource "aws_instance" "client" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  key_name               = aws_key_pair.generated_key.key_name
  user_data              = templatefile("cloudinit_client.yaml", { server_ip = aws_instance.server.private_ip })
  tags = {
    Name = "nomad client "
  }
}

resource "aws_security_group" "instances" {
  name   = var.security_group_name
  vpc_id = data.aws_vpc.default.id
  # opening port used by nomad agents 
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # opening port used by nomad agents 
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # opening port 22 to be able to ssh to the instances
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # provide internet access to the instance (install packages, etc)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

