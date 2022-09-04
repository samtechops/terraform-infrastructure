
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${local.component}-public-route-table"
    }, 
    local.default_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${local.component}-private-route-table"
    }, 
    local.default_tags
  )
}

 resource "aws_route" "private" {
   route_table_id  = aws_route_table.private.id
   nat_gateway_id  = aws_nat_gateway.nat.id
   destination_cidr_block = "0.0.0.0/0"
}

 resource "aws_route" "public_igw" {
   route_table_id         = aws_route_table.public.id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.main.id
 }


 resource "aws_internet_gateway" "main" {
   vpc_id = aws_vpc.main.id

   tags = merge(
     {
       Name = "${local.component}-igw"
     }, 
     local.default_tags
   )
 }

 resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.neip.id
   subnet_id     = aws_subnet.public_subnet.id

   tags = merge(
     {
       Name = "${local.component}-nat-gateway"
     }, 
     local.default_tags
   )
 }

  resource "aws_eip" "neip"  {
   vpc   = true
}