# Modularized Terraform Project
- All resources follow the naming standard `org-proj-env-app-resource`
- Each resource is tagged with "organisation" and "project" for easier identification and management.
- Variables like common_name and application are used to dynamically generate resource names when creating resources.

## Modules

### VPC Module

- The VPC module handles the creation of the Virtual Private Cloud and its dependent resources, such as subnets, route tables, NAT gateways, and Internet gateways.
- It is designed to support any number of public or private subnets.
- Subnet availability zones can be defined either statically or dynamically.
- Public subnets have an Internet gateway attached to their route tables.
- Private subnets have a NAT gateway attached to their route tables.

### EC2_Instance Module

- This module manages the creation of EC2 instances and their corresponding security groups.
- Each instance is created individually by the module.
- The creation of a new security group or using an existing one is optional, controlled by the variables `create_security_grp` and `existing_security_grp`.
- If a key pair name is provided, it will be used to access the created EC2 instance; otherwise, the instance will be created without a key pair.

### RDS module

- The RDS module creates an RDS instance with a MySQL engine, along with its corresponding subnet group and security group.
- The username and password are retrieved from the AWS Systems Manager (SSM) Parameter Store for enhanced security. The parameter keys for these can be passed via variables.

### ALB module

- The ALB module creates an Application Load Balancer (ALB) with its target group, configured listeners, and security group.
- Currently, this ALB module allows traffic only on port 80 and creates a security group that permits this traffic from any IP address.
- You can map any number of instances to this ALB.