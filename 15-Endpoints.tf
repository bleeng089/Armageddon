resource "aws_ec2_instance_connect_endpoint" "Japan-Endpoint" { #for syslog server in private zone
  subnet_id          = aws_subnet.public-ap-northeast-1a.id
  security_group_ids = [aws_security_group.Japan-Enpoint-1.id]
}