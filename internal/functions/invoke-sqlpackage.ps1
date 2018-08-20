function Invoke-SqlPackage {
    [CmdletBinding()]
    param (
        [string]$Action, 
        
        [string]$DatabaseServer,
        
        [string]$DatabaseName,
        
        [string]$SqlUser,
        
        [string]$SqlPwd,
        
        [string]$TrustedConnection,
        
        [string]$FilePath,
        
        [string[]]$Properties
        ) 
              
    $sqlPackagePath = $Script:SqlPackage

    Invoke-TimeSignal -Start

    if (!(Test-Path $sqlPackagePath -PathType Leaf)) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>sqlpackage.exe</c> file on the machine. Please ensure that the latest <c='em'>SQL Server Management Studio</c> is installed using the <c='em'>default location</c> and run the cmdlet again. You can visit this link to obtain the latest SSMS: <c=`"green`">http://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms</c>"
        Stop-PSFFunction -Message "The sqlpackage.exe is missing on the system."
        return
    }

    Write-PSFMessage -Level Verbose -Message "Starting to prepare the parameters for sqlpackage.exe"

    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    if ($Action -eq "export") {
        $null = $Params.Add("/Action:export")
        $null = $Params.Add("/SourceServerName:$DatabaseServer")
        $null = $Params.Add("/SourceDatabaseName:$DatabaseName")
        $null = $Params.Add("/TargetFile:$FilePath")
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
    Start-Process -FilePath $sqlPackagePath -ArgumentList ($Params -join " ") -NoNewWindow -Wait
    
    Invoke-TimeSignal -End
    
    $true
}