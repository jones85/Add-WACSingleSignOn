function Add-WACSingleSignOn {
    <#
    .SYNOPSIS 
        This script will enable single sign-on in Windows Admin Center (WAC). It adds the WAC computer object as a constraint delegated object in all computer objects defined in an OU.
    .Dependencies
        1.	Permission to write to computer objects in specified OU
        2.	AD Functional level of 2016 or higher
        3.	ActiveDirectory PowerShell module

    .Example
        PS C:\Add-WACSingleSignOn -WacServer wac -DNofServersOU ‘OU=Servers,OU=IT,DC=contoso,DC=local’

    .Parameter 1
	    WacServer – The name of the Windows Admin Center server within your organisation e.g. wac

    .Parameter 2
	    DNofServersOU – The distinguished name of the top-level organisational unit where all computer objects are located.

    #>
    [CmdletBinding()]
    param(
        
        [Parameter(Mandatory)]
        [string]$WacServer,
        [Parameter(Mandatory)]
        [string]$DNofServersOU

    
    )
    process {

                # Add and import AD PowerShell
                If(!(Get-Module -Name ActiveDirectory)){
                    Import-Module ActiveDirectory -ErrorAction Stop

                }

                If($WacServer -eq $null){

                    throw 'No Windows Admin Center server specified.'
                }
       
                # Server names and Cluster names that you want to manage with Windows Admin Center in your domain
                $oServers = Get-ADObject -SearchBase $DNofServersOU -LDAPFilter 'objectClass=computer' -ErrorAction Continue

                If($oServers -eq $null){
                    throw 'Target server OU was not defined.'
                }
                                              
                # Import the WAC server object
                $oWac = Get-ADComputer -Identity $WacServer -ErrorAction SilentlyContinue

                # Set contstraint delegation on all objects
                foreach ($oServer in $oServers)
                {
                    $serverObject = Get-ADComputer -Identity $oServer
                    Set-ADComputer -Identity $serverObject -PrincipalsAllowedToDelegateToAccount $oWac -Verbose
                }

        try {
        } catch {
            Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        }
    }
}