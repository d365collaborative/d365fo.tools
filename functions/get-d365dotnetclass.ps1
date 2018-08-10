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
Get-D365DotNetClass -Name "ERText*"

Will search across all assembly files (*.dll) that are located in the default package directory after
any class that fits the search "ERText*"

.EXAMPLE
Get-D365DotNetClass -Name "ERText*" -Assembly "*LocalizationFrameworkForAx.dll*"

Will search across all assembly files (*.dll) that are fits the search "*LocalizationFrameworkForAx.dll*",
that are located in the default package directory, after any class that fits the search "ERText*"

.EXAMPLE
Get-D365DotNetClass -Name "ERText*" | Export-Csv -Path c:\temp\results.txt -Delimiter ";"

Will search across all assembly files (*.dll) that are located in the default package directory after
any class that fits the search "ERText*"

The output is saved to a file to make it easier to search inside the result set

.NOTES
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
        $StartTime = Get-Date

        $files = (Get-ChildItem -Path $PackageDirectory -Filter $Assembly -Recurse -Exclude "*Resources*" | Where-Object Fullname -Notlike "*Resources*" )

        $files | ForEach-Object {
            $path = $_.Fullname
            try {
                Write-Verbose "Loading the file"
                [Reflection.Assembly]$ass = [Reflection.Assembly]::LoadFile($path)

                Write-Host "`r`n$path`r`n"

                Write-Verbose "Getting all the types"
                $res = $ass.GetTypes()

                Write-Verbose "Looping all the types"
                foreach ($obj in $res) {
                    Write-Verbose "$($obj.Name)"
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
                # write-Error $_.Exception.Message
                # Write-Error $_.Exception

                Write-Verbose "Failed to load: $path"
            } 
        }

        $EndTime = Get-Date
        $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

        if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
            Write-Host "Time Taken inside: Get-D365DotNetClass" -ForegroundColor Green
            Write-Host "$TimeSpan" -ForegroundColor Green
        }
    }

    end {
    }

}