// Define AWS provider
provider "aws" {
  region = "us-east-1"
}

// 1- create vpc
resource "aws_vpc" "myvpc" {
	cidr_block = var.vpc_cidr
	tags = {
		Name = var.vpc_name
	}
}

// 2- create internet gateway
resource "aws_internet_gateway" "myigw" {
	vpc_id = aws_vpc.myvpc.id
	tags = {
		Name = "myigw"
	}
}

// 3- create public route table
resource "aws_route_table" "public_route_table" {
	vpc_id = aws_vpc.myvpc.id
	tags = {
		Name = "Public Route Table"
	}	
}

// 4- create private route table
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.myvpc.id
	tags = {
		Name = "Private Route Table"
	}		
}

// 5- create public subnet
resource "aws_subnet" "public_subnet" {
	vpc_id                  = aws_vpc.myvpc.id
	cidr_block              = var.public_subnet
	map_public_ip_on_launch = true
	availability_zone       = var.vpc_az
	tags = {
		Name = "Public Subnet"
	}
}

// 6- create private subnet
resource "aws_subnet" "private_subnet" {
	vpc_id                  = aws_vpc.myvpc.id
	cidr_block              = var.private_subnet
	map_public_ip_on_launch = false
	availability_zone       = var.vpc_az
	tags = {
		Name = "Private Subnet"
	}
}

// 7- create public route
resource "aws_route" "public_route" {
	route_table_id         = aws_route_table.public_route_table.id
	gateway_id             = aws_internet_gateway.myigw.id
	destination_cidr_block = "0.0.0.0/0"
}

// 8- attach public route table to subnets Compute
resource "aws_route_table_association" "public_route_association" {
	subnet_id      = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public_route_table.id
}

// 9- create security group which allow ssh from 0.0.0.0/0
resource "aws_security_group" "security_group_1" {
	name        = "my-security-group-1"
  	description = "Allow inbound SSH"
	vpc_id = aws_vpc.myvpc.id
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
  	}
}

// 10- create security group that allow ssh and port 3000 from vpc cidr only 
resource "aws_security_group" "security_group_2" {
	name        = "my-security-group-2"
  	description = "Allow inbound SSH and port 3000"
	vpc_id = aws_vpc.myvpc.id
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = [var.vpc_cidr]
	}
	ingress {
		from_port   = 3000
		to_port     = 3000
		protocol    = "tcp"
		cidr_blocks = [var.vpc_cidr]
	}
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
  	}
}

// 11- create ec2(bastion) in public subnet with security group from 9
resource "aws_instance" "myec2_1" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  key_name        = "test-terraform"
  vpc_security_group_ids = [aws_security_group.security_group_1.id]
  subnet_id       = aws_subnet.public_subnet.id
  
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  
  tags = {
    Name = "my_ec2_1"
  }
}


// 12- create ec2(application) private subnet with security group from 10
resource "aws_instance" "myec2_2" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  key_name        = "test-terraform"
  vpc_security_group_ids = [aws_security_group.security_group_2.id]
  subnet_id       = aws_subnet.private_subnet.id
  
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  
  tags = {
    Name = "my_ec2_2"
  }
}