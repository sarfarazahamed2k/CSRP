# Variables
$domainName = "csrp.local"
$userPassword = ConvertTo-SecureString "UserPassword@123" -AsPlainText -Force
$userName = "SarfarazAhamed"
$userDisplayName = "Sarfaraz Ahamed"
$userOU = "CN=Users,DC=csrp,DC=local"
$adminUserDisplayName = "Administrator"
$adminUserName = "Administrator"
$adminUserPassword = ConvertTo-SecureString "P@ssw0rd@123!" -AsPlainText -Force
$entraConnectUserName = "EntraConnectUser"
$entraConnectUserDisplayName = "Microsoft Entra Connect User"
$entraConnectUserPassword = ConvertTo-SecureString "ConnectUser@123" -AsPlainText -Force


# Import the Active Directory module
Import-Module ActiveDirectory

# Create a new user
New-ADUser -Name $userDisplayName -SamAccountName $userName -UserPrincipalName "$userName@$domainName" -Path $userOU -AccountPassword $userPassword -Enabled $true

# Create a new administrator user
New-ADUser -Name $adminUserDisplayName -SamAccountName $adminUserName -UserPrincipalName "$adminUserName@$domainName" -Path $userOU -AccountPassword $adminUserPassword -Enabled $true

# Create a new Microsoft Entra Connect User
New-ADUser -Name $entraConnectUserDisplayName -SamAccountName $entraConnectUserName -UserPrincipalName "$entraConnectUserName@$domainName" -Path $userOU -AccountPassword $entraConnectUserPassword -Enabled $true

# Add the new user to the "Enterprise Admins" group
Add-ADGroupMember -Identity "Enterprise Admins" -Members $adminUserName

# Restart the server to complete the setup of users
Restart-Computer -Force