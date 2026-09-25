## Terraform AWS VPC Peering + ALB Project
Overview
This project demonstrates how to provision a complete AWS infrastructure using Terraform while integrating with an existing AWS environment.
The infrastructure creates a new isolated VPC hosting multiple EC2 instances, establishes connectivity to an existing VPC through VPC Peering, and exposes the application through an Application Load Balancer (ALB) with health checks and access logging.
This project was created as a hands-on Terraform learning exercise focused on:
•	Infrastructure as Code (IaC)
•	AWS networking
•	VPC Peering
•	Route table management
•	Security Groups
•	EC2 deployment using for_each
•	Application Load Balancers
•	S3 logging
•	Terraform state management
•	Modular resource dependencies
________________________________________
Architecture
Existing Environment
Resources that already existed before running Terraform:
•	Existing VPC
•	Existing Subnet
•	Existing EC2 Host
•	Internet Gateway
•	Public SSH access on Port 22
 ________________________________________
Infrastructure Created by Terraform
Terraform provisions:
•	New VPC
•	New application subnet
•	3 EC2 instances
•	Security Group
•	VPC Peering Connection
•	Route Tables
•	Internet Gateway
•	2 public subnets for Load Balancer
•	Application Load Balancer
•	Target Group
•	Health Checks
•	S3 Bucket for ALB Logs
________________________________________
High Level Architecture Diagram
                                      ________________________________________
Detailed Network Diagram
________________________________________
Security Design
EC2 Security Group
SSH access is restricted.
Allowed:
Source:
Existing Subnet CIDR
Port:
22/TCP
Denied:
0.0.0.0/0
This ensures only systems within the existing subnet can SSH into the newly created instances.
________________________________________
Components Created
Networking
New VPC
Provides isolation from the existing environment.
Application Subnet
Hosts backend EC2 instances.
ALB Public Subnets
Two public subnets located in different Availability Zones.
Purpose:
•	High availability
•	ALB requirement for multi-AZ deployment
Internet Gateway
Attached to the new VPC to provide internet access to public resources.
________________________________________
VPC Peering
Establishes connectivity between:
Existing VPC
        <
      Peer
        >
New VPC
Benefits:
•	Private communication
•	No internet traversal
•	Secure inter-VPC routing
________________________________________
Route Tables
Application Subnet Route Table
Destination         Target
Existing Subnet --> VPC Peering
Allows communication between new infrastructure and the existing EC2 environment.
ALB Public Route Table
Destination         Target
0.0.0.0/0      --> Internet Gateway
Enables public access to the load balancer.
________________________________________
EC2 Instances
Terraform uses:
for_each
to create:
•	EC2-1
•	EC2-2
•	EC2-3
Benefits:
•	Scalable deployment
•	Consistent configuration
•	Easy future expansion
________________________________________
Application Load Balancer
Distributes traffic across all backend EC2 instances.
Features:
•	Multi-AZ deployment
•	Target Group integration
•	Health checks
•	Centralized entry point
•	High availability
________________________________________
Target Group
Backend servers registered:
EC2-1
EC2-2
EC2-3
Traffic is routed only to healthy targets.
________________________________________
Health Checks
The ALB continuously monitors backend health.
Example:
Protocol : HTTP
Path     : /
Benefits:
•	Automatic unhealthy instance detection
•	Improved application availability
•	Traffic only routed to operational nodes
________________________________________
S3 Logging
An S3 bucket is created for ALB access logs.
Purpose:
•	Audit traffic
•	Troubleshooting
•	Security investigations
•	Traffic analysis
Flow:
ALB
 |
 | Access Logs
 v
S3 Bucket
________________________________________
Terraform Concepts Demonstrated
This project demonstrates the following Terraform features:
Resource Creation
aws_vpc
aws_subnet
aws_instance
aws_security_group
aws_lb
aws_lb_target_group
aws_lb_listener
aws_s3_bucket
aws_vpc_peering_connection
aws_route_table
Iteration
for_each
Used to dynamically create multiple EC2 instances.
Variables
Used to parameterize:
•	CIDRs
•	AMIs
•	Instance types
•	Availability Zones
•	Tags
Outputs
Used to expose:
•	Instance IPs
•	ALB DNS Name
•	VPC IDs
•	Peering IDs
Dependencies
Resources automatically depend on one another to ensure proper creation order.
________________________________________
Deployment Flow
1. Read Existing VPC Information
            |
2. Create New VPC
            |
3. Create Subnets
            |
4. Create Security Groups
            |
5. Establish VPC Peering
            |
6. Configure Routes
            |
7. Launch EC2 Instances
            |
8. Create ALB
            |
9. Create Target Group
            |
10. Register Targets
            |
11. Configure Health Checks
            |
12. Create Logging Bucket
            |
13. Enable ALB Logging
________________________________________
Learning Outcomes
After completing this project, I gained hands-on experience with:
•	Terraform resource lifecycle
•	AWS networking fundamentals
•	VPC Peering connectivity
•	Route table management
•	Security group design
•	EC2 provisioning at scale
•	ALB deployment and configuration
•	Health check implementation
•	S3 logging integration
•	Infrastructure dependency management
•	Real-world Infrastructure as Code practices
________________________________________
Future Enhancements
Potential improvements:
•	Convert to reusable Terraform modules
•	Use remote Terraform state (S3 + DynamoDB)
•	Implement Auto Scaling Groups
•	Add ACM SSL certificates
•	Enforce HTTPS
•	Add CloudWatch monitoring
•	Create CI/CD pipeline using GitHub Actions
•	Introduce private subnets and NAT Gateway
•	Deploy a sample web application
________________________________________
Repository Structure
terraform-aws-vpc-peering-alb/
│
├── provider.tf
├── variables.tf
├── outputs.tf
├── vpc.tf
├── subnet.tf
├── peering.tf
├── security_group.tf
├── ec2.tf
├── load_balancer.tf
├── s3.tf
├── routes.tf
├── terraform.tfvars
└── README.md
________________________________________
Author
Aritra Mondal
Terraform learning project demonstrating AWS networking, VPC peering, EC2 provisioning, Application Load Balancers, and Infrastructure as Code best practices. 🚀

<img width="1090" height="337" alt="image" src="https://github.com/user-attachments/assets/1d466c79-de5d-4e63-8a23-72dbaff92cb3" />
<img width="1090" height="364" alt="image" src="https://github.com/user-attachments/assets/a027ee60-256f-49bf-aa2a-d1af2d2a5991" />
<img width="1090" height="279" alt="image" src="https://github.com/user-attachments/assets/2772b94e-3f88-44eb-b5c3-f1b09d11fc3b" />
<img width="1090" height="218" alt="image" src="https://github.com/user-attachments/assets/cb096241-af10-42f1-8a50-a0e0d60579ab" />
<img width="1090" height="238" alt="image" src="https://github.com/user-attachments/assets/b9a22d74-df3a-4920-a50e-54fc6a85ec67" />




