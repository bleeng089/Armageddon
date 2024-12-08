resource "aws_lb" "app1_alb-Sydney" {
    provider = aws.ap-southeast-2
  name               = "app1-alb-Sydney"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app1-sg-LB01-Sydney.id]
  subnets            = [
    aws_subnet.public-ap-southeast-2a.id,
    aws_subnet.public-ap-southeast-2b.id
  ]
  enable_deletion_protection = false
#Lots of death and suffering here, make sure it's false. Prevents terraform from deleting the load balancer, prevents accidental deletions

  tags = {
    Name    = "App1LoadBalancer-Sydney"
  }
}
resource "aws_lb_listener" "https-Sydney" {
    provider = aws.ap-southeast-2
  load_balancer_arn = aws_lb.app1_alb-Sydney.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg-Sydney.arn
  }
}

output "LB-Sydney" { # Sydney dns name
  value     =  aws_lb.app1_alb-Sydney.dns_name
}


