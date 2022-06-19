
<#
    .SYNOPSIS
        Set the database connection details
        
    .DESCRIPTION
        Overwrite the current database connection details directly in the web.config file
        
        Used when you want to connect a DEV box directly to a Tier2 database, and want to debug something that requires better data than usual
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        Obtain when you request JIT (Just-in-Time) access through the LCS portal
        
    .PARAMETER DatabaseName
        The name of the database
        
        Obtain when you request JIT (Just-in-Time) access through the LCS portal
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
        Obtain when you request JIT (Just-in-Time) access through the LCS portal
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
        Obtain when you request JIT (Just-in-Time) access through the LCS portal
        
    .PARAMETER Path
        Path to the web.config file that you want to update with new SQL connection details
        
        Default is: "K:\AosService\WebRoot\web.config" or what else drive that is recognized by the D365FO components as the service drive
        
    .EXAMPLE
        PS C:\> Set-D365WebConfigDatabase -DatabaseServer TestServer.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        
        Will overwrite Server, Database, Username and Password directly in the web.config file.
        It will save all details unencrypted.
        
    .NOTES
        Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365WebConfigDatabase {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName,

        [Parameter(Mandatory = $true)]
        [string] $SqlUser,

        [Parameter(Mandatory = $true)]
        [string] $SqlPwd,

        $Path = $(Join-Path -Path $Script:AOSPath -ChildPath $Script:WebConfig)
    )

    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    }

    process {
        $content = Get-Content -Path $Path -Raw

        $content = $content -replace '<add key="DataAccess.Database" value=".*" {0,1}/>', $('<add key="DataAccess.Database" value="{0}" />' -f "$DatabaseName")
        $content = $content -replace '<add key="DataAccess.DbServer" value=".*" {0,1}/>', $('<add key="DataAccess.DbServer" value="{0}" />' -f "$DatabaseServer")
        $content = $content -replace '<add key="DataAccess.SqlPwd" value=".*" {0,1}/>', $('<add key="DataAccess.SqlPwd" value="{0}" />' -f "$SqlPwd")
        $content = $content -replace '<add key="DataAccess.SqlUser" value=".*" {0,1}/>', $('<add key="DataAccess.SqlUser" value="{0}" />' -f "$SqlUser")

        [System.IO.File]::WriteAllText($Path, $content, $Utf8NoBomEncoding)
    }
}