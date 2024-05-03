


variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "my-vpc-network"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "my-subnet"
}

variable "zone" {
  description = "The region where resources will be deployed"
  type        = string
  default     = "us-central1-a"
}










variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "web-server"
}

