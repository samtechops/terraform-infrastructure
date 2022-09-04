# resource "aws_route53_record" "acm_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.public.zone_id

#   depends_on = [
#   aws_acm_certificate.wildcard
#   ]
# }

# resource "aws_acm_certificate" "wildcard" {
#   domain_name       = "*.lbo-fujitsu.ninja"
#   validation_method = "DNS"

#   tags = merge(
#     {
#       Name = "${local.component}-public-acm-certificate"
#     }, 
#     local.default_tags
#   )

#   lifecycle {
#     create_before_destroy = true
#   }

# }


# resource "aws_acm_certificate_validation" "wildcard_certification" {
#   certificate_arn = aws_acm_certificate.wildcard.arn

#   depends_on = [
#     aws_acm_certificate.wildcard
#   ]

# }
