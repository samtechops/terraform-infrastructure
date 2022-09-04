## Role
resource "aws_iam_role" "main" {
  name               = "ec2-instance-${local.component}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


resource "aws_iam_instance_profile" "main" {
  name = "instance-profile"
  role = aws_iam_role.main.name
}

## ecr Resources
resource "aws_iam_policy" "ecr_policy" {
  name   = "ecr-policy"
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role_policy_attachment" "ecr_attachment" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

## Cloudwatch Resources
resource "aws_iam_policy" "cloudwatch" {
  name   = "cloudwatch-policy"
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}



