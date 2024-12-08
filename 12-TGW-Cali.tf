
resource "aws_ec2_transit_gateway" "Cali-TGW1" {
    provider = aws.us-west-1
  tags = {
    Name: "Cali-TGW1"
  }
}
output "TGW-Peer-attach-ID-Cali" {
  value       = aws_ec2_transit_gateway.Cali-TGW1.id
  description = "TGW ID"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Private-VPC-Cali-TG-attach" {
    provider = aws.us-west-1
  subnet_ids         = [aws_subnet.private-us-west-1b.id, aws_subnet.private-us-west-1c.id]
  transit_gateway_id = aws_ec2_transit_gateway.Cali-TGW1.id
  vpc_id             = aws_vpc.app1-Cali.id
  transit_gateway_default_route_table_association = false #or  by default associate to default Cali-TGW-Route-table
  transit_gateway_default_route_table_propagation = false #or  by default propagate to default Cali-TGW-Route-table
}





resource "aws_ec2_transit_gateway_route_table" "Cali-TG-Route-Table" { #TGW route table Cali
    provider = aws.us-west-1 
  transit_gateway_id = aws_ec2_transit_gateway.Cali-TGW1.id 
}

resource "aws_ec2_transit_gateway_route_table_association" "Cali-TGW1_Association" { #Associates Cali-VPC-TGW-attach to Cali-TGW-Route-Table
    provider = aws.us-west-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Cali-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Cali-TG-Route-Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Cali-TGW1_Propagation" { #Propagates Cali-VPC-TGW-attach to Cali-TGW-Route-Table
    provider = aws.us-west-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Cali-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Cali-TG-Route-Table.id
}




resource "aws_ec2_transit_gateway_peering_attachment_accepter" "Cali_Japan_Peer_Accepter" { #accept peer
  provider = aws.us-west-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.Japan_Cali_Peer.id
  tags = {
    Name = "Cali-Japan-Peer-Accepter"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Cali-to-Japan-TGW1_Peer_Association" { #Associates Cali-Japan-TGW-Peer to Cali-TGW-Route-Table
    provider = aws.us-west-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.Cali_Japan_Peer_Accepter.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Cali-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Cali_to_Japan_Route" { #Route on TG Cali -> to -> Japan
    provider = aws.us-west-1
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Cali-TG-Route-Table.id
  destination_cidr_block         = "10.150.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Cali_Peer.id
}
