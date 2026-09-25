# Create VPC
resource "aws_vpc" "tf_vpc" {
	cidr_block = var.vpc_cidr
	enable_dns_hostnames = true

	tags = {
		Name = "Project1_VPC"
	}
}

# Create Subnet for EC2
resource "aws_subnet" "tf_subnet" {
	vpc_id = aws_vpc.tf_vpc.id
	cidr_block = var.subnet_cidr
	map_public_ip_on_launch = true
	tags = {
		Name = "Project1_Subnet"
	}
}

# Create Subnet for LB
resource "aws_subnet" "lb_subnet_1" {
	vpc_id = aws_vpc.tf_vpc.id
	cidr_block = var.lb_cidr_1
	availability_zone = "ap-south-1a"
	map_public_ip_on_launch = true
	tags = {
		Name = "LB_Subnet_1"
	}
}

resource "aws_subnet" "lb_subnet_2" {
	vpc_id = aws_vpc.tf_vpc.id
	cidr_block = var.lb_cidr_2
	availability_zone = "ap-south-1b"
	map_public_ip_on_launch = true
	tags = {
		Name = "LB_Subnet_2"
	}
}
