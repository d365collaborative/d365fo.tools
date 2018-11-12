
<#
    .SYNOPSIS
        Shows the Database Access information for the D365 Environment
        
    .DESCRIPTION
        Gets all database information from the D365 environment
        
    .EXAMPLE
        PS C:\> Get-D365DatabaseAccess
        
        This will get all relevant details, including connection details, for the database configured for the environment
        
    .NOTES
        Tags: Database, Connection, Sql, SqlUser, SqlPwd
        
        Author: Rasmus Andersen (@ITRasmus)
        
        The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
        The call to the dll file gets all relevant connections details for the database server.
        
#>
function Get-D365DatabaseAccess {
    [CmdletBinding()]
    param ()

    $environment = Get-ApplicationEnvironment
    
    return $environment.DataAccess
}