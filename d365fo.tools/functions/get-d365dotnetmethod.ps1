
<#
    .SYNOPSIS
        Get a .NET method from the Dynamics 365 for Finance and Operations installation
        
    .DESCRIPTION
        Get a .NET method from an assembly file (dll) from the package directory
        
    .PARAMETER Assembly
        Name of the assembly file that you want to search for the .NET method
        
        Provide the full path for the assembly file you want to work against
        
    .PARAMETER Name
        Name of the .NET method that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "parmER*Excel*"
        
        Default value is "*" which will search for all methods
        
    .PARAMETER TypeName
        Name of the .NET class that you want to work against
        
        Accepts wildcards for searching. E.g. -Name "*ER*Excel*"
        
        Default value is "*" which will work against all classes
        
    .EXAMPLE
        PS C:\> Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll"
        
        Will get all methods, across all classes, from the assembly file
        
    .EXAMPLE
        PS C:\> Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll" -TypeName "ERTextFormatExcelFileComponent"
        
        Will get all methods, from the "ERTextFormatExcelFileComponent" class, from the assembly file
        
    .EXAMPLE
        PS C:\> Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll" -TypeName "ERTextFormatExcelFileComponent" -Name "*parm*"
        
        Will get all methods that fits the search "*parm*", from the "ERTextFormatExcelFileComponent" class, from the assembly file
        
    .EXAMPLE
        PS C:\> Get-D365DotNetClass -Name "ERTextFormatExcelFileComponent" -Assembly "*LocalizationFrameworkForAx.dll*" | Get-D365DotNetMethod
        
        Will get all methods, from the "ERTextFormatExcelFileComponent" class, from any assembly file that fits the search "*LocalizationFrameworkForAx.dll*"
        
    .NOTES
        Tags: .Net, DotNet, Class, Method, Methods, Development
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365DotNetMethod {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [Alias('File')]
        [string] $Assembly,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Alias('MethodName')]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Alias('ClassName')]
        [string] $TypeName = "*"

    )
    
    begin {
    }
    
    process {
        Invoke-TimeSignal -Start

        try {
            Write-PSFMessage -Level Verbose -Message "Loading the file" -Target $Assembly
            [Reflection.Assembly]$ass = [Reflection.Assembly]::LoadFile($Assembly)

            $types = $ass.GetTypes()

            foreach ($obj in $types) {
                Write-PSFMessage -Level Verbose -Message "Type name loaded" -Target $obj.Name

                if ($obj.Name -NotLike $TypeName) {continue}

                $members = $obj.GetMethods()

                foreach ($objI in $members) {
                    if ($objI.Name -NotLike $Name) { continue }
                    [PSCustomObject]@{
                        TypeName     = $obj.Name
                        TypeIsPublic = $obj.IsPublic
                        MethodName   = $objI.Name
                    }

                }
            }
        }
        catch {
            Write-PSFMessage -Level Warning -Message "Something went wrong while working on: $Assembly" -ErrorRecord $_
        }
        
        Invoke-TimeSignal -End
    }

    end {
    }

}