################### HQ ################################################################
// VM vars
variable "hq_instance_name" {
  type = string
  default = "hq-server"
}

variable "hq_zone" {
  type = string
  //Warsaw
  default = "europe-central2-a"
}

//Net Vars
variable "hq_network_name" {
type = string
default = "headquarters-vpc"
}

#Subnet 1
variable "hq_subnet" {
    type = string
    default = "subnet1"
}

variable "hq_ip" {
    type = string
    default = "10.187.1.0/24"
}


######################  Asia ###############################################################
//VM vars
variable "asia_instance_name" {
  type = string
  default = "asia-vm"
}

variable "asia_zone" {
  type = string
  //Tokyo
  default = "asia-northeast1-b"
}

//Net Vars
variable "asia_vpc_name" {
type = string
default = "asia-vpc"
}

#Subnet 1
variable "asia_subnet_name" {
    type = string
    default = "subnet1"
}

variable "asia_ip" {
    type = string
    default = "192.168.1.0/24"
}



#################### Americas ##########################################################33
//VM Vars
variable "americas_instance_name" {
  type = string
  default = "american-instance1"
}

variable "americas_instance_name2" {
  type = string
  default = "american-instance2"
}

variable "americas_zone" {
  type = string
  default = "us-central1-a"
}

//Network Vars
variable "americas_network_name" {
type = string
default = "americas-vpc"
}

//Subnet1
variable "americas_subnet1_name" {
    type = string
    default = "americas-subnet1"
}

variable "americas_ip1" {
    type = string
    default = "172.16.32.0/24"
}

//Subnet 2 (SPECIAL)
variable "americas_subnet2_name" {
    type = string
    default = "americas-subnet2"
}

variable "americas_ip2" {
    type = string
    default = "172.16.76.0/24"
}

variable "americas_subnet_2_region" {
    type = string
    default = "us-central1"
}