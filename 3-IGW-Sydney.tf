resource "aws_internet_gateway" "igw-Sydney" {
  provider = aws.ap-southeast-2
  vpc_id = aws_vpc.app1-Sydney.id

  tags = {
    Name    = "app1_IGW-Sydney"
    Service = "J-Tele-Doctor"
  }
}
