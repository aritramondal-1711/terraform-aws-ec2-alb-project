output "instances" {
	value = join("\n",
		["Instances Deployed -"],
		[
		for instance in aws_instance.tf_ec2:
			"${instance.tags.Name} : ${instance.private_ip} : ${var.remote_user_name}"
		],
		["URL : ${aws_lb.tf_lb.dns_name}"]
	)
}
resource "local_file" "inventory" {
	filename = "inventory.csv"
	content = join("\n",
		["Instances Deployed,Private Ip,User Name, Public URL"],
		[
		for instance in aws_instance.tf_ec2:
			"${instance.tags.Name},${instance.private_ip},${var.remote_user_name},${aws_lb.tf_lb.dns_name}"
		]
	)
}
