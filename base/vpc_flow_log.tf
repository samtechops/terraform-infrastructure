resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_cloudwatch_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_cloudwatch_group" {
  name = "/aws/vpc/${local.component}"
}