resource "aws_lb" "app1_alb-Hong" {
    provider = aws.ap-east-1
  name               = "app1-alb-Hong"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app1-sg-LB01-Hong.id]
  subnets            = [
    aws_subnet.public-ap-east-1a.id,
    aws_subnet.public-ap-east-1b.id
  ]
  enable_deletion_protection = false
#Lots of death and suffering here, make sure it's false. Prevents terraform from deleting the load balancer, prevents accidental deletions

  tags = {
    Name    = "App1LoadBalancer-Hong"
  }
}
resource "aws_lb_listener" "https-Hong" {
    provider = aws.ap-east-1
  load_balancer_arn = aws_lb.app1_alb-Hong.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg-Hong.arn
  }
}

output "LB-Hong" { # Hong dns name
  value     =  aws_lb.app1_alb-Hong.dns_name
}


