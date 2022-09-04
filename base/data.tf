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

# data "aws_route53_zone" "public" {
#   name         = "lbo-fujitsu.ninja"
#   private_zone = false
# }

