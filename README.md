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

9. # Project Setup Instructions

Thank you for your interest in our project! To get started, please follow the steps below to clone the repository and set up your development environment.

## Cloning the Repository

1. **Open a Terminal or Command Prompt**: You will need to use a command-line interface to clone the repository.

2. **Clone the Repository**: Run the following command to clone the repository to your local machine:

    ```bash
    git clone https://github.com/neerajmanivarnan/AWS-Infrastrucutre-provisioning-terraform.git
    ```

3. **Navigate to the Project Directory**: Change to the project directory with the following command:

    ```bash
    cd AWS-Infrastrucutre-provisioning-terraform
    ```

## Setup Instructions

### Configuring AWS Environment Variables

To set up your AWS access credentials, You must have an IAM User and create the Access key and secret access key.Follow the instructions below for your operating system.

### For Linux/macOS

1. **Open Your Terminal**.

2. **Set the Environment Variables**: Run the following commands:

    ```bash
    export AWS_ACCESS_KEY_ID="your-access-key-id"
    export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
    ```

    Replace `your-access-key-id` and `your-secret-access-key` with your actual AWS credentials.

3. **Verify the Environment Variables**: Check if the variables are set correctly by running:

    ```bash
    echo $AWS_ACCESS_KEY_ID
    echo $AWS_SECRET_ACCESS_KEY
    ```

4. **Persist the Environment Variables**: To make these variables persist across terminal sessions, add the export commands to your shell configuration file (`.bashrc`, `.zshrc`, etc.). For example, if you are using Bash, add the following lines to your `~/.bashrc` file:

    ```bash
    export AWS_ACCESS_KEY_ID="your-access-key-id"
    export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
    ```

    After editing the file, reload it with:

    ```bash
    source ~/.bashrc
    ```

### For Windows Command Prompt

1. **Open Command Prompt**.

2. **Set the Environment Variables**: Run the following commands:

    ```cmd
    set AWS_ACCESS_KEY_ID=your-access-key-id
    set AWS_SECRET_ACCESS_KEY=your-secret-access-key
    ```

    Replace `your-access-key-id` and `your-secret-access-key` with your actual AWS credentials.

3. **Verify the Environment Variables**: Check if the variables are set correctly by running:

    ```cmd
    echo %AWS_ACCESS_KEY_ID%
    echo %AWS_SECRET_ACCESS_KEY%
    ```

4. **Persist the Environment Variables**: To make these variables persist across Command Prompt sessions, set them in the system environment variables:

    - Open the **Start Menu**, search for **Environment Variables**, and select **Edit the system environment variables**.
    - In the **System Properties** window, click on the **Environment Variables** button.
    - Under **User variables** or **System variables**, click **New** and add the variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` with their corresponding values.
    - Click **OK** to save and apply the changes.




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




