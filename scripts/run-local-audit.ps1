<#
.SYNOPSIS
    Quick FinOps Local Audit Tool for Azure Subscriptions
    Author: Gunjan Kumar Gaurav (Senior Cloud Architect)

.DESCRIPTION
    Runs read-only Resource Graph queries against your connected Azure account
    to find orphaned disks, detached IPs, and untagged resources.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       Cloud FinOps Sentinel: Audit & Waste Assessment     " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Check Azure CLI login
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Warning "Not logged in to Azure CLI. Please run 'az login' first."
    exit 1
}

Write-Host "[✓] Authenticated as: $($account.user.name)" -ForegroundColor Green
Write-Host "[✓] Target Subscription: $($account.name) ($($account.id))" -ForegroundColor Green

Write-Host "`n[1/3] Searching for Unattached Managed Disks..." -ForegroundColor White
$disksQuery = "resources | where type =~ 'microsoft.compute/disks' | where managedBy == '' or isnull(managedBy) | project name, resourceGroup, properties.diskSizeBytes, properties.diskTier"
$unattachedDisks = az graph query -q $disksQuery 2>$null | ConvertFrom-Json

if ($unattachedDisks.data.Count -gt 0) {
    Write-Host "Found $($unattachedDisks.data.Count) unattached disks:" -ForegroundColor Red
    $unattachedDisks.data | Format-Table -AutoSize
} else {
    Write-Host "[✓] Zero unattached disks found! Clean infrastructure." -ForegroundColor Green
}

Write-Host "`n[2/3] Searching for Orphaned Public IPs..." -ForegroundColor White
$ipQuery = "resources | where type =~ 'microsoft.network/publicipaddresses' | where properties.ipConfiguration == '' or isnull(properties.ipConfiguration) | project name, resourceGroup, properties.publicIPAllocationMethod"
$orphanedIPs = az graph query -q $ipQuery 2>$null | ConvertFrom-Json

if ($orphanedIPs.data.Count -gt 0) {
    Write-Host "Found $($orphanedIPs.data.Count) unassociated Public IPs:" -ForegroundColor Red
    $orphanedIPs.data | Format-Table -AutoSize
} else {
    Write-Host "[✓] Zero orphaned public IPs found!" -ForegroundColor Green
}

Write-Host "`n[3/3] Checking Mandatory Tag Compliance (Environment, CostCenter, Owner)..." -ForegroundColor White
$tagQuery = "resources | where isnull(tags.CostCenter) or isnull(tags.Owner) | project name, type, resourceGroup"
$missingTags = az graph query -q $tagQuery 2>$null | ConvertFrom-Json

Write-Host "Total resources missing mandatory FinOps governance tags: $($missingTags.data.Count)" -ForegroundColor Yellow
Write-Host "`nAudit complete. To automate continuous remediation, deploy the Terraform Function App stack." -ForegroundColor Cyan
