
<#
    .SYNOPSIS
        Export a model from Dynamics 365 for Finance & Operations
        
    .DESCRIPTION
        Export a model from a Dynamics 365 for Finance & Operations environment
        
    .PARAMETER Path
        Path to the folder where you want to save the model file
        
    .PARAMETER Model
        Name of the model that you want to work against
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Export-D365Model -Path c:\temp\d365fo.tools -Model CustomModelName
        
        This will export the "CustomModelName" model from the default PackagesLocalDirectory path.
        It export the model to the "c:\temp\d365fo.tools" location.
        
    .NOTES
        Tags: ModelUtil, Axmodel, Model, Export
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Export-D365Model {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Modelname')]
        [string] $Model,

        [string] $BinDir = "$Script:PackageDirectory\bin",

        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start
    
        if ($Path.EndsWith("\")) {
            $Path = $Path.Substring(0, $Path.Length - 1)
        }
    }

    process {
        Invoke-ModelUtil -Command "Export" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
    }
    
    end {
        Invoke-TimeSignal -End
    }
}