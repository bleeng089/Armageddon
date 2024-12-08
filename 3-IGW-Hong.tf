resource "aws_internet_gateway" "igw-Hong" {
  provider = aws.ap-east-1
  vpc_id = aws_vpc.app1-Hong.id

  tags = {
    Name    = "app1_IGW-Hong"
    Service = "J-Tele-Doctor"
  }
}
