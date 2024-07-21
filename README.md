# AWS Infrastructure Provisioning with Terraform

This project demonstrates how to provision a basic AWS infrastructure using Terraform. The infrastructure includes a VPC, subnets, an internet gateway, a custom route table, a security group, an elastic IP, and an EC2 instance running a web server.This readme file provides the necessary commands and steps to apply the Terraform configuration, making it easy to follow and execute.

## Prerequisites

- Terraform installed on your local machine
- AWS CLI configured with appropriate access credentials
- A key pair created in the AWS region you plan to use (e.g., `main-key`)

## Infrastructure Overview

1. **VPC**: A Virtual Private Cloud with a CIDR block of `10.0.0.0/16`.
2. **Internet Gateway**: To enable internet access for the VPC.
3. **Route Table**: Custom route table to route internet traffic.
4. **Subnet**: A public subnet within the VPC.
5. **Security Group**: Allowing inbound traffic on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS).
6. **Network Interface**: Attached to the subnet with a private IP.
7. **Elastic IP**: Associated with the network interface.
8. **EC2 Instance**: An Ubuntu server running Apache web server.

## Terraform Configuration

### 1. Provider Configuration

```hcl
provider "aws" {
  region = "us-east-1"
}
```
### 2. Virtual private cloud

```hcl
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Production VPC"
  }
}
```

### 3.Internet gateway

```hcl
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "main"
  }
}
```

### 4.Route table

```hcl
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routing table"
  }
}
```

### 5.Subnet

```hcl
resource "aws_subnet" "prod-subnet" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "production subnet"
  }
}
```

### 6.Route table association

```hcl
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.route-table.id
}
```

### 7.Security group

```hcl
resource "aws_security_group" "security_group_main" {
  name   = "security group"
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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
```

### 8.Network interface

```hcl
resource "aws_network_interface" "network_interface" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.security_group_main.id]
}
```

### 9.Elastic IP

```hcl
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.network_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}
```

### 10.EC2 instance with web server

```hcl
resource "aws_instance" "web-server-instance" {
  ami               = "ami-04a81a99f5ec58529"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network_interface.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo This is my very first web server that I am going to test > /var/www/html/index.html'
              EOF

  tags = {
    Name = "web-server"
  }
}
```

# Applying the Configuration

To apply the AWS infrastructure provisioning configuration using Terraform, follow these steps:

## Step 1: Initialize Terraform

Run the following command to initialize Terraform. This will download the necessary provider plugins and set up the backend for storing the Terraform state.

```sh
terraform init
```

## Step 2: Plan the infrastructure

```sh
terraform plan
```

## Step 3: Apply the configuration

```sh
terraform plan
```

## Step 4: Cleaning up

Make sure the destroy the configuration as it can incur charges(Even though everything comes under free-tier)

```sh
terraform destroy
```




