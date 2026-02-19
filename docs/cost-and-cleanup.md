# Cost & Cleanup — Project 2: Secure Multi-Tier Web Application with Zero Trust Architecture

## Estimated Costs (while running)

| Resource | Cost | Notes |
|---|---|---|
| NAT Gateway | ~$0.045/hr + data | Most expensive Phase 1 resource |
| SSM Interface Endpoints (x3) | ~$0.01/hr each | ~$0.03/hr total |
| Aurora MySQL Instance | ~$0.073/hr | db.t3.medium |
| ALB | ~$0.008/hr + LCUs | Minimal at dev traffic |
| EC2 t3.micro (x1) | ~$0.0104/hr | Free tier eligible |
| Inspector2 | $0 | Free trial active |
| Lambda | $0 | Free tier (1M requests/month) |
| CloudWatch | ~$0.01/hr | Log ingestion |
| Secrets Manager | ~$0.40/month | Per secret |

**Estimated total if left running 24hrs: ~$5-7**

---

## Teardown Order (IMPORTANT — must destroy in reverse order)

### Step 1 — Destroy Phase 3
```powershell
cd terraform\phase-03-security-automation
terraform destroy
```
Type `yes` when prompted.

### Step 2 — Destroy Phase 2
```powershell
cd ..\phase-02-application-layer
terraform destroy
```
Type `yes` when prompted. Aurora takes 5-10 minutes to delete.

### Step 3 — Destroy Phase 1
```powershell
cd ..\phase-01-network-foundation
terraform destroy
```
Type `yes` when prompted.

---

## Post-Destroy Verification Checklist

- [ ] No EC2 instances running
- [ ] No RDS clusters running
- [ ] No NAT Gateways (these bill even when idle)
- [ ] No VPC Interface Endpoints
- [ ] No ALB running
- [ ] Secrets Manager secret deleted
- [ ] Inspector2 disabled
- [ ] CloudWatch Log Groups deleted (optional — minimal cost)

---

## Cost Optimization Decisions Made

- Single NAT Gateway instead of per-AZ (~50% savings)
- Aurora single instance instead of Multi-AZ replica
- t3.micro for EC2 (free tier eligible)
- ASG desired capacity set to 1 for dev
- Inspector2 free trial utilized
- `skip_final_snapshot = true` on Aurora — no snapshot storage cost
- `recovery_window_in_days = 0` on Secrets Manager — immediate deletion

---

## Teardown Log

**Date:** February 19, 2026

### Destroy Order & Results
- **Phase 3** (security-automation) → Destroyed successfully
- **Phase 2** (application-layer) → Destroyed successfully (~8 min for Aurora)
- **Phase 1** (network-foundation) → Destroyed successfully

### Post-Destroy Verification Checklist
- [x] No EC2 instances running
- [x] No RDS clusters running
- [x] No NAT Gateways running
- [x] No VPC Interface Endpoints
- [x] No ALB running
- [x] Secrets Manager secret deleted
- [x] Inspector2 disabled
- [x] All resources confirmed destroyed via terraform destroy output

### Total Time Resources Were Running
- Phase 1: ~3 hours
- Phase 2: ~2 hours (Aurora)
- Phase 3: ~1 hour
- **Estimated total cost: <$5**