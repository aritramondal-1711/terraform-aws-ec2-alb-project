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

<svg viewBox="0 0 1200 780" xmlns="http://www.w3.org/2000/svg" font-family="Segoe UI, Helvetica, Arial, sans-serif" xmlns:c2pa="http://c2pa.org/manifest"><metadata><c2pa:manifest>AAAWgmp1bWIAAAAeanVtZGMycGEAEQAQgAAAqgA4m3EDYzJwYQAAABZcanVtYgAAAEdqdW1kYzJtYQARABCAAACqADibcQN1cm46YzJwYTo4NTg4OTM4Ny0wY2Y2LTQ4ZTctODZiOC0xMjk1NGM2YzUyNzgAAAADl2p1bWIAAAApanVtZGMyYXMAEQAQgAAAqgA4m3EDYzJwYS5hc3NlcnRpb25zAAAAALxqdW1iAAAARGp1bWRjYm9yABEAEIAAAKoAOJtxE2MycGEuaW5ncmVkaWVudC52MwAAAAAYYzJzaHPb+QAHNFalInfysi1Z/hkAAABwY2JvcqNpZGM6Zm9ybWF0bWltYWdlL3N2Zyt4bWxqaW5zdGFuY2VJRHgseG1wOmlpZDpjMDE3ODNhMy1lNmM2LTQ0MDAtYmQwMC1lOWU5MzUxYjc2Y2VscmVsYXRpb25zaGlwaHBhcmVudE9mAAAB4mp1bWIAAABBanVtZGNib3IAEQAQgAAAqgA4m3ETYzJwYS5hY3Rpb25zLnYyAAAAABhjMnNoWwUJlpDkY16u9yLpxa5d4gAAAZljYm9yomdhY3Rpb25zgqJmYWN0aW9ua2MycGEub3BlbmVkanBhcmFtZXRlcnOha2luZ3JlZGllbnRzgaJjdXJseC1zZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmluZ3JlZGllbnQudjNkaGFzaFggo8in5KjhljXo1QBHlybKWZdWj9uuY+P7uaQTf4u9cQykZmFjdGlvbngdY29tLmFudGhyb3BpYy5jbGF1ZGUucHJvdmlkZWRqcGFyYW1ldGVyc6F4H2NvbS5hbnRocm9waWMub3JpZ2luLWNvbmZpZGVuY2VndW5rbm93bmtkZXNjcmlwdGlvbnhmQ2xhdWRlIHByb3ZpZGVkIHRoaXMgZmlsZSBhdCB0aGUgcmVxdWVzdCBvZiBhIHVzZXIgYW5kIG1heSBoYXZlIGNyZWF0ZWQgb3IgbW9kaWZpZWQgdGhlIGZpbGUgY29udGVudHMubXNvZnR3YXJlQWdlbnShZG5hbWVmQ2xhdWRlcmFsbEFjdGlvbnNJbmNsdWRlZPUAAADIanVtYgAAAEBqdW1kY2JvcgARABCAAACqADibcRNjMnBhLmhhc2guZGF0YQAAAAAYYzJzaABzKdGBUWhXWY3OB2dMRgUAAACAY2JvcqVjYWxnZnNoYTI1NmNwYWRNAAAAAAAAAAAAAAAAAGRoYXNoWCAuRyhBmHy6Zlqjd1h73yOqX2SVwCBLUmssDM7KkTWH0WRuYW1lbmp1bWJmIG1hbmlmZXN0amV4Y2x1c2lvbnOBomVzdGFydBizZmxlbmd0aBkeBAAAAj5qdW1iAAAAJ2p1bWRjMmNsABEAEIAAAKoAOJtxA2MycGEuY2xhaW0udjIAAAACD2Nib3KlY2FsZ2ZzaGEyNTZpc2lnbmF0dXJleE1zZWxmI2p1bWJmPS9jMnBhL3VybjpjMnBhOjg1ODg5Mzg3LTBjZjYtNDhlNy04NmI4LTEyOTU0YzZjNTI3OC9jMnBhLnNpZ25hdHVyZWppbnN0YW5jZUlEeCx4bXA6aWlkOjRiYTE4M2M2LTc1MjItNDgxMS1hMGM2LWFkZmUyZThiMWMyOXJjcmVhdGVkX2Fzc2VydGlvbnODomN1cmx4LXNlbGYjanVtYmY9YzJwYS5hc3NlcnRpb25zL2MycGEuaW5ncmVkaWVudC52M2RoYXNoWCCjyKfkqOGWNejVAEeXJspZl1aP265j4/u5pBN/i71xDKJjdXJseCpzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmFjdGlvbnMudjJkaGFzaFgghJbQubst3QMu3233EbYCCIy861bp6GWu6pZy+Y3CKOqiY3VybHgpc2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS5oYXNoLmRhdGFkaGFzaFggybGIihSToQ3eTdoIrSiX00hSdJ3CVAWvVeu2PVb3R+J0Y2xhaW1fZ2VuZXJhdG9yX2luZm+jZG5hbWVvQW50aHJvcGljIEZpbGVzZ3ZlcnNpb25lMS4wLjBrc3BlY1ZlcnNpb25lMi40LjAAABA4anVtYgAAAChqdW1kYzJjcwARABCAAACqADibcQNjMnBhLnNpZ25hdHVyZQAAABAIY2JvctKEWQISogEmGCFZAgowggIGMIIBjaADAgECAhRA5aAK7sI50L64g/oGQgU9Z1UTADAKBggqhkjOPQQDAzBJMRcwFQYDVQQKEw5BbnRocm9waWMsIFBCQzEuMCwGA1UEAxMlQW50aHJvcGljIENvbnRlbnQgQ3JlZGVudGlhbHMgUm9vdCBDQTAeFw0yNjA4MDcxODQzNTZaFw0yODA4MDYxOTQzNTZaMEQxFzAVBgNVBAoTDkFudGhyb3BpYywgUEJDMSkwJwYDVQQDEyBBbnRocm9waWMgQ2xhdWRlIENvbnRlbnQgU2lnbmluZzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABJh6CmvLUBgFFNU0vUKlOVtE6djd17L5SuwX0LemFisBM3dkd/3cyjxFA3Qo5S46fX0/ihY0VZ7mfb9KF703t5OjWDBWMA4GA1UdDwEB/wQEAwIHgDAVBgNVHSUEDjAMBgorBgEEAYPoXgIBMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUzlHiBIFOZFsj+OPEz5o+nMHXXMIwCgYIKoZIzj0EAwMDZwAwZAIwMXMdFJ4BetLLVY7ORuE9noqbbAZOZn/aArXyTwFAZfKrPzxF2vPoJNf1+UCdg1XGAjBwX1zd9WGqYkqmL5SFqw1QySjr1zJfpJM9+1rdDwSPLMOPOjKuiXjoU/pUUeG9RwmhY3BhZFkNngAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPZYQDtQQm82WkgY4dPBTZdgVuqudQ84PyJxfGhM8KFMI1lQ9ktEntqA64VCBhWVNl8CeuSyowSmAQ/I02om00A2kA4=</c2pa:manifest></metadata>
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth">
      <path d="M0,0 L8,3 L0,6 Z" fill="#232F3E"/>
    </marker>
    <marker id="arrowOrange" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth">
      <path d="M0,0 L8,3 L0,6 Z" fill="#FF9900"/>
    </marker>
  </defs>

  <rect width="1200" height="780" fill="#FFFFFF"/>

  <!-- Title -->
  <text x="600" y="40" text-anchor="middle" font-size="26" font-weight="700" fill="#232F3E">AWS Architecture Overview</text>
  <text x="600" y="64" text-anchor="middle" font-size="14" fill="#6B7280">Existing Environment ↔ New Terraform-Managed VPC</text>

  <!-- Internet users -->
  <ellipse cx="600" cy="110" rx="90" ry="28" fill="#F5F6FA" stroke="#232F3E" stroke-width="1.5"/>
  <text x="600" y="115" text-anchor="middle" font-size="14" fill="#232F3E">Internet Users</text>
  <line x1="600" y1="138" x2="600" y2="178" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- ===================== LEFT: EXISTING ENVIRONMENT ===================== -->
  <rect x="60" y="185" width="440" height="540" rx="10" fill="#F5F6FA" stroke="#9AA5B1" stroke-width="1.5" stroke-dasharray="6,4"/>
  <text x="80" y="215" font-size="16" font-weight="700" fill="#232F3E">Existing AWS Environment</text>

  <!-- Existing IGW -->
  <rect x="240" y="240" width="140" height="50" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="310" y="270" text-anchor="middle" font-size="13" fill="#232F3E">Internet Gateway</text>
  <line x1="310" y1="290" x2="310" y2="330" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- Existing Subnet -->
  <rect x="200" y="330" width="220" height="60" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="310" y="365" text-anchor="middle" font-size="13" fill="#232F3E">Existing Subnet</text>
  <line x1="310" y1="390" x2="310" y2="430" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- Existing EC2 host -->
  <rect x="200" y="430" width="220" height="60" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="310" y="465" text-anchor="middle" font-size="13" fill="#232F3E">Existing EC2 Host</text>

  <!-- SSH note -->
  <rect x="170" y="520" width="280" height="70" rx="8" fill="#FFF7E6" stroke="#FF9900" stroke-width="1.5"/>
  <text x="310" y="545" text-anchor="middle" font-size="12" font-weight="600" fill="#8A5A00">SSH (22/TCP)</text>
  <text x="310" y="563" text-anchor="middle" font-size="11" fill="#8A5A00">Allowed only from</text>
  <text x="310" y="578" text-anchor="middle" font-size="11" fill="#8A5A00">Existing Subnet CIDR</text>

  <!-- ===================== RIGHT: NEW VPC ===================== -->
  <rect x="700" y="185" width="440" height="540" rx="10" fill="#F5F6FA" stroke="#9AA5B1" stroke-width="1.5" stroke-dasharray="6,4"/>
  <text x="720" y="215" font-size="16" font-weight="700" fill="#232F3E">New VPC — Managed by Terraform</text>

  <!-- New IGW -->
  <rect x="850" y="178" width="140" height="0" />
  <line x1="900" y1="178" x2="900" y2="178" />

  <!-- Public subnets -->
  <rect x="740" y="240" width="360" height="60" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="920" y="265" text-anchor="middle" font-size="13" fill="#232F3E">Public Subnets (2x, Multi-AZ)</text>
  <text x="920" y="282" text-anchor="middle" font-size="11" fill="#6B7280">Internet Gateway attached</text>
  <line x1="920" y1="178" x2="920" y2="240" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>
  <line x1="920" y1="300" x2="920" y2="330" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- ALB -->
  <rect x="800" y="330" width="240" height="55" rx="8" fill="#FFF3E0" stroke="#FF9900" stroke-width="2"/>
  <text x="920" y="363" text-anchor="middle" font-size="14" font-weight="700" fill="#8A5A00">Application Load Balancer</text>
  <line x1="920" y1="385" x2="920" y2="420" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- Target Group -->
  <rect x="800" y="420" width="240" height="50" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="920" y="442" text-anchor="middle" font-size="13" fill="#232F3E">Target Group</text>
  <text x="920" y="459" text-anchor="middle" font-size="10.5" fill="#6B7280">Health Check: HTTP /</text>
  <line x1="920" y1="470" x2="920" y2="505" stroke="#232F3E" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- Application Subnet label -->
  <rect x="740" y="505" width="360" height="110" rx="8" fill="#FFFFFF" stroke="#9AA5B1" stroke-width="1.2" stroke-dasharray="3,3"/>
  <text x="920" y="522" text-anchor="middle" font-size="11" fill="#6B7280">Application Subnet</text>

  <!-- EC2 instances -->
  <rect x="758" y="535" width="90" height="60" rx="6" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="803" y="570" text-anchor="middle" font-size="12" fill="#232F3E">EC2-1</text>

  <rect x="875" y="535" width="90" height="60" rx="6" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="920" y="570" text-anchor="middle" font-size="12" fill="#232F3E">EC2-2</text>

  <rect x="992" y="535" width="90" height="60" rx="6" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="1037" y="570" text-anchor="middle" font-size="12" fill="#232F3E">EC2-3</text>

  <!-- S3 logging -->
  <rect x="740" y="650" width="200" height="55" rx="8" fill="#FFFFFF" stroke="#232F3E" stroke-width="1.5"/>
  <text x="840" y="672" text-anchor="middle" font-size="12" fill="#232F3E">S3 Bucket</text>
  <text x="840" y="688" text-anchor="middle" font-size="10.5" fill="#6B7280">ALB Access Logs</text>
  <line x1="920" y1="385" x2="850" y2="650" stroke="#9AA5B1" stroke-width="1.3" stroke-dasharray="4,3" marker-end="url(#arrow)"/>

  <!-- ===================== PEERING CONNECTION ===================== -->
  <line x1="420" y1="460" x2="740" y2="460" stroke="#FF9900" stroke-width="2.5" marker-end="url(#arrowOrange)" marker-start="url(#arrowOrange)"/>
  <rect x="480" y="425" width="200" height="34" rx="6" fill="#FFFFFF" stroke="#FF9900" stroke-width="1.5"/>
  <text x="580" y="447" text-anchor="middle" font-size="12" font-weight="600" fill="#8A5A00">VPC Peering</text>

  <!-- Legend -->
  <rect x="60" y="740" width="14" height="14" fill="#FFF3E0" stroke="#FF9900" stroke-width="1.5"/>
  <text x="82" y="751" font-size="11" fill="#6B7280">Load balancing layer</text>
  <line x1="260" y1="747" x2="290" y2="747" stroke="#9AA5B1" stroke-width="1.3" stroke-dasharray="4,3"/>
  <text x="298" y="751" font-size="11" fill="#6B7280">Log / data flow</text>
  <line x1="440" y1="747" x2="470" y2="747" stroke="#FF9900" stroke-width="2.5"/>
  <text x="478" y="751" font-size="11" fill="#6B7280">Peering connection</text>
</svg>


*Left: the existing AWS environment. Right: the new VPC that Terraform creates. The two are joined by a private VPC Peering connection — traffic never touches the public internet. The ALB sits in public subnets and fans out to three EC2 instances; access logs are shipped to S3.*

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




