## 2026-02-16
Project scaffolding created.
No AWS resources created.
Terraform not initialized.

# Build Log — Project 2: Secure Multi-Tier Web Application with Zero Trust Architecture

## Project Overview
- **Date:** February 19, 2026
- **Region:** us-east-1
- **IaC Tool:** Terraform
- **Compliance Alignment:** HIPAA Zero Trust

---

## Phase 1 — Network Foundation

**Resources Deployed:**
- VPC (10.0.0.0/16) with DNS hostnames enabled
- 2 public subnets, 2 private app subnets, 2 private DB subnets across us-east-1a and us-east-1b
- Internet Gateway, NAT Gateway (single AZ for cost)
- Public and private route tables with associations
- S3 Gateway VPC Endpoint (free)
- SSM, SSM Messages, EC2 Messages Interface VPC Endpoints
- VPC Endpoint security group (HTTPS/443 from VPC only)
- VPC Flow Logs → CloudWatch Log Group (30 day retention)
- IAM role for VPC Flow Logs

**Terraform:** `terraform/phase-01-network-foundation`
**Resources Created:** 27
**Apply Status:** ✅ Success

### Troubleshooting
- **Error:** `versions.tf` conflicted with `providers.tf` — both contained `required_providers` block
  - **Fix:** Cleared `versions.tf` contents, kept configuration in `providers.tf` only
- **Error:** `main.tf` paste was truncated at line 106, leaving a partial `res` block
  - **Fix:** Identified truncation point using `Get-Content`, replaced from line 106 to end of file
- **Error:** Wrong directory when running `terraform plan` — ran from `phase-01` instead of `phase-02`
  - **Fix:** Used `cd` to navigate to correct phase directory before running commands

---

## Phase 2 — Application Layer

**Resources Deployed:**
- ALB security group (HTTP/80, HTTPS/443 from internet)
- App EC2 security group (HTTP/80 from ALB only)
- RDS security group (MySQL/3306 from app tier only)
- Application Load Balancer (internet-facing, multi-AZ)
- ALB Target Group with sticky sessions enabled
- HTTP listener on port 80
- IAM role for EC2 with SSM managed instance core policy
- EC2 instance profile
- Launch template (Amazon Linux 2023, t3.micro, no public IP)
- Auto Scaling Group (min 1, max 2, desired 1)
- Secrets Manager secret for DB credentials (no hardcoded secrets)
- Random password generator for DB
- RDS subnet group
- Aurora MySQL cluster (encrypted at rest)
- Aurora writer instance (db.t3.medium)

**Terraform:** `terraform/phase-02-application-layer`
**Resources Created:** 18
**Apply Status:** ✅ Success
**Aurora Provisioning Time:** ~8 minutes

### Troubleshooting
- **Error:** `terraform plan` showed no changes — ran from wrong directory (`phase-01` instead of `phase-02`)
  - **Fix:** Navigated to correct directory with `cd`
- **Error:** Inconsistent dependency lock file on `terraform plan`
  - **Fix:** Ran `terraform init` in `phase-02` directory first before planning
- **Error:** PowerShell `>>` prompt appeared — unclosed quote in command
  - **Fix:** Used `Ctrl+C` to escape, re-ran commands as separate statements

---

## Phase 3 — Security Automation

**Resources Deployed:**
- SNS topic for security alerts with email subscription
- IAM role and policy for Lambda incident response
- Lambda function (Python 3.12) — EC2 state change incident response
- EventBridge rule — triggers Lambda on EC2 stopped/terminated events
- Lambda permission for EventBridge invocation
- AWS Inspector2 enabled for EC2 vulnerability scanning
- CloudWatch alarm — CPU utilization > 80%
- CloudWatch alarm — unhealthy ALB hosts > 0

**Terraform:** `terraform/phase-03-security-automation`
**Resources Created:** 11
**Apply Status:** ✅ Success
**Inspector Status:** Free trial active — $0 projected cost

### Troubleshooting
- **Error:** PowerShell `>>` multi-line prompt caused `cd` and `terraform output` commands to not execute
  - **Fix:** Used `Ctrl+C` to escape prompt, ran each command separately