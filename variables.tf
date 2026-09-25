# VPC CIDER BLOCK
variable "vpc_cidr" {
	default = "10.2.0.0/16"
}

# Subnet CIDR Block
variable "subnet_cidr" {
	default = "10.2.0.0/24"
}

variable "lb_cidr_1" {
	default = "10.2.1.0/24"
}

variable "lb_cidr_2" {
	default = "10.2.2.0/24"
}

# AMI ID
variable "ami_id" {
	default = "ami-0011550b539717e2a"
}

variable "instance_tags" {
	type = set(string)
	default = [
		"node1",
		"node2",
		"node3"
	]
}

variable "remote_user_name" {
	type = string
	default = "ec2-admin"
}

variable "remote_user_password" {
	type = string
	default = "Admin@1234"
}
