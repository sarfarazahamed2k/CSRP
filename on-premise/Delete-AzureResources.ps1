# Define variables
$resourceGroupName = "on-premise"
$networkWatcherResourceGroupName = "NetworkWatcherRG"

# Delete the Resource Group and all resources within it
Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob
Write-Output "Deletion of resource group '$resourceGroupName' has been initiated."

# Delete the Network Watcher Resource Group and all resources within it
Remove-AzResourceGroup -Name $networkWatcherResourceGroupName -Force -AsJob
Write-Output "Deletion of resource group '$networkWatcherResourceGroupName' has been initiated."

