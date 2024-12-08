resource "aws_lb" "app1_alb-Cali" {
    provider = aws.us-west-1
  name               = "app1-alb-Cali"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app1-sg-LB01-Cali.id]
  subnets            = [
    aws_subnet.public-us-west-1b.id,
    aws_subnet.public-us-west-1c.id
  ]
  enable_deletion_protection = false
#Lots of death and suffering here, make sure it's false. Prevents terraform from deleting the load balancer, prevents accidental deletions

  tags = {
    Name    = "App1LoadBalancer-Cali"
  }
}
resource "aws_lb_listener" "https-Cali" {
    provider = aws.us-west-1
  load_balancer_arn = aws_lb.app1_alb-Cali.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg-Cali.arn
  }
}

output "LB-Cali" { # Cali dns name
  value     =  aws_lb.app1_alb-Cali.dns_name
}


