# Define variables
$resourceGroupName = "on-premise"
$winServerVmName = "CSRP-DC"
$win11VmName = "workstation-1"

# Paths to the scripts
$scriptPathDCDomain = ".\Configure-DC-Domain.ps1"
$scriptPathDCUsers = ".\Configure-DC-Users.ps1"
$scriptPathJoinDomain = ".\Join-Domain.ps1"

# Execute configuration scripts on the VMs
# Invoke script to configure Domain Controller
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $winServerVmName -CommandId 'RunPowerShellScript' -ScriptPath $scriptPathDCDomain

# Wait for the restart to complete before proceeding
Start-Sleep -Seconds 60

# Invoke script to configure Domain Controller Users
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $winServerVmName -CommandId 'RunPowerShellScript' -ScriptPath $scriptPathDCUsers

# Wait for the restart to complete before proceeding
Start-Sleep -Seconds 120

# Invoke script to join the Windows 11 machine to the domain
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $win11VmName -CommandId 'RunPowerShellScript' -ScriptPath $scriptPathJoinDomain