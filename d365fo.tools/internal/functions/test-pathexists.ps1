
<#
    .SYNOPSIS
        Test multiple paths
        
    .DESCRIPTION
        Easy way to test multiple paths for public functions and have the same error handling
        
    .PARAMETER Path
        Array of paths you want to test
        
        They have to be the same type, either file/leaf or folder/container
        
    .PARAMETER Type
        Type of path you want to test
        
        Either 'Leaf' or 'Container'
        
    .PARAMETER Create
        Instruct the cmdlet to create the directory if it doesn't exist
        
    .PARAMETER ShouldNotExist
        Instruct the cmdlet to return true if the file doesn't exists
        
    .EXAMPLE
        PS C:\> Test-PathExists "c:\temp","c:\temp\dir" -Type Container
        
        This will test if the mentioned paths (folders) exists and the current context has enough permission.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
#>
function Test-PathExists {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $True)]
        [AllowEmptyString()]
        [string[]] $Path,

        [ValidateSet('Leaf', 'Container')]
        [Parameter(Mandatory = $True)]
        [string] $Type,

        [switch] $Create,

        [switch] $ShouldNotExist
    )
    
    $res = $false

    $arrList = New-Object -TypeName "System.Collections.ArrayList"
         
    foreach ($item in $Path) {

        if ([string]::IsNullOrEmpty($item)) {
            Stop-PSFFunction -Message "Stopping because path was either null or empty string." -StepsUpward 1
            return
        }

        Write-PSFMessage -Level Debug -Message "Testing the path: $item" -Target $item
        $temp = Test-Path -Path $item -Type $Type

        if ((-not $temp) -and ($Create) -and ($Type -eq "Container")) {
            Write-PSFMessage -Level Debug -Message "Creating the path: $item" -Target $item
            $null = New-Item -Path $item -ItemType Directory -Force -ErrorAction Stop
            $temp = $true
        }
        elseif ($ShouldNotExist) {
            Write-PSFMessage -Level Debug -Message "The should NOT exists: $item" -Target $item
        }
        elseif ((-not $temp) -and ($WarningPreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$item</c> path wasn't found. Please ensure the path <c='em'>exists</c> and you have enough <c='em'>permission</c> to access the path."
        }
        
        $null = $arrList.Add($temp)
    }

    if ($arrList.Contains($false) -and (-not $ShouldNotExist)) {
        # The $ErrorActionPreference variable determines the behavior we are after, but the "Stop-PSFFunction -WarningAction" is where we need to put in the value.
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1 -WarningAction $ErrorActionPreference
        
    }
    elseif ($arrList.Contains($true) -and $ShouldNotExist) {
        # The $ErrorActionPreference variable determines the behavior we are after, but the "Stop-PSFFunction -WarningAction" is where we need to put in the value.
        Stop-PSFFunction -Message "Stopping because file exists." -StepsUpward 1 -WarningAction $ErrorActionPreference
    }
    else {
        $res = $true
    }

    $res
}