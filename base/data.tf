data "aws_iam_policy_document" "s3_vpce_source" {
  statement {
    sid = "AccessToBuckets"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["*"]

  }
}  
