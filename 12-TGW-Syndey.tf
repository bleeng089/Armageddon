
resource "aws_ec2_transit_gateway" "Sydney-TGW1" {
    provider = aws.ap-southeast-2
  tags = {
    Name: "Sydney-TGW1"
  }
}
output "TGW-Peer-attach-ID-Sydney" {
  value       = aws_ec2_transit_gateway.Sydney-TGW1.id
  description = "TGW ID"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Private-VPC-Sydney-TG-attach" {
    provider = aws.ap-southeast-2
  subnet_ids         = [aws_subnet.private-ap-southeast-2a.id, aws_subnet.private-ap-southeast-2b.id]
  transit_gateway_id = aws_ec2_transit_gateway.Sydney-TGW1.id
  vpc_id             = aws_vpc.app1-Sydney.id
  transit_gateway_default_route_table_association = false #or  by default associate to default Sydney-TGW-Route-table
  transit_gateway_default_route_table_propagation = false #or  by default propagate to default Sydney-TGW-Route-table
}





resource "aws_ec2_transit_gateway_route_table" "Sydney-TG-Route-Table" { #TGW route table Sydney
    provider = aws.ap-southeast-2 
  transit_gateway_id = aws_ec2_transit_gateway.Sydney-TGW1.id 
}

resource "aws_ec2_transit_gateway_route_table_association" "Sydney-TGW1_Association" { #Associates Sydney-VPC-TGW-attach to Sydney-TGW-Route-Table
    provider = aws.ap-southeast-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Sydney-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Sydney-TG-Route-Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Sydney-TGW1_Propagation" { #Propagates Sydney-VPC-TGW-attach to Sydney-TGW-Route-Table
    provider = aws.ap-southeast-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Sydney-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Sydney-TG-Route-Table.id
}




resource "aws_ec2_transit_gateway_peering_attachment_accepter" "Sydney_Japan_Peer_Accepter" { #accept peer
  provider = aws.ap-southeast-2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.Japan_Sydney_Peer.id
  tags = {
    Name = "Sydney-Japan-Peer-Accepter"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Sydney-to-Japan-TGW1_Peer_Association" { #Associates Sydney-Japan-TGW-Peer to Sydney-TGW-Route-Table
    provider = aws.ap-southeast-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.Sydney_Japan_Peer_Accepter.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Sydney-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Sydney_to_Japan_Route" { #Route on TG Sydney -> to -> Japan
    provider = aws.ap-southeast-2
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Sydney-TG-Route-Table.id
  destination_cidr_block         = "10.150.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Sydney_Peer.id
}
