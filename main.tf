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

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "random_pet" "pet" {
  length = 1
}

resource "aws_security_group" "instances" {
  name   = "${var.security_group_name}-${random_pet.pet.id}"
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
  # netdata monitoring
  ingress {
    description = "netdata from internet"
    from_port   = 19999
    to_port     = 19999
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

resource "aws_instance" "nomad_server" {
  count                  = var.nomad_server_count
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.generated_key.key_name
  root_block_device {
    volume_size = 100
    volume_type = "io1"
    iops        = 1000
  }
  user_data = templatefile("cloudinit_nomad_server.yaml", {
    nomad_bootstrap_expect = var.nomad_server_count,
    nomad_retry_join       = "provider=aws tag_key=Name tag_value=nomad_server_${random_pet.pet.id}"
  })
  tags = {
    Name = "nomad_server_${random_pet.pet.id}"
  }
}

resource "aws_instance" "client" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.generated_key.key_name
  root_block_device {
    volume_size = 100
    volume_type = "io1"
    iops        = 1000
  }
  user_data = templatefile("cloudinit_client.yaml", {
    nomad_retry_join = "provider=aws tag_key=Name tag_value=nomad_server_${random_pet.pet.id}"
  })
  tags = {
    Name = "nomad_client_${random_pet.pet.id}"
  }
}
