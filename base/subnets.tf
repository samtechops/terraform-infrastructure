
###
## Public Subnets
###
resource "aws_subnet" "public_subnet" {
  availability_zone = var.availability_zone
  cidr_block = "10.0.0.0/24"
  vpc_id               = aws_vpc.main.id
  
  tags = merge(
    {
      Name = "${local.component}-public-subnet",
    }, 
    local.default_tags
  )
}

resource "aws_subnet" "public_subnet_2" {
  availability_zone = "eu-west-1b"
  cidr_block = "10.0.2.0/24"
  vpc_id               = aws_vpc.main.id
  
  tags = merge(
    {
      Name = "${local.component}-public-subnet_2",
    }, 
    local.default_tags
  )
}

###
## private Subnet
###
resource "aws_subnet" "private_subnet" {
  availability_zone = var.availability_zone
  cidr_block = "10.0.1.0/24"
  vpc_id               = aws_vpc.main.id
  
  tags = merge(
    {
      Name = "${local.component}-private-subnet",
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


resource "aws_route_table_association" "public_route_table_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private_route_table" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}