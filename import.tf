# Import Existing Subnet
data "aws_subnet" "existing_subnet" {
        id = "subnet-0ba7bc35645d9e6b1"
}

# Import Existing VPC
data "aws_vpc" "existing_vpc" {
        id = "vpc-02b16fe47f073db23"
}

# Import Existing Route table
data "aws_route_table" "existing_rt" {
	route_table_id = "rtb-07eb430e86549ade9"
}

# Import Owner Identity
data "aws_caller_identity" "owner" {}
