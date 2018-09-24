Function Get-ServiceList {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]                    
        [switch] $All = [switch]::Present,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]                    
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]                    
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 4 )]                    
        [switch] $FinancialReporter,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 5 )]                    
        [switch] $DMF
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = ![switch]::Present
    }

    Write-PSFMessage -Level Verbose -Message "The PSBoundParameters was" -Target $PSBoundParameters

    $aosname = "w3svc"
    $batchname = "DynamicsAxBatch"
    $financialname = "MR2012ProcessService"
    $dmfname = "Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe"

    [System.Collections.ArrayList]$Services = New-Object -TypeName "System.Collections.ArrayList"

    if ($All.IsPresent) {
        $null = $Services.AddRange(@($aosname, $batchname, $financialname, $dmfname))
    }    
    else {
        if ($Aos.IsPresent) {
            $null = $Services.Add($aosname)
        }
        if ($Batch.IsPresent) {
            $null = $Services.Add($batchname)
        }
        if ($FinancialReporter.IsPresent) {
            $null = $Services.Add($financialname)
        }
        if ($DMF.IsPresent) {
            $null = $Services.Add($dmfname)
        }
    }

    $Services.ToArray()
}