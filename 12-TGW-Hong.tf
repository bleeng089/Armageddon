
resource "aws_ec2_transit_gateway" "Hong-TGW1" {
    provider = aws.ap-east-1
  tags = {
    Name: "Hong-TGW1"
  }
}
output "TGW-Peer-attach-ID-Hong" {
  value       = aws_ec2_transit_gateway.Hong-TGW1.id
  description = "TGW ID"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Private-VPC-Hong-TG-attach" {
    provider = aws.ap-east-1
  subnet_ids         = [aws_subnet.private-ap-east-1a.id, aws_subnet.private-ap-east-1b.id]
  transit_gateway_id = aws_ec2_transit_gateway.Hong-TGW1.id
  vpc_id             = aws_vpc.app1-Hong.id
  transit_gateway_default_route_table_association = false #or  by default associate to default Hong-TGW-Route-table
  transit_gateway_default_route_table_propagation = false #or  by default propagate to default Hong-TGW-Route-table
}





resource "aws_ec2_transit_gateway_route_table" "Hong-TG-Route-Table" { #TGW route table Hong
    provider = aws.ap-east-1 
  transit_gateway_id = aws_ec2_transit_gateway.Hong-TGW1.id 
}

resource "aws_ec2_transit_gateway_route_table_association" "Hong-TGW1_Association" { #Associates Hong-VPC-TGW-attach to Hong-TGW-Route-Table
    provider = aws.ap-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Hong-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Hong-TG-Route-Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Hong-TGW1_Propagation" { #Propagates Hong-VPC-TGW-attach to Hong-TGW-Route-Table
    provider = aws.ap-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Hong-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Hong-TG-Route-Table.id
}




resource "aws_ec2_transit_gateway_peering_attachment_accepter" "Hong_Japan_Peer_Accepter" { #accept peer
  provider = aws.ap-east-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.Japan_Hong_Peer.id
  tags = {
    Name = "Hong-Japan-Peer-Accepter"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Hong-to-Japan-TGW1_Peer_Association" { #Associates Hong-Japan-TGW-Peer to Hong-TGW-Route-Table
    provider = aws.ap-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.Hong_Japan_Peer_Accepter.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Hong-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Hong_to_Japan_Route" { #Route on TG Hong -> to -> Japan
    provider = aws.ap-east-1
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Hong-TG-Route-Table.id
  destination_cidr_block         = "10.150.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Hong_Peer.id
}

