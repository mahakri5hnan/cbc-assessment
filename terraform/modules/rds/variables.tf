variable "common_name" {
  type        = string
  
}

variable "rds_instance_class" {
    type = string
  
}
variable "application" {
  type        = string
  
}

variable "rds_storage" {
    type = number
  
}

variable "rds_subnet_id" {
    type = list(string)
  
}


variable "rds_vpc_id" {
    type = string
  
}

variable "rds_ssm_username" {
    type = string
  
}

variable "rds_ssm_password" {
    type = string
  
}