variable "org-proj-env" {
  default = "org-projx-dev"
}
variable "region" {
  default = "us-east"
}

locals {
  common_name         = format("%s", var.org-proj-env)
  vpc_id              = ""   
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  common_tags         = { "organisation" : "OrgA", "project" : "projectX" }    

}

provider "aws" {
  region              = var.region
}

module "vpc" {
  source              = "../modules/vpc"
  application         = "common"
  common_name         = local.common_name  
  cidr_block          = "10.0.0.0/16"
  azs                 = ["us-east-1a, us-east-1b"]
  common_tags         = local.common_tags
  public_subnet_cidr  = ["10.0.1.0/24", "10.2.1.0/24"]
  private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "web_instance" { 
  source              = "../modules/ec2_instance"
  common_name         = local.common_name  
  application         = "web"  
  ami                 = "svsd"
  instance_type       = "t2-micro"
  create_security_grp = true
  subnet_id           = local.public_subnet_ids[0]
  common_tags         = local.common_tags
}

module "api_instance" { 
  source              = "../modules/ec2_instance"
  common_name         = local.common_name  
  application         = "api"    
  ami                 = ""
  instance_type       = "t2-micro"
  create_security_grp = true
  subnet_id           = local.public_subnet_ids[1]
  common_tags         = local.common_tags
}

module "common_alb" {
  source              = "../modules/alb"
  common_name         = local.common_name  
  application         = "common"    
  alb_vpc_id          = local.vpc_id
  alb_subenet_id      = local.public_subnet_ids
  alb_target_ins_ids  = [module.api_instance.instance_ids, module.web_instance.instance_ids]
  }


module "api_database" { 
  source              = "../modules/rds"
  common_name         = local.common_name  
  application         = "api"    
  rds_instance_class  = "db.t4g.large"
  rds_storage         = 30
  rds_subnet_id       = local.private_subnet_ids
  rds_vpc_id          = local.vpc_id
  rds_ssm_username    = "/orgA/projX/apidb/username"
  rds_ssm_password    = "/orgA/projX/apidb/password"
}


