resource "aws_route53_record" "go-app" {
  zone_id = data.aws_route53_zone.public.zone_id
  name       = "go-app.${data.aws_route53_zone.public.name}"
  type       = "CNAME"
  ttl        = "300"
  records    = [aws_lb.alb.dns_name]

}


