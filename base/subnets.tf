
###
## Public Subnets
###
resource "aws_subnet" "public_subnet" {
  availability_zone = var.availability_zone
  cidr_block = "10.0.1.0/24"
  vpc_id               = aws_vpc.main.id
  
  tags = merge(
    {
      Name = "${local.component}-public-subnet",
    }, 
    local.default_tags
  )
}

###
## Route table associations
###
resource "aws_route_table_association" "public_route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}