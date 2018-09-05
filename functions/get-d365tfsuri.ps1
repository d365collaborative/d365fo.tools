<#
.SYNOPSIS
Get the TFS / VSTS registered URL / URI

.DESCRIPTION
Gets the URI from the configuration of the local tfs connection in visual studio

.PARAMETER Path
Path to the tf.exe file that the cmdlet will invoke

.EXAMPLE
Get-D365TfsUri

This will invoke the default tf.exe client located in the Visual Studio 2015 directory
and fetch the configured URI.

.NOTES
Author: Mötz Jensen (@Splaxi)
#>
function Get-D365TfsUri {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string]$Path = $Script:TfDir
    )
    
    $executable = Join-Path $Path "tf.exe"

    if ((Test-Path $executable -PathType Leaf) -eq $false) {
        Write-PSFMessage -Level Host -Message "The <c='em'>$executable</c> file wasn't found. Please ensure the file <c='em'>exists </c> and you have enough <c='em'>permission/c> to access the file."
        Stop-PSFFunction -Message "Stopping because a file is missing."
        return
    }

    Write-PSFMessage -Level Verbose -Message "Invoking tf.exe"
    #* Small hack to get the output from the execution into a variable.
    $res = & $executable "settings" "connections"

    if (![string]::IsNullOrEmpty($res)) {
        [PSCustomObject]@{
            TfsUri = $res[2].Split(" ")[0]
        }
    }
}