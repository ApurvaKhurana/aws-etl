
/* locals {
  for subnet in var.required_subnets : public_subnet_count = public_subnet_count + 1  if regex("*public*", subnet)
  } */

//fetch reference to public subnets
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.my_vpc.id]
  }
  tags = {
    Name = "public-*"
  }
}

//fetch reference to private subnets
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.my_vpc.id]
  }
  tags = {
    Name = "private-*"
  }
}