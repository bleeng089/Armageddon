resource "tls_private_key" "MyLinuxBox2-Sydney" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "tls_public_key" "MyLinuxBox2-Sydney" {
  private_key_pem = tls_private_key.MyLinuxBox2-Sydney.private_key_pem
}

output "private_key-Sydney" { #"terraform output private_key"  to print to standard output
  value     = tls_private_key.MyLinuxBox2-Sydney.private_key_pem
  sensitive = true
}

output "public_key-Sydney" {
  value = data.tls_public_key.MyLinuxBox2-Sydney.public_key_openssh
}

resource "aws_key_pair" "MyLinuxBox2-Sydney" { #creates a key pair using the public key generated from the tls_private_key.
 provider = aws.ap-southeast-2
  key_name = "MyLinuxBox2-Sydney" 
  public_key = data.tls_public_key.MyLinuxBox2-Sydney.public_key_openssh 
  }