data "aws_ami" "latest-amazon-linux-image" {
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


resource "aws_launch_template" "app1-J-Tele-Doctor_LT" {
  name_prefix   = "app1-J-Tele-Doctor_LT"
  image_id      = data.aws_ami.latest-amazon-linux-image.id  
  instance_type = "t2.micro"

  key_name = aws_key_pair.MyLinuxBox2.key_name

  vpc_security_group_ids = [aws_security_group.app1-sg1-servers-Japan.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$${macid}/vpc-id)

echo "
<!doctype html>
<html lang=\"en\" class=\"h-100\">
<head>
<title>Details for EC2 instance</title>
<style>
    body {
        background-color: #121212;
        color: #ffffff;
        font-family: Arial, sans-serif;
    }
    h1 {
        color: #bb86fc;
    }
    p {
        color: #ffffff;
    }
    img {
        border: 2px solid #bb86fc;
    }
    div {
        padding: 20px;
    }
</style>
</head>
<body>
<div>
<h1>Port443</h1>
<h1>When TSA Keisha sees a Passportbro</h1>
<img src="https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExbTRyaGh3OXFicGpzMmE2MTUzeHl5dTdlOTZpeXpuMHlla2h6cHZtdSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3Oo8p762cyLnlMNRerm/giphy.webp" alt="Samurai Katana GIF">



<p><b>Instance Name:</b> $(hostname -f) </p>
<p><b>Instance Private Ip Address: </b> $${local_ipv4}</p>
<p><b>Availability Zone: </b> $${az}</p>
<p><b>Virtual Private Cloud (VPC):</b> $${vpc}</p>
</div>
</body>
</html>
" > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid

# Install rsyslog
yum install -y rsyslog

# Start and enable rsyslog
systemctl start rsyslog
systemctl enable rsyslog

# Configure rsyslog to forward logs to the syslog server
echo "
*.* @@SYSLOG-SERVER-IP:514
" >> /etc/rsyslog.conf

# Restart rsyslog to apply changes
systemctl restart rsyslog

  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "app1_LT"
      Service = "J-Tele-Doctor"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


