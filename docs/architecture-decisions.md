# Architecture Decisions — Project 2: Secure Multi-Tier Web Application with Zero Trust Architecture

## Compliance Alignment: HIPAA Zero Trust

---

## Decision 1: Systems Manager Session Manager Instead of Bastion Host

**Decision:** Use SSM Session Manager for EC2 access via VPC Interface Endpoints
**Alternatives Considered:** Bastion host (used in Project 1)

**Rationale:**
- Eliminates SSH key management and associated risk of key compromise
- All session activity logged to CloudWatch — full audit trail
- Follows Zero Trust principle: no implicit trust, verify every access request
- No inbound SSH port (22) required — reduces attack surface
- Meets HIPAA requirement for access controls and audit logging

---

## Decision 2: VPC Endpoints for Private AWS Service Access

**Decision:** Deploy S3 Gateway Endpoint and SSM/EC2Messages Interface Endpoints
**Alternatives Considered:** Route traffic over public internet via NAT Gateway

**Rationale:**
- Keeps all traffic on AWS private backbone — never traverses public internet
- Reduces data exfiltration risk — instances can't reach unexpected endpoints
- S3 Gateway Endpoint is free — no cost trade-off
- Meets HIPAA security rule requirement to protect data in transit
- Zero Trust principle: least privilege network access

---

## Decision 3: Secrets Manager for Database Credentials

**Decision:** Store all DB credentials in AWS Secrets Manager with random password generation
**Alternatives Considered:** Hardcoded credentials in Terraform variables, SSM Parameter Store

**Rationale:**
- Eliminates hardcoded secrets — passwords never appear in code or state files
- Automatic rotation capability available when needed
- Encryption at rest using AWS managed KMS key
- Access controlled via IAM — least privilege
- Meets HIPAA requirement to protect authentication credentials

---

## Decision 4: Aurora MySQL Instead of Standard RDS

**Decision:** Use RDS Aurora MySQL cluster with encryption at rest
**Alternatives Considered:** RDS MySQL Multi-AZ

**Rationale:**
- Aurora provides automated failover faster than standard RDS Multi-AZ
- Storage auto-scaling — no manual storage management
- Encryption at rest enabled by default — meets HIPAA data protection requirements
- Automated backups with 1-day retention for dev environment
- Security group restricts access to app tier only (port 3306) — network isolation

---

## Decision 5: Single NAT Gateway Instead of Multi-AZ

**Decision:** Deploy one NAT Gateway in us-east-1a only
**Alternatives Considered:** NAT Gateway per AZ (production best practice)

**Rationale:**
- Cost optimization for dev/portfolio environment (~$0.045/hr vs ~$0.09/hr)
- Production deployment would require NAT Gateway per AZ for high availability
- For a portfolio project, single NAT Gateway demonstrates the architecture concept
- Documented trade-off: AZ failure would lose outbound internet for private subnets

---

## Decision 6: EventBridge + Lambda for Automated Incident Response

**Decision:** EventBridge rule triggers Lambda on EC2 state changes
**Alternatives Considered:** Manual response, CloudWatch alarms only

**Rationale:**
- Automated response reduces MTTR (Mean Time To Respond) from hours to seconds
- Serverless — no infrastructure to manage, cost-effective
- EventBridge provides reliable event delivery with retry logic
- Meets HIPAA requirement for incident response procedures
- Lambda can be extended to isolate instances, snapshot EBS, or notify security team

---

## Decision 7: Inspector2 for Vulnerability Scanning

**Decision:** Enable AWS Inspector2 for EC2 vulnerability assessment
**Alternatives Considered:** Manual patching, third-party tools

**Rationale:**
- Continuous vulnerability scanning — not just point-in-time
- Integrates with Systems Manager for patch data
- Meets HIPAA requirement for ongoing security assessments
- Free trial available — validates capability at no cost for portfolio
- Findings can feed into Security Hub for centralized visibility

---

## Decision 8: ALB Sticky Sessions

**Decision:** Enable sticky sessions on ALB target group (1-day cookie duration)
**Alternatives Considered:** No session persistence, server-side session storage

**Rationale:**
- Ensures consistent user experience for stateful web applications
- lb_cookie method managed by ALB — no application changes required
- HIPAA-aligned: session data stays with same instance, reducing cross-instance data exposure