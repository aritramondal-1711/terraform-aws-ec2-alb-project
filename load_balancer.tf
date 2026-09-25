resource "aws_lb" "tf_lb" {
	name = "LBTF"
	internal = false
	load_balancer_type = "application"
	security_groups = [aws_security_group.lb_sg.id]
	subnets = [aws_subnet.lb_subnet_1.id,aws_subnet.lb_subnet_2.id]

	access_logs {
		bucket = aws_s3_bucket.tf_s3.id
		prefix = "LBTF_Logs"
		enabled = true
	}

	tags = {
		Name = "LBTF"
	}
}

resource "aws_lb_target_group" "instance_tg" {
	name = "LBTF-Target-Group"
	port = 80
	protocol = "HTTP"
	vpc_id = aws_vpc.tf_vpc.id

	health_check {
		enabled = true
		path = "/"
		protocol = "HTTP"
		matcher = "200"
		interval = 30
		timeout = 5
		healthy_threshold = 2
		unhealthy_threshold = 2
	}
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
	for_each = var.instance_tags

	target_group_arn = aws_lb_target_group.instance_tg.arn
	target_id = aws_instance.tf_ec2[each.key].id
	port = 80
}

resource "aws_lb_listener" "lb_listenr" {
	load_balancer_arn = aws_lb.tf_lb.arn
	port = 80
	protocol = "HTTP"

	default_action {
		type = "forward"
		target_group_arn = aws_lb_target_group.instance_tg.arn
	}
}
