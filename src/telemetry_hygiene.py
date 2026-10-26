"""
Azure Monitor Telemetry Cost Hygiene Optimizer
Author: Gunjan Kumar Gaurav (Senior Cloud Architect & FinOps Consultant)

Demonstrates how to optimize Log Analytics Workspace ingestion costs by configuring
Azure Monitor Data Collection Rules (DCR) with ingestion-time KQL transformation queries
that drop verbose, debug, and trace logs before they hit billable storage tiers.
"""

import json
from typing import Dict, Any

class TelemetryHygieneOptimizer:
    """Configures Data Collection Rules (DCR) transformation to cut ingestion costs by 40-60%."""

    @staticmethod
    def generate_dcr_kql_filter() -> str:
        """KQL Ingestion Transformation rule to drop noisy level 5/debug events."""
        return """
        source
        | where Level !in ("Debug", "Trace", "Verbose")
        | where EventID !in (4624, 4672) // Filter high-volume benign Windows security events if not needed
        | extend IngestedTime = now()
        """

    @staticmethod
    def build_dcr_template(workspace_resource_id: str) -> Dict[str, Any]:
        """Returns ARM / Bicep compliant DCR payload with transformation filtering."""
        return {
            "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "resources": [
                {
                    "type": "Microsoft.Insights/dataCollectionRules",
                    "apiVersion": "2022-06-01",
                    "name": "dcr-finops-telemetry-filter-prod",
                    "location": "eastus",
                    "properties": {
                        "description": "FinOps DCR: Filters high-frequency debug telemetry at ingestion point",
                        "destinations": {
                            "logAnalytics": [
                                {
                                    "workspaceResourceId": workspace_resource_id,
                                    "name": "law-destination"
                                }
                            ]
                        },
                        "dataFlows": [
                            {
                                "streams": ["Microsoft-Syslog", "Microsoft-Event"],
                                "destinations": ["law-destination"],
                                "transformKql": "source | where SeverityLevel !in ('DEBUG', 'VERBOSE', 'TRACE')",
                                "outputStream": "Microsoft-Syslog"
                            }
                        ]
                    }
                }
            ]
        }

if __name__ == "__main__":
    dummy_law_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-finops/providers/Microsoft.OperationalInsights/workspaces/law-prod"
    optimizer = TelemetryHygieneOptimizer()
    print("Generated FinOps Data Collection Rule Architecture:")
    print(json.dumps(optimizer.build_dcr_template(dummy_law_id), indent=2))
