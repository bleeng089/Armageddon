resource "tls_private_key" "MyLinuxBox2" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "tls_public_key" "MyLinuxBox2" {
  private_key_pem = tls_private_key.MyLinuxBox2.private_key_pem
}

output "private_key" { #"terraform output private_key"  to print to standard output
  value     = tls_private_key.MyLinuxBox2.private_key_pem
  sensitive = true
}

output "public_key" {
  value = data.tls_public_key.MyLinuxBox2.public_key_openssh
}

resource "aws_key_pair" "MyLinuxBox2" { #creates a key pair using the public key generated from the tls_private_key. 
  key_name = "MyLinuxBox2" 
  public_key = data.tls_public_key.MyLinuxBox2.public_key_openssh 
  }


