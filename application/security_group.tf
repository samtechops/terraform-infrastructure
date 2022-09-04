resource "aws_security_group" "ec2" {
  name        = "${local.component}-ec2-sg"
  description = "Security group for the ${local.component} ec2"
  vpc_id      = data.terraform_remote_state.base.outputs.vpc_id

}


## VPC Endpoint Rules
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = [var.vpc_cidr]

}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "alb_sg" {
  name        = "${local.component}-alb-sg"
  description = "Security group for the ${local.component} alb"
  vpc_id      = data.terraform_remote_state.base.outputs.vpc_id

}

## VPC Endpoint Rules
resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  source_security_group_id        = aws_security_group.ec2.id
}
