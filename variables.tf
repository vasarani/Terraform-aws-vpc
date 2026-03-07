variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

variable "igw_tags" {
  type    = map(any)
  default = {}
}

variable "public_subnet_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "public_subnet_tags" {
  type = map 
  default = {}
}

variable "private_subnet_cidr" {
  type = list 
  default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "private_subnet_tags" {
  type = map 
  default = {}
}

variable "database_subnet_cidr" {
  type = list 
  default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "database_subnet_tags" {
  type = map 
  default = {}
}

variable "public_rt" {
  type = map 
  default = {}
}

variable "private_rt" {
  type = map 
  default = {}
}

variable "database_rt" {
  type = map 
  default = {}
}

variable "eip_tags" {
  type = map 
  default = {}
}

variable "nat_tags" {
  type = map 
  default = {}
}

variable "is_peering_required" {
  default = false
  type = bool
}

