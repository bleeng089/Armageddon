resource "aws_vpc" "app1-Sydney" {
  provider = aws.ap-southeast-2
  cidr_block = "10.154.0.0/16"

  tags = {
    Name = "app1"
    Service = "J-Tele-Doctor"
  }
}