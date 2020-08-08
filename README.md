# Add-WACSingleSignOn
Enables single sign-on for your Windows Admin Center server by adding the server to the PrincipalsAllowedToDelegateToAccount property on all servers within your environment.
# SYNOPSIS 
This script will enable single sign-on in Windows Admin Center (WAC). It adds the WAC computer object as a constraint delegated object in all computer objects defined in an OU.
## Dependencies
- Permission to write to computer objects in specified OU
- AD Functional level of 2016 or higher
- ActiveDirectory PowerShell module
## Example
PS C:\Add-WACSingleSignOn -WacServer wac -DNofServersOU ‘OU=Servers,OU=IT,DC=contoso,DC=local’
### Parameter 1
WacServer – The name of the Windows Admin Center server within your organisation e.g. wac
### Parameter 2
DNofServersOU – The distinguished name of the top-level organisational unit where all computer objects are located.
