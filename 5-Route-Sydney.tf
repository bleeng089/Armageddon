resource "aws_route_table" "private-Sydney" {
    provider = aws.ap-southeast-2
  vpc_id = aws_vpc.app1-Sydney.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat-Sydney.id
      carrier_gateway_id         = null
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      gateway_id                 = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    },
   {
      cidr_block                 = "10.0.0.0/8"
      transit_gateway_id         = aws_ec2_transit_gateway.Sydney-TGW1.id
      gateway_id                 = null
      nat_gateway_id             = null
      carrier_gateway_id         = null
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      network_interface_id       = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    }
  ]
  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public-Sydney" {
    provider = aws.ap-southeast-2
  vpc_id = aws_vpc.app1-Sydney.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw-Sydney.id
      nat_gateway_id             = null
      carrier_gateway_id         = null
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    },
  ]

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-ap-southeast-2a" {
    provider = aws.ap-southeast-2
  subnet_id      = aws_subnet.private-ap-southeast-2a.id
  route_table_id = aws_route_table.private-Sydney.id
}

resource "aws_route_table_association" "private-ap-southeast-2b" {
    provider = aws.ap-southeast-2
  subnet_id      = aws_subnet.private-ap-southeast-2b.id
  route_table_id = aws_route_table.private-Sydney.id
}


#public

resource "aws_route_table_association" "public-ap-southeast-2a" {
    provider = aws.ap-southeast-2
  subnet_id      = aws_subnet.public-ap-southeast-2a.id
  route_table_id = aws_route_table.public-Sydney.id
}

resource "aws_route_table_association" "public-ap-southeast-2b" {
    provider = aws.ap-southeast-2
  subnet_id      = aws_subnet.public-ap-southeast-2b.id
  route_table_id = aws_route_table.public-Sydney.id
}