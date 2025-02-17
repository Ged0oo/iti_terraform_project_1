// Output VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.myvpc.id
}

// Output Public Subnet ID
output "public_subnet_id" {
  description = "The ID of the created Public Subnet"
  value       = aws_subnet.public_subnet.id
}

// Output Private Subnet ID
output "private_subnet_id" {
  description = "The ID of the created Private Subnet"
  value       = aws_subnet.private_subnet.id
}

// Output Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway"
  value       = aws_internet_gateway.myigw.id
}

// Output Public Route Table ID
output "public_route_table_id" {
  description = "The ID of the Public Route Table"
  value       = aws_route_table.public_route_table.id
}

// Output Private Route Table ID
output "private_route_table_id" {
  description = "The ID of the Private Route Table"
  value       = aws_route_table.private_route_table.id
}

// Output Bastion EC2 Public IP
output "bastion_public_ip" {
  description = "The public IP of the Bastion EC2 instance"
  value       = aws_instance.myec2_1.public_ip
}

// Output Application EC2 Public IP
output "application_public_ip" {
  description = "The public IP of the Application EC2 instance"
  value       = aws_instance.myec2_2.public_ip
}

// Output Bastion EC2 Instance ID
output "bastion_instance_id" {
  description = "The ID of the Bastion EC2 instance"
  value       = aws_instance.myec2_1.id
}

// Output Application EC2 Instance ID
output "application_instance_id" {
  description = "The ID of the Application EC2 instance"
  value       = aws_instance.myec2_2.id
}
