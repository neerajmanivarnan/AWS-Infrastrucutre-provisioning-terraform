# AWS Infrastructure Provisioning with Terraform

This project demonstrates how to provision a basic AWS infrastructure using Terraform. The infrastructure includes a VPC, subnets, an internet gateway, a custom route table, a security group, an elastic IP, and an EC2 instance running a web server.

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
