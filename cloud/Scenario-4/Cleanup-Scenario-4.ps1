# Define variables
$joffUserName = "JoffThyer"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$resourceGroupName = "WebApp"
$networkWatcherResourceGroupName = "NetworkWatcherRG"

# Login to Azure
Connect-AzureAD

# Delete Joff Thyer user
$joffUserPrincipalName = "$joffUserName@$domain"
Remove-AzureADUser -ObjectId $joffUserPrincipalName
Write-Output "User '$joffUserPrincipalName' has been deleted."

# Delete the Resource Group (and all its resources)
Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob
Write-Output "Resource Group '$resourceGroupName' and all its resources are being deleted."

# Delete the Network Watcher Resource Group and all resources within it
Remove-AzResourceGroup -Name $networkWatcherResourceGroupName -Force -AsJob
Write-Output "Deletion of resource group '$networkWatcherResourceGroupName' has been initiated."