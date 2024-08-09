Import-Module AzureAD


# Define variables
$userName = "TimMedin"
$userDisplayName = "Tim Medin"
$userPassword = "P@ssw0rd!"
$domain = "sarfarazahamed2018gmail.onmicrosoft.com"
$roleId = "7c824ce9-2a4c-41d2-aeee-c7b1ec3ef439"

# Login to Azure
Connect-AzureAD

# Create a new user
$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = $userPassword

$user = New-AzureADUser -DisplayName $userDisplayName -PasswordProfile $passwordProfile -UserPrincipalName "$userName@$domain" -AccountEnabled $true -MailNickName $userName
$user

# Assign the user to the "Azure AD Joined Device Local Administrator" role
Add-AzureADDirectoryRoleMember -ObjectId $roleId -RefObjectId $user.ObjectId
Write-Output "User '$userDisplayName' has been added to the '$roleName' role."


#!/bin/bash

userName="TimMedin"
userDisplayName="Tim Medin"
userPassword="P@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
roleName="Azure AD Joined Device Local Administrator"
scope="/"


# Create a new user
newUser=$(az ad user create --display-name "$userDisplayName" --password "$userPassword" --user-principal-name "$userName@$domain" --mail-nickname "$userName")

# Get the ObjectId of the new user
userId=$(az ad user show --id "$userName@$domain" --query objectId --output tsv)

# Assign the user to the role
az role assignment create --assignee "$userId" --role "$roleName" --scope "$scope"

echo "User '$userDisplayName' has been added to the '$roleName' role."


userName="TimMedin"
userDisplayName="Tim Medin"
userPassword="P@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
roleName="Azure AD Joined Device Local Administrator"
scope="/"

# Create a new user and capture the JSON output
userId=$(az ad user create --display-name "$userDisplayName" \
                            --password "$userPassword" \
                            --user-principal-name "$userName@$domain" \
                            --mail-nickname "$userName" \
                            --query 'id' \
                            --output json)

# Extract the userId from the JSON output
userId=$(echo $newUser | jq -r '.id')

# Assign the user to the role
az role assignment create --assignee "$userId" --role "$roleName" --scope "$scope"

echo "User '$userDisplayName' has been added to the '$roleName' role."



userName="TimMedin"
userDisplayName="Tim Medin"
userPassword="P@ssw0rd!"
domain="sarfarazahamed2018gmail.onmicrosoft.com"
roleId="9f06204d-73c1-4d4c-880a-6edb90606fd8"

# Create a new user and capture the userId
userId=$(az ad user create --display-name "$userDisplayName" \
                           --password "$userPassword" \
                           --user-principal-name "$userName@$domain" \
                           --mail-nickname "$userName" \
                           --query 'id' \
                           --output tsv)

# Assign the user to the role
az rest --method POST --uri 'https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments' --body "{'principalId': '$userId', 'roleDefinitionId': '$roleId', 'directoryScopeId': '/'}"


echo "User '$userDisplayName' has been added to the '$roleId' role."