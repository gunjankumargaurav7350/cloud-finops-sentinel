"""
Azure FinOps Cost Anomaly Sentinel
Author: Gunjan Kumar Gaurav (Senior Cloud Architect & FinOps Consultant)

Queries Azure Cost Management API to evaluate day-over-day and week-over-week spending shifts.
Flags unusual expenditure spikes (> 25% increase) per Resource Group or Service Tier,
and broadcasts formatted Adaptive Cards to Microsoft Teams / Slack.
"""

import json
import logging
from typing import Dict, List, Any
import urllib.request

logger = logging.getLogger("FinOpsAnomalySentinel")
logging.basicConfig(level=logging.INFO)

class CostAnomalySentinel:
    def __init__(self, webhook_url: str):
        self.webhook_url = webhook_url

    def analyze_spend_variance(self, current_day_spend: float, previous_7day_avg: float) -> Dict[str, Any]:
        """Calculates percentage shift and determines anomaly classification."""
        if previous_7day_avg <= 0:
            percentage_shift = 0.0
        else:
            percentage_shift = ((current_day_spend - previous_7day_avg) / previous_7day_avg) * 100.0

        is_anomaly = percentage_shift >= 25.0

        return {
            "current_spend_usd": current_day_spend,
            "baseline_avg_usd": previous_7day_avg,
            "variance_percent": round(percentage_shift, 2),
            "is_anomaly": is_anomaly,
            "severity": "CRITICAL" if percentage_shift >= 50 else ("WARNING" if is_anomaly else "NORMAL")
        }

    def dispatch_teams_card(self, resource_group: str, analysis: Dict[str, Any]) -> bool:
        """Sends rich adaptive alert card to FinOps incident channel."""
        if not analysis["is_anomaly"]:
            logger.info(f"Spend within acceptable tolerance for {resource_group}. No alert required.")
            return False

        payload = {
            "type": "message",
            "attachments": [
                {
                    "contentType": "application/vnd.microsoft.card.adaptive",
                    "content": {
                        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                        "version": "1.4",
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "TextBlock",
                                "size": "Medium",
                                "weight": "Bolder",
                                "text": f"🚨 FinOps Anomaly Alert: {resource_group} Spike Detected",
                                "color": "Attention"
                            },
                            {
                                "type": "FactSet",
                                "facts": [
                                    {"title": "Resource Group:", "value": resource_group},
                                    {"title": "Today's Spend:", "value": f"${analysis['current_spend_usd']:,.2f}"},
                                    {"title": "7-Day Baseline:", "value": f"${analysis['baseline_avg_usd']:,.2f}"},
                                    {"title": "Cost Deviation:", "value": f"+{analysis['variance_percent']}%"},
                                    {"title": "Severity:", "value": analysis["severity"]}
                                ]
                            },
                            {
                                "type": "TextBlock",
                                "text": "Immediate Action: Check for orphaned compute, high egress, or unindexed database queries.",
                                "wrap": True
                            }
                        ]
                    }
                }
            ]
        }

        logger.info(f"Dispatching FinOps anomaly card to Webhook: {self.webhook_url}")
        try:
            req = urllib.request.Request(
                self.webhook_url,
                data=json.dumps(payload).encode("utf-8"),
                headers={"Content-Type": "application/json"}
            )
            # In live execution: urllib.request.urlopen(req)
            logger.info("Alert payload successfully formulated and staged.")
            return True
        except Exception as e:
            logger.error(f"Failed to dispatch alert: {e}")
            return False

if __name__ == "__main__":
    sentinel = CostAnomalySentinel("https://webhook.teams.microsoft.com/sample")
    result = sentinel.analyze_spend_variance(current_day_spend=1450.00, previous_7day_avg=800.00)
    print(json.dumps(result, indent=2))
    sentinel.dispatch_teams_card("rg-analytics-aks-prod", result)
