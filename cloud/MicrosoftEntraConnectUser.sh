#!/bin/bash

# Define variables
userName="AzureConnect"
userDisplayName="Azure Connect"
userPassword="P@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
roleId="62e90394-69f5-4237-9190-012177145e10"

# Create a new user and capture the userId
userId=$(az ad user create --display-name "$userDisplayName" \
                           --password "$userPassword" \
                           --user-principal-name "$userName@$domain" \
                           --mail-nickname "$userName" \
                           --query 'id' \
                           --output tsv)

# Assign the user to the Global Administrator role
az rest --method POST --uri 'https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments' \
                      --body "{'principalId': '$userId', 'roleDefinitionId': '$roleId', 'directoryScopeId': '/'}"

# Output the username and password
echo ""
echo "on-premise Active Directory Creds:"
echo "Username: csrp\SarfarazAhamed"
echo "Password: UserPassword@123"

echo ""

echo "Azure Entra ID Creds - John Strand:"
echo "Username: "JohnStrand"@$domain"
echo "Password: $userPassword"

echo ""

echo "on-premise Active Directory Creds:"
echo "Username: csrp\Administrator"
echo "Password: P@ssw0rd@123!"

echo ""

echo "Azure Entra ID Creds:"
echo "Username: $userName@$domain"
echo "Password: $userPassword"