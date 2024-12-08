data "aws_ami" "latest-amazon-linux-image-Sydney" {
    provider = aws.ap-southeast-2
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "template_file" "user_data" { 
  template = file("${path.module}/user_data.sh.tpl") # user_data script
  vars = { 
    syslog_ip = aws_instance.myapp-server.private_ip # output of syslog servers private IP. This output is used in the user_data script. This help terraform know to create the syslog server first because it needs the output-IP to append into the syslog-agents.
  } 
}

resource "aws_launch_template" "app1-J-Tele-Doctor_LT-Sydney" { # Each EC2 instance hosts the J-Tele-Doctor application and are syslog agents
    provider = aws.ap-southeast-2  
  name_prefix   = "Sydney-app1-J-Tele-Doctor_LT"
  image_id      = data.aws_ami.latest-amazon-linux-image-Sydney.id  
  instance_type = "t2.micro"

  key_name = aws_key_pair.MyLinuxBox2-Sydney.key_name

  vpc_security_group_ids = [aws_security_group.app1-sg1-servers-Sydney.id]

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "Sydney-app1_LT"
      Service = "J-Tele-Doctor"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

