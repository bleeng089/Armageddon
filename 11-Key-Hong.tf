resource "tls_private_key" "MyLinuxBox2-Hong" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "tls_public_key" "MyLinuxBox2-Hong" {
  private_key_pem = tls_private_key.MyLinuxBox2-Hong.private_key_pem
}

output "private_key-Hong" { #"terraform output private_key"  to print to standard output
  value     = tls_private_key.MyLinuxBox2-Hong.private_key_pem
  sensitive = true
}

output "public_key-Hong" {
  value = data.tls_public_key.MyLinuxBox2-Hong.public_key_openssh
}

resource "aws_key_pair" "MyLinuxBox2-Hong" { #creates a key pair using the public key generated from the tls_private_key.
 provider = aws.ap-east-1
  key_name = "MyLinuxBox2-Hong" 
  public_key = data.tls_public_key.MyLinuxBox2-Hong.public_key_openssh 
  }