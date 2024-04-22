locals {
  rds_name = format("%s-%s-%s", var.common_name, var.application, "rds-mysql")
}



data "aws_ssm_parameter" "db_password" {
  name = var.rds_ssm_username
  with_decryption = true  
}

data "aws_ssm_parameter" "db_username" {
  name = var.rds_ssm_password
}



resource "aws_db_instance" "my_rds" {
  identifier         = local.rds_name
  engine             = "mysql"
  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_storage
  username           = data.aws_ssm_parameter.db_username.value
  password           = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az           = false  
  publicly_accessible = false  
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = format("%s-sub-grp",local.rds_name)
  description = "RDS subnet group"
  subnet_ids  = var.rds_subnet_id
}

resource "aws_security_group" "rds_sg" {
  vpc_id = var.rds_vpc_id

  ingress {
    from_port   = 3306  # MySQL port, adjust as needed
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust for your security needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
