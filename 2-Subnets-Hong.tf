#These are   for  public

resource "aws_subnet" "public-ap-east-1a" {
  provider = aws.ap-east-1
  vpc_id                  = aws_vpc.app1-Hong.id
  cidr_block              = "10.155.1.0/24"
  availability_zone       = "ap-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-ap-east-1a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "public-ap-east-1b" {
  provider = aws.ap-east-1
  vpc_id                  = aws_vpc.app1-Hong.id
  cidr_block              = "10.155.2.0/24"
  availability_zone       = "ap-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-ap-east-1b"
    Service = "J-Tele-Doctor"
  }
}

#these are for private
resource "aws_subnet" "private-ap-east-1a" {
  provider = aws.ap-east-1
  vpc_id            = aws_vpc.app1-Hong.id
  cidr_block        = "10.155.11.0/24"
  availability_zone = "ap-east-1a"

  tags = {
    Name    = "private-ap-east-1a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "private-ap-east-1b" {
  provider = aws.ap-east-1
  vpc_id            = aws_vpc.app1-Hong.id
  cidr_block        = "10.155.12.0/24"
  availability_zone = "ap-east-1b"

  tags = {
    Name    = "private-ap-east-1b"
    Service = "J-Tele-Doctor"
  }
}
