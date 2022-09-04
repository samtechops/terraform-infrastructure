
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  policy            = data.aws_iam_policy_document.s3_vpce_source.json

  tags = merge(
    {
      "Name" = "s3"
    },
  )
}

resource "aws_vpc_endpoint_route_table_association" "private_route_table_s3" {
  route_table_id    = aws_route_table.private.id
  vpc_endpoint_id   = aws_vpc_endpoint.s3.id
}


resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private_subnet.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "logs"
    },

  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private_subnet.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "ec2messages"
    },

  )
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private_subnet.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "ec2"
    },

  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private_subnet.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "ecr-dkr"
    },

  )
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private_subnet.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "ecr-api"
    },

  )
}
