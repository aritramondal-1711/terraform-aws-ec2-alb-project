resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.tf_vpc.id
	tags = {
		Name = "VPC For Project1"
	}
}
