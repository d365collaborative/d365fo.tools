
<#
    .SYNOPSIS
        Start a browser session that executes SysRunnerClass
        
    .DESCRIPTION
        Makes it possible to call any runnable class directly from the browser, without worrying about the details
        
    .PARAMETER ClassName
        The name of the class you want to execute
        
    .PARAMETER Company
        The company for which you want to execute the class against
        
        Default value is: "DAT"
        
    .PARAMETER Url
        The URL you want to execute against
        
        Default value is the Fully Qualified Domain Name registered on the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365SysRunnerClass -ClassName SysFlushAOD
        
        Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "DAT" (default value) company
        
    .EXAMPLE
        PS C:\> Invoke-D365SysRunnerClass -ClassName SysFlushAOD -Company "USMF"
        
        Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "USMF" company
        
    .EXAMPLE
        PS C:\> Invoke-D365SysRunnerClass -ClassName SysFlushAOD -Url https://Test.cloud.onebox.dynamics.com
        
        Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "DAT" company, on the https://Test.cloud.onebox.dynamics.com URL
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365SysRunnerClass {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [string] $ClassName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        
        [string] $Company = $Script:Company,
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $Url = $Script:Url
    )

    $executingUrl = "$Url`?cmp=$Company&mi=SysClassRunner&cls=$ClassName"
    
    Start-Process $executingUrl
}