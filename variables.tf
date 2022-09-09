variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-nomad-1server-1client"
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default = "t2.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 4646
}
