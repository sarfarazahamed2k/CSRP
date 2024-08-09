# Define variables
$userName = "JohnStrand"
$userDisplayName = "John Strand"
$userPassword = "P@ssw0rd!"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$resourceGroupName = "HR-Department"
$location = "Australia Central"
$storageAccountName = "hrdepartmentstorage"
$containerName = "employee-container"
$blobName = "Employee-Details.xlsx"
$localFilePath = "Employee-Details.xlsx"


# Login to Azure
Connect-AzureAD

# Create a new user
$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = $userPassword

$user = New-AzureADUser -DisplayName $userDisplayName -PasswordProfile $passwordProfile -UserPrincipalName "$userName@$domain" -AccountEnabled $true -MailNickName $userName
$user

# Create a resource group
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location
$resourceGroup

# Create a storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName Standard_LRS
$storageAccount

# Create a blob container
$ctx = $storageAccount.Context
$storageContainer = New-AzStorageContainer -Name $containerName -Context $ctx
$storageContainer

# Upload the Excel file to the blob container
$fileUpload = Set-AzStorageBlobContent -File $localFilePath -Container $containerName -Blob $blobName -Context $ctx
$fileUpload

# Assign the Storage Blob Data Owner role to the user
$roleAssignment = New-AzRoleAssignment -ObjectId $user.ObjectId -RoleDefinitionName "Storage Blob Data Owner" -Scope $storageAccount.Id
$roleAssignment