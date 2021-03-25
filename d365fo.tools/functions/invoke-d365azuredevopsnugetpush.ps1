
<#
    .SYNOPSIS
        Push a package / nuget to Azure DevOps
        
    .DESCRIPTION
        Push a package / nuget to an Azure DevOps feed
        
    .PARAMETER Path
        Path to the package / nuget that you want to push to the Azure DevOps feed
        
    .PARAMETER Source
        The logical name for the nuget source / connection that you want to use while pushing the package / nuget
        
        This requires you to register the nuget source, by hand, using the nuget.exe tool directly
        
        Base command to use:
    .\nuget sources add -Name "D365FO" -Source "https://pkgs.dev.azure.com/Contoso/DynamicsFnO/_packaging/D365Packages/NuGet/v3/index.json" -username "alice@contoso.dk" -password "uVWw43FLzaWk9H2EDguXMVYD3DaWj3aHBL6bfZkc21cmkwoK8X78"
        
        Please note that the password is in fact a personal access token and NOT your real password
        
        The value specified for Name in the nuget sources command, is the value to supply for Source for this cmdlet
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureDevOpsNugetPush -Path "c:\temp\d365fo.tools\microsoft.dynamics.ax.application.devalm.buildxpp.10.0.605.10014.nupkg" -Source "Contoso"
        
        This will push the package / nuget to the Azure DevOps feed.
        The file that will be pushed / uploaded is identified by the Path "c:\temp\d365fo.tools\microsoft.dynamics.ax.application.devalm.buildxpp.10.0.605.10014.nupkg".
        The request will be going to the Azure DevOps instance that is registered with the Source (Name) "Contoso" via the nuget.exe tool.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365AzureDevOpsNugetPush {
    [CmdletBinding()]
    param (
        [Alias('PackagePath')]
        [string] $Path,

        [Alias('Destination')]
        [Alias('NugetSource')]
        [string] $Source,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\Nuget"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $EnableException
    )

    process {
        $executable = $Script:NugetPath

        $params = New-Object System.Collections.Generic.List[string]

        $params.Add("push")
        $params.Add("`"$Path`"")
        $params.Add("-Source")
        $params.Add("`"$Source`"")
        $params.Add("-ApiKey")
        $params.Add("AzureDevOps")

        Invoke-Process -Executable $executable -Params $params.ToArray() -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
    }
}