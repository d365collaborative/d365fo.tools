
<#
    .SYNOPSIS
        Get label from the label file from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get label from the label file from the running the Dynamics 365 Finance & Operations instance
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER LabelFileId
        Name / Id of the label "file" that you want to work against
        
    .PARAMETER Language
        Name / string representation of the language / culture you want to work against
        
        Default value is "en-US"
        
    .PARAMETER Name
        Name of the label that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "@PRO59*"
        
        Default value is "*" which will search for all labels
        
    .EXAMPLE
        PS C:\> Get-D365Label -LabelFileId PRO
        
        Shows the entire list of labels that are available from the PRO label file.
        The language is defaulted to "en-US".
        
    .EXAMPLE
        PS C:\> Get-D365Label -LabelFileId PRO -Language da
        
        Shows the entire list of labels that are available from the PRO label file.
        Shows only all "da" (Danish) labels.
        
    .EXAMPLE
        PS C:\> Get-D365Label -LabelFileId PRO -Name "@PRO59*"
        
        Shows the labels available from the PRO label file where the name fits the search "@PRO59*"
        
        A result set example:
        
        Name                 Value                                                                            Language
        ----                 -----                                                                            --------
        @PRO59               Indicates if the type of the rebate value.                                       en-US
        @PRO594              Pack consumption                                                                 en-US
        @PRO595              Pack qty now being released to production in the BOM unit.                       en-US
        @PRO596              Pack unit.                                                                       en-US
        @PRO597              Pack proposal for release in the packing unit.                                   en-US
        @PRO590              Constant pack qty                                                                en-US
        @PRO593              Pack proposal release in BOM unit.                                               en-US
        @PRO598              Pack quantity now being released for the production in the packing unit.         en-US
        
    .EXAMPLE
        PS C:\> Get-D365Label -LabelFileId PRO -Name "@PRO59*" -Language da,en-us
        
        Shows the labels available from the PRO label file where the name fits the search "@PRO59*".
        Shows for both "da" (Danish) and en-US (English)
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Language, Labels, Label
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Pedro Tornich" (twitter: @ptornich)
        
        All credits goes to him for showing how to extract these information
        
        His github repository can be found here:
        https://github.com/ptornich/LabelFileGenerator
        
#>
function Get-D365Label {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $BinDir = "$Script:BinDir\bin",

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 2 )]
        [string] $LabelFileId,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 3 )]
        [string[]] $Language = "en-US",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $Name = "*"
    )

    begin {
    }

    process {
        $files = @((Join-Path -Path $BinDir -ChildPath "Microsoft.Dynamics.AX.Xpp.AxShared.dll"))
        
        if (-not (Test-PathExists -Path $files -Type Leaf)) {
            return
        }

        Add-Type -Path $files

        foreach ($item in $Language) {
            $culture = New-Object System.Globalization.CultureInfo -ArgumentList $item

            Write-PSFMessage -Level Verbose -Message "Searching for label" -Target $culture
            
            $labels = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetAllLabels($LabelFileId, $culture)
            
            foreach ($itemLabel in $labels) {
                foreach ($key in $itemLabel.Keys) {
                    if ($key -notlike $Name) { continue }

                    [PSCustomObject]@{
                        Name     = $Key
                        Value    = $itemLabel[$key]
                        Language = $item
                        PSTypeName = 'D365FO.TOOLS.Label'
                    }
                }
            }
        }
    }

    end {
    }
}