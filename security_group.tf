# Create LB SG
resource "aws_security_group" "lb_sg" {
	vpc_id = aws_vpc.tf_vpc.id
	tags = {
		Name = "LB_SG"
	}
	
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Create Security Group for EC2
resource "aws_security_group" "tf_sg" {
	vpc_id = aws_vpc.tf_vpc.id
	tags = {
		Name = "Project1_SG"
	}

	# Allow HTTP Access from anywhere	
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = [aws_subnet.lb_subnet_1.cidr_block,aws_subnet.lb_subnet_2.cidr_block]
	}
	
	
	# Allow SSH from Existing Subnet
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = [data.aws_subnet.existing_subnet.cidr_block]
	}

	# Allow all outbound traffic
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
	

