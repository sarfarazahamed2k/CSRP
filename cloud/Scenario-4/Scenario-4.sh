#!/bin/bash

# Define variables
joffUserName="JoffThyer"
joffDisplayName="Joff Thyer"
joffPassword="AnotherP@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
resourceGroupName="WebApp"
vmName="UbuntuVM"
location="Australia Central"
webAppPublicIpName="web-app-ip"
sshPublicKeyName="DebianSSHKey"
adminUsername="azureuser"
adminPassword="Password@123!"

# Create Joff Thyer user
az ad user create --display-name "$joffDisplayName" \
                  --password "$joffPassword" \
                  --user-principal-name "$joffUserName@$domain" \
                  --mail-nickname "$joffUserName"

# Get the user ID for Joff Thyer
joffUserId=$(az ad user show --id "$joffUserName@$domain" --query 'id' --output tsv)

# Create Resource Group
az group create --name $resourceGroupName --location "$location"

# Create the VM with the specified credentials
az vm create --resource-group $resourceGroupName \
             --name $vmName \
             --location "$location" \
             --admin-username $adminUsername \
             --admin-password $adminPassword \
             --image Debian:debian-11:11:latest \
             --size Standard_B2s \
             --public-ip-address $webAppPublicIpName \
             --ssh-key-values "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+IO5szDz3DWcB/FBJOyTUdiy7YNa2E2qy9mcljfDM/s7u7pzl+RC7paHX5aFt6ifho7LvtpDsc9EVsLZBJDSRyaePniPQlBIb1YTAYAJpv9xGFXs8alv57Tx13aPHJ4KoQPBEr6NED53w/2Aqm/RmIDdEvPNLBG7UeMF43RmzhoA6fyajTTjJPDXXfd9vq/Kcf2PoNHL6f0fx98oJFmN1R4FzkcXvii7y43SGU942Eq9IfKPskbV9nCtZyyKJNmWIVwLE5gGMGJNKPylQfzXfzvu2FCdO+n3dvhy/M9xQKQMYLjYu0t7RWkD23LIe4z6ggLVlm1uN3E0WMSTPqtw9 azureuser"

# Assign Joff Thyer as the owner of the VM
roleId=$(az role definition list --name "Owner" --query "[0].id" --output tsv)
vmResourceId=$(az vm show --resource-group $resourceGroupName --name $vmName --query "id" --output tsv)

az role assignment create --assignee $joffUserId --role $roleId --scope $vmResourceId