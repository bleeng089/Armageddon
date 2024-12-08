
resource "aws_security_group" "app1-sg1-servers-Japan" {
  name        = "app1-sg1-servers-Japan"
  description = "app1-sg1-servers-Japan"
  vpc_id      = aws_vpc.app1-Japan.id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.app1-sg-LB01-Japan.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app1-sg1-servers-Japan"
    Service = "J-Tele-Doctor"
  }

}
resource "aws_security_group_rule" "app1-sg1-servers-Japan-syslog-udp" {
  type              = "ingress"
  security_group_id = aws_security_group.app1-sg1-servers-Japan.id
  from_port         = 514
  to_port           = 514
  protocol          = "udp"
  source_security_group_id = aws_security_group.Japan-SSH-syslog.id
  description       = "Allow syslog traffic"
}

resource "aws_security_group_rule" "app1-sg1-servers-Japan-syslog-tcp" {
  type              = "ingress"
  security_group_id = aws_security_group.app1-sg1-servers-Japan.id
  from_port         = 514
  to_port           = 514
  protocol          = "tcp"
  source_security_group_id = aws_security_group.Japan-SSH-syslog.id
  description       = "Allow syslog traffic (TCP)"
}


resource "aws_security_group" "app1-sg-LB01-Japan" {
  name        = "app1-sg-LB01-Japan"
  description = "app1-sg-LB01-Japan"
  vpc_id      = aws_vpc.app1-Japan.id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app1-sg2-LB1-Japan"
    Service = "J-Tele-Doctor"
  }

}


resource "aws_security_group" "Japan-SSH-syslog" {
  name        = "Japan-SSH-syslog"
  description = "Japan-SSH-syslog"
  vpc_id      = aws_vpc.app1-Japan.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow syslog traffic"
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow syslog traffic (TCP)"
    from_port   = 514
    to_port     = 514
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Japan-SSH-syslog"
  }

}



resource "aws_security_group" "Japan-Enpoint-1" {
  name        = "Japan-Enpoint-1"
  description = "Japan-Enpoint-1"
  vpc_id      = aws_vpc.app1-Japan.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Japan-Enpoint-1"
    Service = "EC2-Connect"
  }

}