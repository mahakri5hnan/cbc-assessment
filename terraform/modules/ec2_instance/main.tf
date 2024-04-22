locals {
  instance_name         = format("%s-%s-%s", var.common_name, var.application, "ec2")
  all_tags              = var.common_tags
}

resource "aws_security_group" "ec2_sg" {
  count                 = var.create_security_grp ? 1 : 0
  name                  = format("%s-sg",local.instance_name)

  ingress {
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  ingress {
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
  }

  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "instance" {
  ami                   = var.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id 
  key_name              = var.key_pair != null ? var.key_pair : null
  security_groups       = var.create_security_grp ? [aws_security_group.ec2_sg[0].id] : [var.existing_security_grp]
  tags                  = merge({
    Name                = local.instance_name
  }, local.all_tags)

}

