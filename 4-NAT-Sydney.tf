resource "aws_eip" "nat-Sydney" { #elastic IP
provider = aws.ap-southeast-2
  domain = "vpc"

  tags = {
    Name = "nat-Sydney"
  }
}

resource "aws_nat_gateway" "nat-Sydney" {
  provider = aws.ap-southeast-2
  allocation_id = aws_eip.nat-Sydney.id #.nat references aws_eip.nat object
  subnet_id     = aws_subnet.public-ap-southeast-2a.id 

  tags = {
    Name = "nat-Sydney"
  }

  depends_on = [aws_internet_gateway.igw-Sydney] # ensures terraform creates IGW before creating this resource(NGW). NGW depend on IGW
}
