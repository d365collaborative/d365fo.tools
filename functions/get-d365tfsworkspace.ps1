<#
.SYNOPSIS
Get the TFS / VSTS registered workspace path

.DESCRIPTION
Gets the workspace path from the configuration of the local tfs in visual studio

.PARAMETER TfsUri
Uri to the TFS / VSTS that the workspace is connected to

.EXAMPLE
Get-D365TfsWorkspace -TfsUri https://PROJECT.visualstudio.com

This will invoke the default tf.exe client located in the Visual Studio 2015 directory
and fetch the configured URI.

.NOTES
Author: Mötz Jensen (@Splaxi)
#>
function Get-D365TfsWorkspace {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string]$Path = $Script:TfDir,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 2 )]
        [string]$TfsUri = $Script:TfsUri
    )
    
    $executable = Join-Path $Path "tf.exe"

    if ((Test-Path $executable -PathType Leaf) -eq $false) {
        Write-PSFMessage -Level Host -Message "The <c='em'>$executable</c> file wasn't found. Please ensure the file <c='em'>exists </c> and you have enough <c='em'>permission/c> to access the file."
        Stop-PSFFunction -Message "Stopping because a file is missing."
        return
    }

    if([system.string]::IsNullOrEmpty($TfsUri)){
        Write-PSFMessage -Level Host -Message "The supplied uri <c='em'>was empty</c>. Please update the active d365 environment configuration or simply supply the -TfsUri to the cmdlet."
        Stop-PSFFunction -Message "Stopping because TFS URI is missing."
        return
    }

    Write-PSFMessage -Level Verbose -Message "Invoking tf.exe"
    #* Small hack to get the output from the execution into a variable.
    $res = & $executable "vc" "workspaces" "/collection:$TfsUri" "/format:detailed"

    if (![string]::IsNullOrEmpty($res)) {
        [PSCustomObject]@{
            TfsWorkspacePath = ($res | select-string "meta").ToString().Trim().Split(" ")[1]
        }
    }
}