
<#
    .SYNOPSIS
        Get installed languages from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed languages from the running the Dynamics 365 Finance & Operations instance
        
    .PARAMETER BinDir
        Path to the directory containing the BinDir and its assemblies
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER Name
        Name of the language that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "fr*"
        
        Default value is "*" which will search for all languages
        
    .EXAMPLE
        PS C:\> Get-D365Language
        
        Shows the entire list of installed languages that are available from the running instance
        
    .EXAMPLE
        PS C:\> Get-D365Language -Name "fr*"
        
        Shows the list of installed languages where the name fits the search "fr*"
        
        A result set example:
        fr      French
        fr-BE   French (Belgium)
        fr-CA   French (Canada)
        fr-CH   French (Switzerland)
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Language, Labels, Label
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Pedro Tornich" (twitter: @ptornich)
        
        All credits goes to him for showing how to extract these information
        
        His github repository can be found here:
        https://github.com/ptornich/LabelFileGenerator
        
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