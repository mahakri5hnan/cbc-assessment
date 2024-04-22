variable "common_name" {
  type        = string
  
}
variable "application" {
  type        = string
  
}

variable "common_tags" {
    type        = map(string)
}

variable "subnet_id" {
    type        = string
}

variable "create_security_grp" {
    type        = bool
}

variable "instance_type" {
    type        = string
}

variable "ami" {
    type        = string

}

variable "key_pair" {
    type        = string
    default     = null

}

variable "existing_security_grp" {
    type        = string
    default     = null

}
