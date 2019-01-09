
<#
    .SYNOPSIS
        Get installed languages from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed languages from the running the Dynamics 365 Finance & Operations instance
        
    .PARAMETER Name
        Name of the language that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "fr*"
        
        Default value is "*" which will search for all languages
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed packages / modules for the instance
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Language
        
        Shows the entire list of installed languages that are available from the running instance
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name "fr*"
        
        Shows the list of installed languages where the name fits the search "fr*"
        
        A result set example:
        fr      French
        fr-BE   French (Belgium)
        fr-CA   French (Canada)
        fr-CH   French (Switzerland)
            
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Model, Models, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365Language {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $BinDir = "$Script:BinDir\bin",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $Name = "*"
    )

    begin {
    }

    process {
        $files = @((Join-Path -Path $BinDir -ChildPath "Microsoft.Dynamics.AX.Xpp.AxShared.dll"))
        
        if(-not (Test-PathExists -Path $files -Type Leaf)) {
            return
        }

        Add-Type -Path $files

        $languages = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetInstalledLanguages()

        foreach ($obj in $languages) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj -NotLike $Name) {continue}

            $lang = New-Object System.Globalization.CultureInfo -ArgumentList $obj
            [PSCustomObject]@{
                Name        = $obj
                LanguageName  = $lang.DisplayName
            }
        }
    }

    end {
    }
}