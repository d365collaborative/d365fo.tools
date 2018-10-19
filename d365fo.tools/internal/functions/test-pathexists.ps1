
<#
    .SYNOPSIS
        The multiple paths
        
    .DESCRIPTION
        Easy way to test multiple paths for public functions and have the same error handling
        
    .PARAMETER Path
        Array of paths you want to test
        
        They have to be the same type, either file/leaf or folder/container
        
    .PARAMETER Type
        Type of path you want to test
        
        Either 'Leaf' or 'Container'
        
    .PARAMETER Create
        Switch to instruct the cmdlet to create the directory if it doesn't exist
        
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
        [Parameter(Mandatory = $True, Position = 1 )]
        [string[]] $Path,

        [ValidateSet('Leaf', 'Container')]
        [Parameter(Mandatory = $True, Position = 2 )]
        [string] $Type,

        [switch] $Create
    )
    
    $res = $false

    $arrList = New-Object -TypeName "System.Collections.ArrayList"
         
    foreach ($item in $Path) {
        Write-PSFMessage -Level Verbose -Message "Testing the path: $item" -Target $item
        $temp = Test-Path -Path $item -Type $Type

        if ((!$temp) -and ($Create) -and ($Type -eq "Container")) {
            Write-PSFMessage -Level Verbose -Message "Creating the path: $item" -Target $item
            $null = New-Item -Path $item -ItemType Directory -Force -ErrorAction Stop
            $temp = $true
        }
        elseif (!$temp) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$item</c> path wasn't found. Please ensure the path <c='em'>exists</c> and you have enough <c='em'>permission</c> to access the path."
        }
        
        $null = $arrList.Add($temp)
    }

    if ($arrList.Contains($false)) {
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
    }
    else {
        $res = $true
    }

    $res
}