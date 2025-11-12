# Modular AWS Infrastructure using Terraform

This project provisions a highly available, modular AWS infrastructure using Terraform.  
It demonstrates best practices for Infrastructure as Code (IaC) with modular design, reusability, and scalability.

---

## Project Overview

This Terraform setup deploys a web application environment on AWS consisting of:
- VPC (Virtual Private Cloud) – Custom networking environment
- Public and Private Subnets across multiple Availability Zones
- Internet Gateway (IGW) and NAT Gateway for internet access
- Security Groups for ALB and EC2 traffic control
- Application Load Balancer (ALB) – public entry point
- Auto Scaling Group (ASG) and Launch Template – to manage EC2 instances dynamically
- Outputs that expose key resource identifiers

Once deployed, the ALB DNS name can be accessed in a browser to see the running web app returning “Hello from EC2”.

---

## Architecture Diagram

                     ┌───────────────────────────────┐
                     │         Internet Users         │
                     └───────────────────────────────┘
                                   │
                                   ▼
                    ┌───────────────────────────────┐
                    │     Internet Gateway (IGW)     │
                    └───────────────────────────────┘
                                   │
                    ┌───────────────────────────────┐
                    │  Public Subnets (2 AZs)        │
                    │     - ALB                      │
                    │     - NAT Gateway              │
                    └───────────────────────────────┘
                                   │
                    ┌───────────────────────────────┐
                    │   Private Subnets (2 AZs)      │
                    │     - EC2 (ASG Instances)      │
                    └───────────────────────────────┘
                                   │
                    ┌───────────────────────────────┐
                    │  Target Group (ALB → EC2)      │
                    └───────────────────────────────┘

   ALB (Public) ↔ Internet Gateway ↔ Internet  
   EC2 (Private) ↔ NAT Gateway ↔ Internet Gateway ↔ Internet

---

## Modules Overview

| Module | Purpose | Key Resources |
|---------|----------|---------------|
| vpc | Sets up networking layer | VPC, Subnets, Route Tables, IGW, NAT |
| security | Manages inbound/outbound traffic | Security Groups for ALB & EC2 |
| alb | Handles load balancing | ALB, Target Group, Listeners |
| compute | Manages compute layer | Launch Template, Auto Scaling Group |
| outputs | Exposes outputs | ALB DNS Name, Target Group ARN |

---

## Resource Flow

1. VPC Module  
   - Creates the base VPC  
   - Adds public/private subnets  
   - Configures Internet Gateway and NAT Gateway  
   - Defines route tables for correct routing  

2. Security Module  
   - ALB SG allows inbound HTTP (port 80) from anywhere  
   - EC2 SG allows inbound only from ALB SG (internal traffic)

3. ALB Module  
   - Creates Application Load Balancer  
   - Creates Target Group and Listener  
   - Routes traffic from ALB → Target Group → EC2 instances

4. Compute Module  
   - Defines Launch Template (AMI, keypair, user_data)  
   - Creates Auto Scaling Group in private subnets  
   - Instances automatically register with the ALB Target Group

---

## Prerequisites

- AWS Account with admin privileges  
- AWS CLI installed and configured (aws configure)  
- Terraform ≥ v1.5.0 installed  
- IAM user credentials configured locally  
- Key pair created in the target AWS region (for EC2 access)

---

## Folder Structure

terraform-aws-infra/
│
├── main.tf  
├── variables.tf  
├── outputs.tf  
│
├── modules/  
│   ├── vpc/  
│   │   ├── main.tf  
│   │   ├── variables.tf  
│   │   └── outputs.tf  
│   ├── security/  
│   ├── alb/  
│   └── compute/  
│
└── .gitignore  

---


---

## Notes

- All EC2 instances are private and not directly exposed to the Internet.  
- The ALB resides in public subnets, making it the only Internet-facing component.  
- NAT Gateway allows private instances to access the Internet securely.  
- Modular design allows easy reuse or scaling for new environments like staging or production.

---

## Future Enhancements

- Add RDS module for database tier  
- Integrate CloudWatch monitoring  
- Add CI/CD pipeline (GitHub Actions + Terraform Cloud)

---

## Author

Govind  
Infrastructure as Code | Cloud | DevOps | AWS | Python


