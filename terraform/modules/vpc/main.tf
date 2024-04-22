locals {
  common_name             = format("%s+%s",var.common_name, var.application)
  len_public_subnets      = length(var.public_subnet_cidr)
  len_private_subnets     = length(var.private_subnet_cidr)
  all_tags                = var.common_tags
  vpc_id                  = aws_vpc.this.id                          
}

resource "aws_vpc" "this" {
    cidr_block            = var.cidr_block
    enable_dns_support    = true
    enable_dns_hostnames  = true        
    tags                  = merge({
    Name                  = format("%s-%s", local.common_name,"vpc")
  }, local.all_tags)
}


resource "aws_subnet" "public" {
  count                   = local.len_public_subnets
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = length(var.azs) != length(var.public_subnet_cidr) ? null : var.azs[count.index]
  tags                    = merge({
    Name                  = format("%s-%s-%d", local.common_name,"pub-sub",count.index)
  }, local.all_tags)
}

resource "aws_route_table" "public" {
  vpc_id                  = local.vpc_id
  tags                    = merge({
    Name                  = format("%s-%s", local.common_name,"pub-rt")
  }, local.all_tags)
}

resource "aws_route_table_association" "public" {
  count                   = local.len_public_subnets
  subnet_id               = element(aws_subnet.public[*].id, count.index)
  route_table_id          = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id          = aws_route_table.public.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.this.id
}

resource "aws_subnet" "private" {
  count                   = local.len_private_subnets
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = length(var.azs) != length(var.private_subnet_cidr) ? null : var.azs[count.index]
  tags                    = merge({
    Name                  = format("%s-%s-%d", local.common_name,"pri-sub",count.index)
  }, local.all_tags)
}

resource "aws_route_table" "private" {
  vpc_id                  = local.vpc_id
  tags                    = merge({
    Name                  = format("%s-%s", local.common_name,"pri-rt")
    }, local.all_tags)
}



resource "aws_route_table_association" "private" {
  count                   = local.len_private_subnets
  subnet_id               = element(aws_subnet.private[*].id, count.index)
  route_table_id          = aws_route_table.private.id
}



resource "aws_internet_gateway" "this" {
  vpc_id                  = local.vpc_id
  tags                    = merge({
      Name                  = format("%s-%s", local.common_name,"igw")
    }, local.all_tags)
}

resource "aws_nat_gateway" "this" {

  allocation_id           = aws_eip.nat.id
  subnet_id               = aws_subnet.public[0].id
  tags                    = merge({
      Name                  = format("%s-%s", local.common_name,"nat")
    }, local.all_tags)

}

resource "aws_eip" "nat" {
  domain                  = "vpc"
  tags                    = merge({
      Name                  = format("%s-%s", local.common_name,"eip")
    }, local.all_tags)
}  

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this.id
}