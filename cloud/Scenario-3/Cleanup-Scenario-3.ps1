# Define variables
$jeffUserName = "JeffMcJunkin"
$serviceAccountName = "ServiceAccount"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"

# Login to Azure
Connect-AzureAD

# Delete Jeff McJunkin user
$jeffUserPrincipalName = "$jeffUserName@$domain"
$jeffUser = Get-AzureADUser -ObjectId $jeffUserPrincipalName
Remove-AzureADUser -ObjectId $jeffUser.ObjectId
Write-Output "User '$jeffUserPrincipalName' has been deleted."

# Delete service account
$serviceAccountPrincipalName = "$serviceAccountName@$domain"
$serviceAccountUser = Get-AzureADUser -ObjectId $serviceAccountPrincipalName
Remove-AzureADUser -ObjectId $serviceAccountUser.ObjectId
Write-Output "User '$serviceAccountPrincipalName' has been deleted."