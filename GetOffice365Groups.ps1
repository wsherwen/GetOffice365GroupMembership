#User Parameters
$Office365User = Read-Host -Prompt 'Enter the Office365 Users UPN'
$Path = [Environment]::GetFolderPath("MyDocuments")

#Sets the UPN to Match the inputed address DEPREACTED
$MS365UPN = $Office365User

#Connection to MS365
if (Get-Module -ListAvailable -Name ExchangeOnlineManagement){
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline
}
else {
    Install-Module -Name ExchangeOnlineManagement -AllowClobber
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline
}

#Retrives the users DN
$CNName = Get-User $MS365UPN | select -ExpandProperty DistinguishedName

#Retrives all the groups the user is a member of.
$Groups = Get-Recipient -Filter "Members -eq '$CNName'" -RecipientTypeDetails GroupMailbox,MailUniversalDistributionGroup,MailUniversalSecurityGroup

#Prints the Group Membership
$Groups | Out-File $Path\$MS365UPN.txt

#Terminate the session
Get-PSSession | Remove-PSSession

#Terminates the Script
Read-Host -Prompt “Press Enter to exit, please check your documents folder for the content"