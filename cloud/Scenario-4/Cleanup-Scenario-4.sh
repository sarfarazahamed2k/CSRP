#!/bin/bash

# Define variables
joffUserName="JoffThyer"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
resourceGroupName="WebApp"
networkWatcherResourceGroupName="NetworkWatcherRG"

# Delete Joff Thyer user
joffUserPrincipalName="$joffUserName@$domain"
userId=$(az ad user show --id $joffUserPrincipalName --query 'id' --output tsv)
az ad user delete --id $userId

# Delete the Resource Group (and all its resources)
az group delete --name $resourceGroupName --yes --no-wait

# Delete the Network Watcher Resource Group and all resources within it
az group delete --name $networkWatcherResourceGroupName --yes --no-wait