# DevOps Infrastructure Modules

This repository contains Terraform modules for setting up the infrastructure of the World of Games (WoG) project. The infrastructure is designed to be deployed on AWS, providing reusable and scalable components for building and managing your environment. The modules are organized into the following components:

## Table of Contents
1. [Modules Overview](#modules-overview)
   - [Network Module](#1-network-module)
   - [Security Module](#2-security-module)
   - [Servers Module](#3-servers-module)
   - [VPN Module (Optional)](#4-vpn-module-optional)
2. [Usage](#usage)
   - [Outputs](#outputs)
3. [Getting Started](#getting-started)
4. [Prerequisites](#prerequisites)
5. [Contributing](#contributing)
6. [License](#license)

## Modules Overview

### 1. Network Module
This module is responsible for creating and managing the VPC and networking resources, including:
- **VPC**: The primary network for the environment.
- **Subnets**: Public and private subnets distributed across availability zones.
- **Internet Gateway**: Allows outbound internet access for resources in the public subnet.
- **NAT Gateway**: Provides internet access for resources in the private subnet.
- **Route Tables**: Configures routing for public and private subnets.

#### Outputs:
- VPC ID
- Subnet IDs (Public and Private)
- NAT Gateway IDs
- Elastic IPs for NAT Gateway and k8s node

### 2. Security Module
This module defines security groups for controlling inbound and outbound traffic to the instances and other resources.

#### Components:
- **Security Groups**: Defines rules for accessing the k3s node, RDS database, and other servers.

#### Outputs:
- Security Group IDs for various resources

### 3. Servers Module
This module handles the deployment of EC2 instances for the k3s node, GitHub runner, and other necessary servers.

#### Components:
- **EC2 Instances**: Launches instances with the specified AMI, instance type, and user data scripts.
- **User Data Scripts**: Initializes the instances with necessary configurations (e.g., installing k3s).

#### Outputs:
- EC2 Instance IDs
- Public and Private IPs

### 4. VPN Module (Optional)
This module sets up a VPN to securely access the private resources in the VPC.

#### Components:
- **VPN Gateway and Connection**: Establishes a secure connection to the VPC.
- **Certificates**: Manages the server and client certificates required for VPN authentication.

#### Outputs:
- VPN connection details
- Certificate ARNs

## Usage
Each module is self-contained and can be integrated into larger infrastructure configurations.

### Outputs
After deployment, the output values will be printed to the console. These values include VPC IDs, subnet IDs, security group IDs, and public/private IPs of the EC2 instances.

## Getting Started
1. Clone the repository.
2. Configure the necessary variables for your environment.
3. Use Terraform to plan and then deploy each module:
   ```bash
   terraform plan
   terraform apply
    ```
## Prerequisites
- Terraform >= 0.13
- AWS account with proper IAM permissions

### Contributing
Feel free to contribute by submitting issues or pull requests.

### License
This project is licensed under the MIT License.