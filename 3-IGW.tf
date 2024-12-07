resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app1-Japan.id

  tags = {
    Name    = "app1_IGW-Japan"
    Service = "J-Tele-Doctor"
  }
}
