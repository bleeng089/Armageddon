#These are   for  public

resource "aws_subnet" "public-ap-southeast-2a" {
  provider = aws.ap-southeast-2
  vpc_id                  = aws_vpc.app1-Sydney.id
  cidr_block              = "10.154.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-ap-southeast-2a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "public-ap-southeast-2b" {
  provider = aws.ap-southeast-2
  vpc_id                  = aws_vpc.app1-Sydney.id
  cidr_block              = "10.154.2.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-ap-southeast-2b"
    Service = "J-Tele-Doctor"
  }
}

#these are for private
resource "aws_subnet" "private-ap-southeast-2a" {
  provider = aws.ap-southeast-2
  vpc_id            = aws_vpc.app1-Sydney.id
  cidr_block        = "10.154.11.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name    = "private-ap-southeast-2a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "private-ap-southeast-2b" {
  provider = aws.ap-southeast-2
  vpc_id            = aws_vpc.app1-Sydney.id
  cidr_block        = "10.154.12.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name    = "private-ap-southeast-2b"
    Service = "J-Tele-Doctor"
  }
}
