
resource "aws_security_group" "endpoints" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id
}

## VPC Endpoint Rules
resource "aws_security_group_rule" "vpce_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.endpoints.id
  cidr_blocks       = [var.vpc_cidr]

}

resource "aws_security_group_rule" "vpce_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.endpoints.id
  cidr_blocks       = ["0.0.0.0/0"]
}
