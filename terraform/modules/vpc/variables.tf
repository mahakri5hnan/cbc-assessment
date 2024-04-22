variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "common_name" {
  type        = string
  
}

variable "common_tags" {
  description = "CIDR block for private subnets"
  type        = map(string)
}

variable "application" {
  type        = string
  
}
// vpc variables

# variable "vpc_name" {
#   description = "name for vpc and the resources that gets created within vpc"
#   type        = string
#   default     = "org-proj-reg-01" 
# }


variable "cidr_block" {
  description = "CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tags" {
  description = "CIDR block for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"] # Example CIDR blocks for two private subnets
}


// subnet variables


variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}


variable "public_subnet_cidr" {
  description = "CIDR block for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnets"
  type        = list(string)
}
