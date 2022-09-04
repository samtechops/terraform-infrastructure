output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnet.cidr_block
}