resource "aws_vpc" "app1-Cali" {
  provider = aws.us-west-1
  cidr_block = "10.156.0.0/16"

  tags = {
    Name = "app1"
    Service = "J-Tele-Doctor"
  }
}