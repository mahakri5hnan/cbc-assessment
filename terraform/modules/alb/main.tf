locals {
  alb_name                      = format("%s-%s-%s",var.common_name, var.application,"alb")
}

# Define Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name                         = format("%s-sg",local.alb_name)
  description = "Security group for the ALB"

  ingress {
    from_port                  = 80
    to_port                    = 80
    protocol                   = "tcp"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }
}

# Define Application Load Balancer
resource "aws_lb" "alb" {
  name                        = local.alb_name
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.alb_sg.id]
  subnets                     = var.alb_subenet_id
  enable_deletion_protection  = false
}

# Define the Target Group
resource "aws_lb_target_group" "target_group" {
  name                        = format("%s-tg",local.alb_name)
  port                        = 80
  protocol                    = "HTTP"
  vpc_id                      = var.alb_vpc_id  # Replace with your VPC ID
}

# Add EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "ec2_instance" {
  count                       = length(var.alb_target_ins_ids)
  target_group_arn            = aws_lb_target_group.target_group.arn
  target_id                   = var.alb_target_ins_ids[count.index]
}

# Define the ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn           = aws_lb.alb.arn
  port                        = 80
  protocol                    = "HTTP"
  default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.target_group.arn
  }
}
