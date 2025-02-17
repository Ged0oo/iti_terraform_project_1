# Terraform AWS VPC Setup and EC2 Instances

This Terraform configuration sets up the following AWS resources:

1. **VPC**: A Virtual Private Cloud (VPC) with both public and private subnets.
2. **Internet Gateway**: A gateway that allows communication between instances in the VPC and the internet.
3. **Route Tables**: Separate route tables for public and private subnets.
4. **Security Groups**: Two security groups—one for a bastion EC2 instance allowing SSH from anywhere, and another for an application EC2 instance allowing SSH and port 3000 from the VPC CIDR only.
5. **EC2 Instances**: Two EC2 instances:
   - A **Bastion** instance in the public subnet.
   - An **Application** instance in the private subnet.

---

## Prerequisites

1. **Terraform** installed on your local machine.
2. An **AWS** account with appropriate IAM permissions.
3. **AWS CLI** configured with access keys for your AWS account.
4. Create an S3 bucket for the Terraform state file and a DynamoDB table for state locking.

---

## Components and Resources

### 1. **VPC (aws_vpc)**
   - Creates a VPC with a custom CIDR block (`10.0.0.0/16`).
   - The VPC spans one availability zone (`us-east-1a`).

### 2. **Internet Gateway (aws_internet_gateway)**
   - An internet gateway is created and attached to the VPC to allow instances in the VPC to access the internet.

### 3. **Route Tables (aws_route_table)**
   - **Public Route Table**: Allows outbound traffic from the public subnet to the internet through the internet gateway.
   - **Private Route Table**: Is created for the private subnet, but no outbound internet route is configured by default.

### 4. **Subnets (aws_subnet)**
   - **Public Subnet**: A subnet with a CIDR block (`10.0.1.0/24`) configured to map public IPs automatically on instance launch.
   - **Private Subnet**: A subnet with a CIDR block (`10.0.2.0/24`) where no public IP is assigned automatically to instances.

### 5. **Security Groups (aws_security_group)**
   - **Security Group 1**: Allows inbound SSH (port 22) from any IP (`0.0.0.0/0`) for the bastion EC2 instance.
   - **Security Group 2**: Allows inbound SSH (port 22) and port 3000 only from within the VPC CIDR block for the application EC2 instance.

### 6. **EC2 Instances (aws_instance)**
   - **Bastion EC2 Instance**: Launched in the public subnet, using **Security Group 1**, with SSH access from anywhere.
   - **Application EC2 Instance**: Launched in the private subnet, using **Security Group 2**, with SSH and port 3000 access from within the VPC CIDR.

---

## Outputs

- **vpc_id**: The ID of the created VPC.
- **public_subnet_id**: The ID of the created Public Subnet.
- **private_subnet_id**: The ID of the created Private Subnet.
- **internet_gateway_id**: The ID of the created Internet Gateway.
- **public_route_table_id**: The ID of the Public Route Table.
- **private_route_table_id**: The ID of the Private Route Table.
- **bastion_public_ip**: The public IP of the Bastion EC2 instance.
- **application_public_ip**: The public IP of the Application EC2 instance (if any).
- **bastion_instance_id**: The ID of the Bastion EC2 instance.
- **application_instance_id**: The ID of the Application EC2 instance.

---

## Steps to Deploy

1. **Configure AWS CLI**: Ensure that AWS CLI is configured with your AWS credentials (`aws configure`).
2. **Initialize Terraform**:
   ```bash
   terraform init
