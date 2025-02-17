variable "vpc_name" {
	description = "Name of the VPC"
	type        = string
	default     = "MyVPC"
}

variable "vpc_az" {
	type = string  
	default = "us-east-1a"
}

variable "vpc_cidr" {
	type = string  
	default = "10.0.0.0/16"
}

variable "public_subnet" {
	type = string  
	default = "10.0.1.0/24"
}

variable "private_subnet" {
	type = string  
	default = "10.0.2.0/24"
}