resource "aws_lb" "app1_alb-Japan" {
  name               = "app1-alb-Japan"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app1-sg-LB01-Japan.id]
  subnets            = [
    aws_subnet.public-ap-northeast-1a.id,
    aws_subnet.public-ap-northeast-1c.id
  ]
  enable_deletion_protection = false
#Lots of death and suffering here, make sure it's false. Prevents terraform from deleting the load balancer, prevents accidental deletions

  tags = {
    Name    = "App1LoadBalancer-Japan"
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app1_alb-Japan.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"  # or whichever policy suits your requirements
  certificate_arn   = data.aws_acm_certificate.Japan_cert.arn



  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg-Japan.arn
  }
}



data "aws_acm_certificate" "Japan_cert" {
  domain   = "walidsite.com"
  statuses = ["ISSUED"]
}

