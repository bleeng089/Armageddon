
resource "aws_ec2_transit_gateway" "Japan-TGW1" {
  provider = aws
  tags = {
    Name: "Japan-TGW1"
  }
}
output "TGW-Peer-attach-ID" {
  value       = aws_ec2_transit_gateway.Japan-TGW1.id
  description = "TGW ID"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Private-VPC-Japan-TG-attach" {
  subnet_ids         = [aws_subnet.private-ap-northeast-1a.id, aws_subnet.private-ap-northeast-1c.id]
  transit_gateway_id = aws_ec2_transit_gateway.Japan-TGW1.id
  vpc_id             = aws_vpc.app1-Japan.id
  transit_gateway_default_route_table_association = false #or  by default associate to default Japan-TGW-Route-table
  transit_gateway_default_route_table_propagation = false #or  by default propagate to default Japan-TGW-Route-table
}

/*
resource "aws_ec2_transit_gateway_peering_attachment" "attachment" { #peer
  transit_gateway_id        = aws_ec2_transit_gateway.Japan-TGW1.id
  peer_transit_gateway_id   = "tgw-0d53c496c3e4003ab"  # Placeholder, replace with actual TGW ID from Brazil
  peer_account_id           = "381492105256"         # The account ID of the Brazil TGW, "peer must be accepted"
  peer_region               = "sa-east-1"
  tags = {
    Name = "Japan-Brazil-Peer"
  }
}
data "aws_ec2_transit_gateway_peering_attachment" "attachment" {  #aws ec2 describe-transit-gateway-attachments

  id = "tgw-attach-037aa355e666539f8"
}
*/

resource "aws_ec2_transit_gateway_route_table" "Japan-TG-Route-Table" { #TGW route table Japan 
  transit_gateway_id = aws_ec2_transit_gateway.Japan-TGW1.id 
}

resource "aws_ec2_transit_gateway_route_table_association" "Japan-TGW1_Association" { #Associates Japan-VPC-TGW-attach to Japan-TGW-Route-Table
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Japan-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Japan-TGW1_Propagation" { #Propagates US-VPC-TGW-attach to Japan-TGW-Route-Table
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-Japan-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
}

/*
resource "aws_ec2_transit_gateway_route_table_association" "Japan-TGW1_Peer_Association" { #Associates Japan-Brazil-TGW-Peer to Japan-TGW-Route-Table
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Japan_to_Brazil_Route" { #Route on TG Japan -> to -> Brazil
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  destination_cidr_block         = "10.153.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.attachment.id
}
*/

#########################################################################################################################################################
resource "aws_ec2_transit_gateway_peering_attachment" "Japan_Sydney_Peer" { #peer
  transit_gateway_id        = aws_ec2_transit_gateway.Japan-TGW1.id
  peer_transit_gateway_id   = aws_ec2_transit_gateway.Sydney-TGW1.id
  peer_region               = "ap-southeast-2"
  tags = {
    Name = "Sydney-Japan-Peer"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Japan-to-Sydney-TGW1_Peer_Association" { #Associates Sydney-Japan-TGW-Peer to Sydney-TGW-Route-Table
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Sydney_Peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Japan_to_Sydney_Route" { #Route on TG Japan -> to -> Sydney
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  destination_cidr_block         = "10.154.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Sydney_Peer.id
}
###############################################################################################################################################################
resource "aws_ec2_transit_gateway_peering_attachment" "Japan_Hong_Peer" { #peer
  transit_gateway_id        = aws_ec2_transit_gateway.Japan-TGW1.id
  peer_transit_gateway_id   = aws_ec2_transit_gateway.Hong-TGW1.id
  peer_region               = "ap-east-1"
  tags = {
    Name = "Hong-Japan-Peer"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Japan-to-Hong-TGW1_Peer_Association" { #Associates Hong-Japan-TGW-Peer to Hong-TGW-Route-Table
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Hong_Peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Japan_to_Hong_Route" { #Route on TG Japan -> to -> Hong
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  destination_cidr_block         = "10.155.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Hong_Peer.id
}
#################################################################################################################################################################
resource "aws_ec2_transit_gateway_peering_attachment" "Japan_Cali_Peer" { #peer
  transit_gateway_id        = aws_ec2_transit_gateway.Japan-TGW1.id
  peer_transit_gateway_id   = aws_ec2_transit_gateway.Cali-TGW1.id
  peer_region               = "us-west-1"
  tags = {
    Name = "Cali-Japan-Peer"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "Japan-to-Cali-TGW1_Peer_Association" { #Associates Cali-Japan-TGW-Peer to Cali-TGW-Route-Table
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Cali_Peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "Japan_to_Cali_Route" { #Route on TG Japan -> to -> Cali
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Japan-TG-Route-Table.id
  destination_cidr_block         = "10.156.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_Cali_Peer.id
}