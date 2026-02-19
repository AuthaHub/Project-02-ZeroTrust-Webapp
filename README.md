# Project 2: Secure Multi-Tier Web Application with Zero Trust Architecture

## Business Context
A HIPAA-aligned zero trust web application for a healthcare company handling sensitive patient data.

## Architecture Overview
![Architecture Diagram](screenshots/P2-architecture-diagram.png)

### Phase 1 — Network Foundation
- Multi-AZ VPC with public, private app, and private database subnets
- VPC Endpoints (S3 Gateway, SSM, SSMMessages, EC2Messages) for private AWS service access
- NAT Gateway for outbound internet access from private subnets
- VPC Flow Logs → CloudWatch for network traffic analysis

### Phase 2 — Application Layer
- Application Load Balancer with sticky sessions
- Auto Scaling Group (EC2 t3.micro, Amazon Linux 2023)
- SSM Session Manager for secure instance access — no SSH keys or bastion
- RDS Aurora MySQL with encryption at rest
- Secrets Manager for database credentials — no hardcoded secrets

### Phase 3 — Security Automation
- AWS Inspector2 for continuous EC2 vulnerability scanning
- EventBridge + Lambda for automated incident response
- CloudWatch Alarms for CPU and unhealthy host detection
- SNS email alerts for security events

## Zero Trust Principles Applied
- No SSH keys — SSM Session Manager only
- No direct internet access to app or database tiers
- All AWS service traffic stays private via VPC Endpoints
- Least privilege IAM roles for all resources
- No hardcoded credentials — Secrets Manager only
- Automated incident response — no manual intervention required

## Compliance Alignment
- **HIPAA:** Access controls, audit logging, encryption at rest, incident response
- See `docs/architecture-decisions.md` for full rationale

## Infrastructure as Code
All resources deployed via Terraform across 3 phases:
- `terraform/phase-01-network-foundation`
- `terraform/phase-02-application-layer`
- `terraform/phase-03-security-automation`

## Tools & Technologies
- Terraform >= 1.0
- AWS (VPC, EC2, ALB, RDS Aurora, Secrets Manager, SSM, Inspector2, EventBridge, Lambda, SNS, CloudWatch)
- Python 3.12 (Lambda)
- GitHub: AuthaHub

## Resume Bullets
- "Designed and implemented a HIPAA-aligned zero trust architecture on AWS using Terraform, leveraging Systems Manager Session Manager for secure access, VPC Endpoints for private service connectivity, and Secrets Manager for credential management"
- "Built auto-scaling, highly available multi-tier application with ALB, RDS Aurora MySQL with encryption at rest, and automated vulnerability scanning via Inspector2"
- "Implemented automated incident response pipeline using EventBridge and Lambda to detect and alert on EC2 state changes in real-time"