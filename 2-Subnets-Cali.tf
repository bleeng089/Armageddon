#These are   for  public

resource "aws_subnet" "public-us-west-1b" {
  provider = aws.us-west-1
  vpc_id                  = aws_vpc.app1-Cali.id
  cidr_block              = "10.156.2.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-us-west-1b"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "public-us-west-1c" {
  provider = aws.us-west-1
  vpc_id                  = aws_vpc.app1-Cali.id
  cidr_block              = "10.156.3.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-us-west-1c"
    Service = "J-Tele-Doctor"
  }
}

#these are for private
resource "aws_subnet" "private-us-west-1b" {
  provider = aws.us-west-1
  vpc_id            = aws_vpc.app1-Cali.id
  cidr_block        = "10.156.12.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name    = "private-us-west-1b"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "private-us-west-1c" {
  provider = aws.us-west-1
  vpc_id            = aws_vpc.app1-Cali.id
  cidr_block        = "10.156.13.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name    = "private-us-west-1c"
    Service = "J-Tele-Doctor"
  }
}
