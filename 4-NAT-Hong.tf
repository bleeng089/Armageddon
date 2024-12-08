resource "aws_eip" "nat-Hong" { #elastic IP
provider = aws.ap-east-1
  domain = "vpc"

  tags = {
    Name = "nat-Hong"
  }
}

resource "aws_nat_gateway" "nat-Hong" {
  provider = aws.ap-east-1
  allocation_id = aws_eip.nat-Hong.id #.nat references aws_eip.nat object
  subnet_id     = aws_subnet.public-ap-east-1a.id 

  tags = {
    Name = "nat-Hong"
  }

  depends_on = [aws_internet_gateway.igw-Hong] # ensures terraform creates IGW before creating this resource(NGW). NGW depend on IGW
}
