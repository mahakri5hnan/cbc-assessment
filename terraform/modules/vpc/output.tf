
output "vpc_id" {
  value = aws_vpc.this.id   
  description = "vpc id"
}


output "public_subnet_ids" {
  value = aws_subnet.public[*].id 
  description = "List of all public subnet IDs"
}


output "private_subnet_ids" {
  value = aws_subnet.private[*].id 
  description = "List of all public subnet IDs"
}