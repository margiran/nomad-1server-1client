variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "nomad-1server-1client-sg"
}

variable "server_instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "client_instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "consul_server_count" {
  description = "The number of consul servers"
  type        = number
  default     = 1
}

variable "nomad_server_count" {
  description = "The number of servers"
  type        = number
  default     = 1
}