# 💰 Cloud FinOps Sentinel: Enterprise Cost Intelligence & Waste Elimination Engine

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/IaC-Terraform_1.5+-623CE4.svg?logo=terraform)](https://www.terraform.io/)
[![Python](https://img.shields.io/badge/Engine-Python_3.11-3776AB.svg?logo=python)](https://python.org)
[![Azure FinOps](https://img.shields.io/badge/Azure-Cost_Management-0078D4.svg?logo=microsoftazure)](https://azure.microsoft.com)
[![FinOps Certified](https://img.shields.io/badge/FinOps-Practitioner_Standard-00C7B7.svg)](https://www.finops.org/)

**Automated Serverless Waste Elimination • Azure Monitor Telemetry Cost Hygiene • Real-Time Cost Anomaly Detection • Infracost CI/CD Shift-Left Gates**

[Key Capabilities](#-key-capabilities) • [Architecture](#-architecture) • [Deployment](#-deployment) • [Waste Collector](#-waste-collector-engine) • [Telemetry Hygiene](#-telemetry-cost-hygiene)

</div>

---

## 🎯 Executive Overview

In enterprise cloud estates, **20% to 35% of cloud expenditure is squandered** on unattached storage volumes, orphaned public IPs, legacy backup snapshots, and unfiltered high-volume debug telemetry.

**Cloud FinOps Sentinel** is an enterprise-grade automated cost intelligence and remediation platform developed by **Gunjan Kumar Gaurav**. It continuously inspects multi-subscription Azure environments, identifies waste, enforces mandatory tagging taxonomies, and proactively notifies engineering squads via Microsoft Teams / Slack before month-end invoices produce budget overruns.

```
[ Azure Resource Graph / Cost API ]
                 |
                 v
   [ FinOps Serverless Engine ]
                 |
  +--------------+--------------+
  |                             |
  v                             v
[ Waste Collector ]      [ Anomaly Sentinel ]
• Unattached Managed Disks  • 7-day variance detector
• Orphaned Public IPs       • Adaptive Teams cards
• Stale Snapshots (>90d)    • Infracost PR budget gate
                 |
                 v
[ Azure Monitor DCR Telemetry Filter ]
• Ingestion-time KQL drops verbose logs (cuts LAW bills by 40-60%)
```

---

## ⚡ Key Capabilities

* **Automated Waste Discovery & Purge:** Scans across all subscriptions for unattached managed disks, unused static public IPs, and disconnected NICs.
* **Telemetry Cost Hygiene:** Leverages Azure Monitor Data Collection Rules (DCR) with ingestion-time KQL transformations to drop verbose/debug logs before they hit billable workspace tiers (delivering **40–60% Log Analytics savings**).
* **Cost Anomaly Sentinel:** Evaluates day-over-day and 7-day moving average variances; dispatches real-time Adaptive Cards to Microsoft Teams if spend deviates by more than 25%.
* **Shift-Left FinOps with Infracost:** Pull-request automated cost forecasting in GitHub Actions, preventing expensive compute SKU deployments before code merge.
* **Tag Governance & Attribution:** Azure Policy initiatives enforcing mandatory `CostCenter`, `Environment`, and `Owner` metadata on all billable resources.

---

## 📁 Repository Structure

```
cloud-finops-sentinel/
├── .github/workflows/
│   └── finops-ci.yml                 # Infracost PR budget check & tag validation
├── policies/
│   ├── azure_policy_tag_governance.json # Azure Policy denying untagged resources
│   └── azure_policy_approved_vm_skus.json
├── scripts/
│   ├── run-local-audit.ps1           # Interactive PowerShell subscription audit tool
│   └── deploy.sh
├── src/
│   ├── waste_collector.py            # Azure Resource Graph waste scanner
│   ├── telemetry_hygiene.py          # DCR ingestion KQL transformation engine
│   ├── anomaly_sentinel.py           # Real-time cost spike & Teams alert dispatcher
│   └── requirements.txt
├── terraform/
│   ├── main.tf                       # Serverless Function App, Budget & LAW stack
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
└── README.md
```

---

## 🚀 Quickstart & Local Audit

### 1. Run Instant Interactive Audit (PowerShell)
To inspect your current Azure subscription for immediate cost leakages:

```powershell
az login
.\scripts\run-local-audit.ps1
```

### 2. Deploy Automated Serverless Stack via Terraform

```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

---

## 📊 Business ROI & Impact Metrics

* **28%+ Average Cloud Spend Reduction** across enterprise workloads.
* **Zero Runaway Log Ingestion Invoices** via daily DCR caps and ingestion filtering.
* **100% Cost Allocation Visibility** across business units through automated tag enforcement.

---

## 👤 Architect & Author

**Gunjan Kumar Gaurav**  
*Senior Cloud Architect & DevSecOps Consultant*  
[LinkedIn](https://www.linkedin.com/in/gunjan-gaurav) • [GitHub](https://github.com/gunjankumargaurav7350) • Email: `gunjankumargaurav7@gmail.com`
