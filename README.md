# DevOps Infrastructure Modules

This repository contains Terraform modules for setting up the infrastructure of the World of Games (WoG) project. The infrastructure is designed to be deployed on AWS using Terragrunt to manage dependencies and environments. The modules are organized into the following components:

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

### Prerequisites
- Ensure you have [Terraform](https://www.terraform.io/downloads.html) and [Terragrunt](https://terragrunt.gruntwork.io/) installed.
- AWS credentials configured for your environment.

### Deployment Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/your-org/wog-infrastructure-modules.git
   cd wog-infrastructure-modules
2. Navigate to the desired environment directory (e.g., dev, staging, prod).

3. Initialize the Terragrunt environment:
terragrunt init
4. Apply the infrastructure changes:
terragrunt apply-all

### Outputs
After deployment, the output values will be printed to the console. These values include VPC IDs, subnet IDs, security group IDs, and public/private IPs of the EC2 instances.

### Contributing

Feel free to open issues or submit pull requests to improve this repository.