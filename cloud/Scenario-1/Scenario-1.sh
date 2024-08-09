# Define variables
userName="JohnStrand"
userDisplayName="John Strand"
userPassword="P@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
resourceGroupName="HR-Department"
location="Australia Central"
storageAccountName="hrdepartmentstorage"
containerName="employee-container"
blobName="Employee-Details.xlsx"
localFilePath="./Employee-Details.xlsx"

# Create a new user
userId=$(az ad user create --display-name "$userDisplayName" \
                           --password "$userPassword" \
                           --user-principal-name "$userName@$domain" \
                           --mail-nickname "$userName" \
                           --query 'id' --output tsv)

# Create a resource group
az group create --name $resourceGroupName --location "$location"

# Create a storage account
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location "$location" --sku Standard_LRS

# Get the storage account key
accountKey=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)

# Create a blob container
az storage container create --name $containerName --account-name $storageAccountName --account-key $accountKey

# Upload the Excel file to the blob container
az storage blob upload --account-name $storageAccountName --account-key $accountKey --container-name $containerName --name $blobName --file $localFilePath

# Assign the Storage Blob Data Owner role to the user
scope=$(az storage account show --name $storageAccountName --resource-group $resourceGroupName --query 'id' --output tsv)
az role assignment create --assignee $userId --role "Storage Blob Data Owner" --scope $scope
az role assignment create --assignee $userId --role "Storage Blob Data Reader" --scope $scope