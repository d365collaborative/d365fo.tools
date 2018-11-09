
<#
    .SYNOPSIS
        Get a .NET class from the Dynamics 365 for Finance and Operations installation
        
    .DESCRIPTION
        Get a .NET class from an assembly file (dll) from the package directory
        
    .PARAMETER Name
        Name of the .NET class that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "ER*Excel*"
        
        Default value is "*" which will search for all classes
        
    .PARAMETER Assembly
        Name of the assembly file that you want to search for the .NET class
        
        Accepts wildcards for searching. E.g. -Name "*AX*Framework*.dll"
        
        Default value is "*.dll" which will search for assembly files
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed packages
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365DotNetClass -Name "ERText*"
        
        Will search across all assembly files (*.dll) that are located in the default package directory after
        any class that fits the search "ERText*"
        
    .EXAMPLE
        PS C:\> Get-D365DotNetClass -Name "ERText*" -Assembly "*LocalizationFrameworkForAx.dll*"
        
        Will search across all assembly files (*.dll) that are fits the search "*LocalizationFrameworkForAx.dll*",
        that are located in the default package directory, after any class that fits the search "ERText*"
        
    .EXAMPLE
        PS C:\> Get-D365DotNetClass -Name "ERText*" | Export-Csv -Path c:\temp\results.txt -Delimiter ";"
        
        Will search across all assembly files (*.dll) that are located in the default package directory after
        any class that fits the search "ERText*"
        
        The output is saved to a file to make it easier to search inside the result set
        
    .NOTES
        Tags: .Net, DotNet, Class, Development
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365DotNetClass {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $Assembly = "*.dll",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $PackageDirectory = $Script:PackageDirectory
    )
    
    begin {
    }
    
    process {
        Invoke-TimeSignal -Start

        $files = (Get-ChildItem -Path $PackageDirectory -Filter $Assembly -Recurse -Exclude "*Resources*" | Where-Object Fullname -Notlike "*Resources*" )

        $files | ForEach-Object {
            $path = $_.Fullname
            try {
                Write-PSFMessage -Level Verbose -Message "Loading the dll file: $path" -Target $path
                
                [Reflection.Assembly]$ass = [Reflection.Assembly]::LoadFile($path)

                $res = $ass.GetTypes()

                Write-PSFMessage -Level Verbose -Message "Looping through all types from the assembly"
                foreach ($obj in $res) {
                    if ($obj.Name -NotLike $Name) { continue }
                    [PSCustomObject]@{
                        IsPublic = $obj.IsPublic
                        IsSerial = $obj.IsSerial
                        Name     = $obj.Name
                        BaseType = $obj.BaseType
                        File     = $path
                    }
                }
            }
            catch {
                Write-PSFMessage -Level Host -Message "Something went wrong while trying to load the path: $path" -Exception $PSItem.Exception
                Stop-PSFFunction -Message "Stopping because of errors"
                return
            }
        }

        Invoke-TimeSignal -End
    }

    end {
    }

}