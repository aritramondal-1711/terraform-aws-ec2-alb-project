# Create Route Table
resource "aws_route_table" "tf_rt" {
	vpc_id = aws_vpc.tf_vpc.id
	
	route {
		cidr_block = data.aws_subnet.existing_subnet.cidr_block
		vpc_peering_connection_id = aws_vpc_peering_connection.tf_peer.id
	}

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}

	tags = {
		Name = "Project1_rt"
	}
}

# Associate Route table with subnet
resource "aws_route_table_association" "tf_rt_association" {
	subnet_id = aws_subnet.tf_subnet.id
	route_table_id = aws_route_table.tf_rt.id
}

# Add Route to existing route table
resource "aws_route" "ex_rt" {
	route_table_id = data.aws_route_table.existing_rt.id
	destination_cidr_block = aws_subnet.tf_subnet.cidr_block
	vpc_peering_connection_id = aws_vpc_peering_connection.tf_peer.id
}

# Create Route Table for LB
resource "aws_route_table" "lb_rt" {
        vpc_id = aws_vpc.tf_vpc.id

        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.igw.id
        }

        tags = {
                Name = "lb_rt"
        }
}

# Associate Route table with subnet
resource "aws_route_table_association" "lb_rt_association_a" {
        subnet_id = aws_subnet.lb_subnet_1.id
        route_table_id = aws_route_table.tf_rt.id
}

resource "aws_route_table_association" "lb_rt_association_b" {
        subnet_id = aws_subnet.lb_subnet_2.id
        route_table_id = aws_route_table.tf_rt.id
}
