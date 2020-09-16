
<#
    .SYNOPSIS
        Get D365FO Event Trace Provider
        
    .DESCRIPTION
        Get the full list of available Event Trace Providers for Dynamics 365 for Finance and Operations
        
    .PARAMETER Name
        Name of the provider that you are looking for
        
        Default value is "*" to show all Event Trace Providers
        
        Accepts an array of names, and will automatically add wildcard searching characters for each entry
        
    .EXAMPLE
        PS C:\> Get-D365EventTraceProvider
        
        Will list all available Event Trace Providers on a D365FO server.
        It will use the default option for the "Name" parameter.
        
    .EXAMPLE
        PS C:\> Get-D365EventTraceProvider -Name Tax
        
        Will list all available Event Trace Providers on a D365FO server which contains the keyvword "Tax".
        It will use the Name parameter value "Tax" while searching for Event Trace Providers.
        
        
    .EXAMPLE
        PS C:\> Get-D365EventTraceProvider -Name Tax,MR
        
        Will list all available Event Trace Providers on a D365FO server which contains the keyvword "Tax" or "MR".
        It will use the Name parameter array value ("Tax","MR") while searching for Event Trace Providers.
        
    .NOTES
        Tags: ETL, EventTracing, EventTrace
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet/function was inspired by the work of Michael Stashwick (@D365Stuff)
        
        He blog is located here: https://www.d365stuff.co/
        
        and the blogpost that pointed us in the right direction is located here: https://www.d365stuff.co/trace-batch-jobs-and-more-via-cmd-logman/
#>

function Get-D365EventTraceProvider {
    [CmdletBinding()]
    param (
        [string[]] $Name = @("*")
    )
    
    begin{
        $providers = Get-NetEventProvider -ShowInstalled | Where-Object name -like "Microsoft-Dynamics*" | Sort-Object name
    }

    process {
        foreach ($searchName in $Name) {
            $providers | Where-Object name -Like "*$searchName*" | Select-PSFObject "Name as ProviderName"
        }
    }
}