
data "aws_route53_zone" "main" {
  name         = "walidsite.com"  # The domain name you want to look up
  private_zone = false
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "walidsite.com"
  type    = "A"

  alias {
    name                   = aws_lb.app1_alb-Japan.dns_name
    zone_id                = aws_lb.app1_alb-Japan.zone_id
    evaluate_target_health = true
  }
}








