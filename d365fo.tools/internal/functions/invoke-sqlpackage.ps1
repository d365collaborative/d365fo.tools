
<#
    .SYNOPSIS
        Invoke the sqlpackage executable
        
    .DESCRIPTION
        Invoke the sqlpackage executable and pass the necessary parameters to it
        
    .PARAMETER Action
        Can either be import or export
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user.
        
    .PARAMETER TrustedConnection
        Should the sqlpackage work with TrustedConnection or not
        
    .PARAMETER FilePath
        Path to the file, used for either import or export
        
    .PARAMETER Properties
        Array of all the properties that needs to be parsed to the sqlpackage.exe
        
    .EXAMPLE
        PS C:\> $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd
        }
        
        PS C:\> $ImportParams = @{
        Action   = "import"
        FilePath = $BacpacFile
        }
        
        PS C:\> Invoke-SqlPackage @BaseParams @ImportParams
        
        This will start the sqlpackage.exe file and pass all the needed parameters.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
#>
function Invoke-SqlPackage {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [ValidateSet('Import', 'Export')]
        [string]$Action,
        
        [string]$DatabaseServer,
        
        [string]$DatabaseName,
        
        [string]$SqlUser,
        
        [string]$SqlPwd,
        
        [string]$TrustedConnection,
        
        [string]$FilePath,
        
        [string[]]$Properties
    )
              
    $executable = $Script:SqlPackage

    Invoke-TimeSignal -Start

    if (!(Test-PathExists -Path $executable -Type Leaf)) {return}

    Write-PSFMessage -Level Verbose -Message "Starting to prepare the parameters for sqlpackage.exe"

    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    if ($Action -eq "export") {
        $null = $Params.Add("/Action:export")
        $null = $Params.Add("/SourceServerName:$DatabaseServer")
        $null = $Params.Add("/SourceDatabaseName:$DatabaseName")
        $null = $Params.Add("/TargetFile:`"$FilePath`"")
        $null = $Params.Add("/Properties:CommandTimeout=1200")
    
        if (!$UseTrustedConnection) {
            $null = $Params.Add("/SourceUser:$SqlUser")
            $null = $Params.Add("/SourcePassword:$SqlPwd")
        }
        
        Remove-Item -Path $FilePath -ErrorAction SilentlyContinue -Force
    }
    else {
        $null = $Params.Add("/Action:import")
        $null = $Params.Add("/TargetServerName:$DatabaseServer")
        $null = $Params.Add("/TargetDatabaseName:$DatabaseName")
        $null = $Params.Add("/SourceFile:$FilePath")
        $null = $Params.Add("/Properties:CommandTimeout=1200")
        
        if (!$UseTrustedConnection) {
            $null = $Params.Add("/TargetUser:$SqlUser")
            $null = $Params.Add("/TargetPassword:$SqlPwd")
        }
    }

    foreach ($item in $Properties) {
        $null = $Params.Add("/Properties:$item")
    }

    Write-PSFMessage -Level Verbose "Start sqlpackage.exe with parameters" -Target $Params
    
    #! We should consider to redirect the standard output & error like this: https://stackoverflow.com/questions/8761888/capturing-standard-out-and-error-with-start-process
    Start-Process -FilePath $executable -ArgumentList ($Params -join " ") -NoNewWindow -Wait
    
    Invoke-TimeSignal -End
    
    $true
}