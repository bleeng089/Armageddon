resource "tls_private_key" "MyLinuxBox2-Cali" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "tls_public_key" "MyLinuxBox2-Cali" {
  private_key_pem = tls_private_key.MyLinuxBox2-Cali.private_key_pem
}

output "private_key-Cali" { #"terraform output private_key"  to print to standard output
  value     = tls_private_key.MyLinuxBox2-Cali.private_key_pem
  sensitive = true
}

output "public_key-Cali" {
  value = data.tls_public_key.MyLinuxBox2-Cali.public_key_openssh
}

resource "aws_key_pair" "MyLinuxBox2-Cali" { #creates a key pair using the public key generated from the tls_private_key.
 provider = aws.us-west-1
  key_name = "MyLinuxBox2-Cali" 
  public_key = data.tls_public_key.MyLinuxBox2-Cali.public_key_openssh 
  }