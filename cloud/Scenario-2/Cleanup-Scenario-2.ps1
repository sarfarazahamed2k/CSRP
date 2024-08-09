# Variables
$userName = "TimMedin"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$resourceGroupName = "Finance-Department"

# Login to Azure
Connect-AzureAD

# Delete the Azure AD user
$userPrincipalName = "$userName@$domain"
Remove-AzureADUser -ObjectId (Get-AzureADUser -ObjectId $userPrincipalName).ObjectId
Write-Output "User '$userPrincipalName' has been deleted."
