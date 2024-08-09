# Define variables
$resourceGroupName = "on-premise"
$location = "Australia Central"
$vnetName = "on-premise-vnet"
$subnetName = "on-premise-subnet"
$nsgName = "on-premise-nsg"
$winServerPublicIpName = "win-server-ip"
$win11PublicIpName = "win-11-ip"
$winServerNicName = "win-server-nic"
$win11NicName = "win-11-nic"
$winServerVmName = "CSRP-DC"
$win11VmName = "workstation-1"
$vnetAddressPrefix = "10.0.0.0/16"
$subnetAddressPrefix = "10.0.1.0/24"
$winServerPrivateIp = "10.0.1.4"
$win11PrivateIp = "10.0.1.5"
$vmSize = "Standard_DS1_v2"
$winServerImage = "MicrosoftWindowsServer:WindowsServer:2022-Datacenter:latest"
$win11Image = "MicrosoftWindowsDesktop:Windows-11:win11-23h2-pro:latest"
$priority = "Spot"
$evictionPolicy = "Delete"
$maxPrice = 0.02

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create Virtual Network and Subnet
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vnetName -AddressPrefix $vnetAddressPrefix
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -AddressPrefix $subnetAddressPrefix | Set-AzVirtualNetwork

# Wait for the virtual network and subnet to be created
Start-Sleep -Seconds 30

# Retrieve the Subnet object
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName
$subnet = $vnet.Subnets | Where-Object { $_.Name -eq $subnetName }

# Create Network Security Group and Security Rule
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $nsgName
Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name "allow-rdp" -Access Allow -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 3389 | Set-AzNetworkSecurityGroup

# Create Public IP Addresses
$ip1 = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Static -Name $winServerPublicIpName
$ip2 = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Static -Name $win11PublicIpName

# Create Network Interfaces for the VMs
$nic1 = New-AzNetworkInterface -ResourceGroupName $resourceGroupName -Location $location -Name $winServerNicName -SubnetId $subnet.Id -PublicIpAddressId $ip1.Id -NetworkSecurityGroupId $nsg.Id
$nic2 = New-AzNetworkInterface -ResourceGroupName $resourceGroupName -Location $location -Name $win11NicName -SubnetId $subnet.Id -PublicIpAddressId $ip2.Id -NetworkSecurityGroupId $nsg.Id

# Update Network Interfaces with Static Private IP Address
$nic1.IpConfigurations[0].PrivateIpAllocationMethod = 'Static'
$nic1.IpConfigurations[0].PrivateIpAddress = $winServerPrivateIp
$nic1 | Set-AzNetworkInterface

$nic2.IpConfigurations[0].PrivateIpAllocationMethod = 'Static'
$nic2.IpConfigurations[0].PrivateIpAddress = $win11PrivateIp
$nic2 | Set-AzNetworkInterface

# Define credentials for the VMs
$adminUsername = "user_administrator"
$adminPassword = ConvertTo-SecureString "Password@123!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

# Create the Domain Controller VM with Spot priority, Eviction Policy, and Max Price
$winServerVmConfig = New-AzVMConfig -VMName $winServerVmName -VMSize $vmSize -Priority $priority -EvictionPolicy $evictionPolicy -MaxPrice $maxPrice | `
    Set-AzVMOperatingSystem -Windows -Credential $cred -ComputerName $winServerVmName | `
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest" | `
    Add-AzVMNetworkInterface -Id $nic1.Id

New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $winServerVmConfig -Tag $tag

# Create the Windows 11 VM with Spot priority, Eviction Policy, and Max Price
$win11VmConfig = New-AzVMConfig -VMName $win11VmName -VMSize $vmSize -Priority $priority -EvictionPolicy $evictionPolicy -MaxPrice $maxPrice | `
    Set-AzVMOperatingSystem -Windows -Credential $cred -ComputerName $win11VmName | `
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsDesktop" -Offer "Windows-11" -Skus "win11-21h2-pro" -Version "latest" | `
    Add-AzVMNetworkInterface -Id $nic2.Id

New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $win11VmConfig -Tag $tag

# Output VM details
$winServerVM = Get-AzVM -ResourceGroupName $resourceGroupName -Name $winServerVmName
$win11VM = Get-AzVM -ResourceGroupName $resourceGroupName -Name $win11VmName

$winServerVM
$win11VM
