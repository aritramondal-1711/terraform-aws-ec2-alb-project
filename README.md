# Terraform AWS VPC Peering + ALB

Infrastructure-as-Code project provisioning an isolated AWS VPC, peering it to an existing VPC, and exposing EC2 workloads through a multi-AZ Application Load Balancer — built entirely with Terraform.

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20ALB%20%7C%20EC2-FF9900?logo=amazonaws&logoColor=white)
![Status](https://img.shields.io/badge/Status-Learning%20Project-blue)

---

## Overview

This project provisions a complete AWS network stack using Terraform while integrating with an existing AWS environment. It creates a new isolated VPC hosting multiple EC2 instances, connects that VPC to an existing one via VPC Peering, and fronts the application with an Application Load Balancer that performs health checks and ships access logs to S3.

**Focus areas:**
- Infrastructure as Code (IaC)
- AWS networking & VPC Peering
- Route table management
- Security Group design
- EC2 deployment with `for_each`
- Application Load Balancer + Target Groups
- S3 access logging
- Terraform state & resource dependency management

---

## Architecture

### High-Level Architecture

### Deployment Flow

![Deployment Flow](diagrams/deployment-flow.svg)

*The 13 underlying Terraform resource creations, grouped into six logical phases, in the order they happen.*

---

## Existing Environment (Pre-Terraform)

| Resource | Description |
|---|---|
| VPC | Pre-existing, not managed by this Terraform config |
| Subnet | Existing subnet hosting the legacy EC2 host |
| EC2 Host | Existing instance with public SSH access |
| Internet Gateway | Provides internet access to the existing VPC |
| SSH | Open on port 22 |

## Resources Created by Terraform

| Category | Resources |
|---|---|
| Networking | New VPC, application subnet, 2 public subnets (multi-AZ), Internet Gateway |
| Compute | 3x EC2 instances (`for_each`) |
| Connectivity | VPC Peering Connection, route tables |
| Load Balancing | Application Load Balancer, Target Group, health checks |
| Security | Security Group (SSH restricted to existing subnet CIDR) |
| Logging | S3 bucket for ALB access logs |

---

## Security Design

**EC2 Security Group — SSH Access**

| Direction | Source | Port | Action |
|---|---|---|---|
| Inbound | Existing Subnet CIDR | 22/TCP | ✅ Allow |
| Inbound | `0.0.0.0/0` | 22/TCP | ❌ Deny |

Only hosts inside the existing subnet can SSH into the newly created instances — no SSH is exposed to the public internet.

---

## Route Tables

**Application Subnet**

| Destination | Target |
|---|---|
| Existing Subnet CIDR | VPC Peering Connection |

**ALB Public Subnets**

| Destination | Target |
|---|---|
| `0.0.0.0/0` | Internet Gateway |

---

## Terraform Concepts Demonstrated

- **Resources:** `aws_vpc`, `aws_subnet`, `aws_instance`, `aws_security_group`, `aws_lb`, `aws_lb_target_group`, `aws_lb_listener`, `aws_s3_bucket`, `aws_vpc_peering_connection`, `aws_route_table`
- **Iteration:** `for_each` to provision EC2-1/2/3 from a single resource block
- **Variables:** CIDRs, AMIs, instance types, availability zones, tags
- **Outputs:** Instance IPs, ALB DNS name, VPC IDs, peering connection ID
- **Dependencies:** Implicit and explicit resource ordering across networking, compute, and load balancing layers

---

## Repository Structure

```
terraform-aws-vpc-peering-alb/
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
```

---

## Screenshots

<img width="1090" height="337" alt="Terraform apply output" src="https://github.com/user-attachments/assets/1d466c79-de5d-4e63-8a23-72dbaff92cb3" />
<img width="1090" height="364" alt="AWS console - VPC" src="https://github.com/user-attachments/assets/a027ee60-256f-49bf-aa2a-d1af2d2a5991" />
<img width="1090" height="279" alt="AWS console - ALB" src="https://github.com/user-attachments/assets/2772b94e-3f88-44eb-b5c3-f1b09d11fc3b" />
<img width="1090" height="218" alt="AWS console - Target Group" src="https://github.com/user-attachments/assets/cb096241-af10-42f1-8a50-a0e0d60579ab" />
<img width="1090" height="238" alt="AWS console - EC2 instances" src="https://github.com/user-attachments/assets/b9a22d74-df3a-4920-a50e-54fc6a85ec67" />

---

## Learning Outcomes

- Terraform resource lifecycle management
- AWS networking fundamentals and VPC Peering connectivity
- Route table and security group design
- EC2 provisioning at scale with `for_each`
- ALB deployment, target groups, and health checks
- S3 access logging integration
- Real-world IaC dependency management

---

## Future Enhancements

- [ ] Convert to reusable Terraform modules
- [ ] Migrate to remote state (S3 + DynamoDB locking)
- [ ] Implement Auto Scaling Groups
- [ ] Add ACM SSL certificates and enforce HTTPS
- [ ] Add CloudWatch monitoring and alarms
- [ ] CI/CD pipeline via GitHub Actions
- [ ] Introduce private subnets + NAT Gateway
- [ ] Deploy a sample web application to the target group

---

## Author

**Aritra Mondal**
Linux Administrator transitioning into DevOps/Cloud Engineering — RHCSA, RHCE, AZ-900, AZ-104 certified.

Terraform learning project demonstrating AWS networking, VPC peering, EC2 provisioning, Application Load Balancers, and Infrastructure as Code best practices. 🚀



<img width="1090" height="337" alt="image" src="https://github.com/user-attachments/assets/1d466c79-de5d-4e63-8a23-72dbaff92cb3" />
<img width="1090" height="364" alt="image" src="https://github.com/user-attachments/assets/a027ee60-256f-49bf-aa2a-d1af2d2a5991" />
<img width="1090" height="279" alt="image" src="https://github.com/user-attachments/assets/2772b94e-3f88-44eb-b5c3-f1b09d11fc3b" />
<img width="1090" height="218" alt="image" src="https://github.com/user-attachments/assets/cb096241-af10-42f1-8a50-a0e0d60579ab" />
<img width="1090" height="238" alt="image" src="https://github.com/user-attachments/assets/b9a22d74-df3a-4920-a50e-54fc6a85ec67" />




