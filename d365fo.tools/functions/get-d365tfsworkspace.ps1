
<#
    .SYNOPSIS
        Get the TFS / VSTS registered workspace path
        
    .DESCRIPTION
        Gets the workspace path from the configuration of the local tfs in visual studio
        
    .PARAMETER Path
        Path to the directory where the Team Foundation Client executable is located
        
    .PARAMETER TfsUri
        Uri to the TFS / VSTS that the workspace is connected to
        
    .EXAMPLE
        PS C:\> Get-D365TfsWorkspace -TfsUri https://PROJECT.visualstudio.com
        
        This will invoke the default tf.exe client located in the Visual Studio 2015 directory
        and fetch the configured URI.
        
    .NOTES
        Tags: TFS, VSTS, URL, URI, Servicing, Development
        
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365TfsWorkspace {
    [CmdletBinding()]
    param (
        [string] $Path = $Script:TfDir,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $TfsUri = $Script:TfsUri
    )
    
    process {
        $executable = Join-Path $Path "tf.exe"
        if (!(Test-PathExists -Path $executable -Type Leaf)) { return }

        if ([system.string]::IsNullOrEmpty($TfsUri)) {
            Write-PSFMessage -Level Host -Message "The supplied uri <c='em'>was empty</c>. Please update the active d365 environment configuration or simply supply the -TfsUri to the cmdlet."
            Stop-PSFFunction -Message "Stopping because TFS URI is missing."
            return
        }

        Write-PSFMessage -Level Verbose -Message "Invoking tf.exe"
        #* Small hack to get the output from the execution into a variable.
        $res = & $executable "vc" "workspaces" "/collection:$TfsUri" "/format:detailed" 2>$null

        if (![string]::IsNullOrEmpty($res)) {
            [PSCustomObject]@{
                TfsWorkspacePath = ($res | select-string "meta").ToString().Trim().Split(" ")[1]
            }
        }
        else {
            Write-PSFMessage -Level Host -Message "No matching workspace configuration found for the specified URI. Either the URI is wrong or you haven't configured the server connection / workspace details correctly."
        }
    }
}