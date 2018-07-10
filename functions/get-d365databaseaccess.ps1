<#
.SYNOPSIS
Shows the Database Access information for the D365 Environment

.DESCRIPTION
Gets all database information from the D365 environment

.EXAMPLE
Get-D365DatabaseAccess

.NOTES
Uses a .net dll from D365FO to retrieve a DataAccessObject containing database information
#>
function Get-D365DatabaseAccess
{

    $environment = Get-ApplicationEnvironment
    
    return $environment.DataAccess

}