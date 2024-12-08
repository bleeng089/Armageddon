resource "aws_internet_gateway" "igw-Cali" {
  provider = aws.us-west-1
  vpc_id = aws_vpc.app1-Cali.id

  tags = {
    Name    = "app1_IGW-Cali"
    Service = "J-Tele-Doctor"
  }
}
