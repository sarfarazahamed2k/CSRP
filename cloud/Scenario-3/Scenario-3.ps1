# Define variables
$jeffUserName = "JeffMcJunkin"
$jeffDisplayName = "Jeff McJunkin"
$jeffPassword = "SecureP@ssw0rd!"
$serviceAccountName = "ServiceAccount"
$serviceAccountDisplayName = "Service Account"
$serviceAccountPassword = "S3rv1ceP@ssw0rd!"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$applicationAdminRoleId = "ebefc253-edfb-46a6-bc47-25d2b51c6836" 
$privilegedRoleAdminRoleId = "2af5faa9-6bb9-4cf4-a340-bd6357e8fe81"

# Login to Azure
Connect-AzureAD

# Create Jeff McJunkin user
$jeffPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$jeffPasswordProfile.Password = $jeffPassword

$jeffUser = New-AzureADUser -DisplayName $jeffDisplayName -PasswordProfile $jeffPasswordProfile -UserPrincipalName "$jeffUserName@$domain" -AccountEnabled $true -MailNickName $jeffUserName
$jeffUser

# Assign Jeff McJunkin to the Application Admin role
Add-AzureADDirectoryRoleMember -ObjectId $applicationAdminRoleId -RefObjectId $jeffUser.ObjectId
Write-Output "User '$jeffDisplayName' has been added to the 'Application Admin' role."

# Create service account
$serviceAccountPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$serviceAccountPasswordProfile.Password = $serviceAccountPassword

$serviceAccountUser = New-AzureADUser -DisplayName $serviceAccountDisplayName -PasswordProfile $serviceAccountPasswordProfile -UserPrincipalName "$serviceAccountName@$domain" -AccountEnabled $true -MailNickName $serviceAccountName
$serviceAccountUser

# Assign the service account to the Privileged Role Administrator role
Add-AzureADDirectoryRoleMember -ObjectId $privilegedRoleAdminRoleId -RefObjectId $serviceAccountUser.ObjectId
Write-Output "Service account '$serviceAccountDisplayName' has been added to the 'Privileged Role Administrator' role."
