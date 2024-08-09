# Define variables
$joffUserName = "JoffThyer"
$joffDisplayName = "Joff Thyer"
$joffPassword = "AnotherP@ssw0rd!"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$resourceGroupName = "WebApp"
$vmName = "UbuntuVM"
$location = "Australia Central"
$webAppPublicIpName = "web-app-ip"
$sshPublicKeyName = "DebianSSHKey"

# Login to Azure
Connect-AzureAD

# Create Joff Thyer user
$joffPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$joffPasswordProfile.Password = $joffPassword

$joffUser = New-AzureADUser -DisplayName $joffDisplayName -PasswordProfile $joffPasswordProfile -UserPrincipalName "$joffUserName@$domain" -AccountEnabled $true -MailNickName $joffUserName
$joffUser

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Define credentials for the VMs
$adminUsername = "azureuser"
$adminPassword = ConvertTo-SecureString "Password@123!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

New-AzVm -ResourceGroupName $resourceGroupName -Name $vmName -Location $location -Credential $cred -image Debian11 -OpenPorts 80 -size Standard_B2s -PublicIpAddressName $webAppPublicIpName -GenerateSshKey -SshKeyName $sshPublicKeyName

# Login to Azure
Connect-AzureAD

# Assign Joff Thyer as the owner of the VM
$roleId = (Get-AzRoleDefinition -Name "Owner").Id
$vmResourceId = (Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName).Id

New-AzRoleAssignment -ObjectId $joffUser.ObjectId -RoleDefinitionId $roleId -Scope $vmResourceId
Write-Output "User '$joffDisplayName' has been assigned as the owner of the VM '$vmName'."