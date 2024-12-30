variable "vpc_cidr" {
  type=string
  default="10.0.0.0/16" #roboshop
}

variable "enable_dns_hostnames" {
 type=bool
 default = true
}

variable "common_tags" {
 type=map
 default = {} #it is optional 
}


variable "vpc_tags" {
 type=map
 default = {} #it is optional 
}

variable "project_name" {
  type=string  # it is mandatory filed , need tp pass value from user
}

variable "environment" {
  type=string
}

variable "igw_tags" {
  default={}
}

variable "public_subnet_cidr" {
  type= list
  validation {
    condition = length(var.public_subnet_cidr) == 2
    error_message = "Please give valid count of public subnet cidr"
  }
}

variable "public_subnet_tags" {
  default={}
}

variable "private_subnet_cidr" {
  type= list
  validation {
    condition = length(var.private_subnet_cidr) == 2
    error_message = "Please give valid count of private subnet cidr"
  }
}

variable "private_subnet_tags" {
  default={}
}



variable "database_subnet_cidr" {
  type= list
  validation {
    condition = length(var.database_subnet_cidr) == 2
    error_message = "Please give valid count of private subnet cidr"
  }
}

variable "databse_subnet_tags" {
  default={}
}

variable "natgateway_tags" {
  default={}
}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
  default = {}
}

variable "is_peering_requried" {
  type=bool
  default = false
}

variable "acceptor_vpc_id" {
  type=string
  default=""
}

variable "vpc_peering_tags" {
  default = {}
}