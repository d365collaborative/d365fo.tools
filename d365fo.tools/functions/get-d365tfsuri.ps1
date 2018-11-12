
<#
    .SYNOPSIS
        Get the TFS / VSTS registered URL / URI
        
    .DESCRIPTION
        Gets the URI from the configuration of the local tfs connection in visual studio
        
    .PARAMETER Path
        Path to the tf.exe file that the cmdlet will invoke
        
    .EXAMPLE
        PS C:\> Get-D365TfsUri
        
        This will invoke the default tf.exe client located in the Visual Studio 2015 directory
        and fetch the configured URI.
        
    .NOTES
        Tags: TFS, VSTS, URL, URI, Servicing, Development
        
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365TfsUri {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string]$Path = $Script:TfDir
    )
    
    $executable = Join-Path $Path "tf.exe"
    if (!(Test-PathExists -Path $executable -Type Leaf)) {return}

    Write-PSFMessage -Level Verbose -Message "Invoking tf.exe"
    #* Small hack to get the output from the execution into a variable.
    $res = & $executable "settings" "connections" 2>$null
    Write-PSFMessage -Level Verbose -Message "Result from tf.exe: $res" -Target $res

    if (![string]::IsNullOrEmpty($res)) {
        [PSCustomObject]@{
            TfsUri = $res[2].Split(" ")[0]
        }
    }
    else {
        Write-PSFMessage -Level Host -Message "No TFS / VSTS connections found. It looks like you haven't configured the server connection and workspace yet."
    }
}