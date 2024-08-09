# Variables
$userName = "JohnStrand"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$resourceGroupName = "HR-Department"

# Login to Azure
Connect-AzureAD

# Delete the Azure AD user
$userPrincipalName = "$userName@$domain"
Remove-AzureADUser -ObjectId (Get-AzureADUser -ObjectId $userPrincipalName).ObjectId
Write-Output "User '$userPrincipalName' has been deleted."


# Delete the resource group
Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob
Write-Output "Deletion of resource group '$resourceGroupName' has been initiated."
