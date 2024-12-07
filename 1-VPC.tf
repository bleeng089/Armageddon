
resource "aws_vpc" "app1-Japan" {
  cidr_block = "10.150.0.0/16"

  tags = {
    Name = "app1"
    Service = "J-Tele-Doctor"
  }
}
