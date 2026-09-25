# Key Pair
resource "aws_key_pair" "tf_key" {
	key_name = "project1_key"
	public_key = file("/root/.ssh/id_rsa.pub")
	tags = {
		Name = "Project1_key_pair"
	}
}

# Deploy EC2
resource "aws_instance" "tf_ec2" {
	ami = var.ami_id
	instance_type = "t3.micro"
	key_name = aws_key_pair.tf_key.key_name
	subnet_id = aws_subnet.tf_subnet.id
	vpc_security_group_ids = [aws_security_group.tf_sg.id]

	user_data = <<EOF
#!/bin/bash

sudo useradd -m ${var.remote_user_name}
sudo bash -c "echo ${var.remote_user_password} | passwd --stdin ${var.remote_user_name}"

sudo yum clean all
sudo yum install httpd firewalld -y

sudo systemctl enable --now firewalld
sudo firewall-cmd --add-service http --permanent
sudo firewall-cmd --add-service ssh --permanent
sudo firewall-cmd --add-service https --permanent

sudo firewall-cmd --reload

sudo systemctl enable --now httpd

sudo echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/50-cloud-init.conf
sudo systemctl restart sshd
sudo echo "${var.remote_user_name} ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/${var.remote_user_name}

sudo echo "Hellow from $(hostname) on $(hostname -i)... " > /var/www/html/index.html

EOF 
	for_each = var.instance_tags	
	tags = {
		Name = each.value
	}
}
