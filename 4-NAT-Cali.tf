resource "aws_eip" "nat-Cali" { #elastic IP
provider = aws.us-west-1
  domain = "vpc"

  tags = {
    Name = "nat-Cali"
  }
}

resource "aws_nat_gateway" "nat-Cali" {
  provider = aws.us-west-1
  allocation_id = aws_eip.nat-Cali.id #.nat references aws_eip.nat object
  subnet_id     = aws_subnet.public-us-west-1b.id 

  tags = {
    Name = "nat-Cali"
  }

  depends_on = [aws_internet_gateway.igw-Cali] # ensures terraform creates IGW before creating this resource(NGW). NGW depend on IGW
}
