resource "aws_vpc" "app1-Hong" {
  provider = aws.ap-east-1
  cidr_block = "10.155.0.0/16"

  tags = {
    Name = "app1"
    Service = "J-Tele-Doctor"
  }
}