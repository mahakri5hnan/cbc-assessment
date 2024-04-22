variable "common_name" {
  type        = string
  
}
variable "application" {
  type        = string
  
}


variable "alb_subenet_id" {
    type = list(string)
    default = []
  
}

variable "alb_vpc_id" {
    type = string
    default = ""
  
}

variable "alb_target_ins_ids" {
    type = list(string)
    default = []
  
}

variable "alb_target_port" {
    default = 80
  
}

variable "alb_listener_port" {
    default = 80
      
}