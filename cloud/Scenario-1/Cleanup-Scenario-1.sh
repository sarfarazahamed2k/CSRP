#!/bin/bash

# Variables
userName="JohnStrand"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
resourceGroupName="HR-Department"

# Delete the Azure AD user
userPrincipalName="$userName@$domain"
userId=$(az ad user show --id $userPrincipalName --query 'id' --output tsv)
az ad user delete --id $userId

# Delete the resource group
az group delete --name $resourceGroupName --yes --no-wait
