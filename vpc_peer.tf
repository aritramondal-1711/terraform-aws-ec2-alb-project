# Create peering between new & existing vpc
resource "aws_vpc_peering_connection" "tf_peer" {
	peer_owner_id = data.aws_caller_identity.owner.id
	peer_vpc_id = aws_vpc.tf_vpc.id
	vpc_id = data.aws_vpc.existing_vpc.id
	auto_accept = true

	accepter {
		allow_remote_vpc_dns_resolution = true
	}
	requester {
		allow_remote_vpc_dns_resolution = true
	}

	tags = {
		Name = "Project1_peer"
	}
}
