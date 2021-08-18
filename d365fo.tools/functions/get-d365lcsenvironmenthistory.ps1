function Get-D365LcsEnvironmenHistory {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType('PSCustomObject')]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
      
        [Parameter(ParameterSetName = 'Pagination')]
        [switch] $TraverseAllPages,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    process {
        Invoke-TimeSignal -Start

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        $parms = @{}
        $parms.ProjectId = $ProjectId
        $parms.BearerToken = $BearerToken
        $parms.EnvironmentId = $EnvironmentId
        $parms.LcsApiUri = $LcsApiUri
        $parms.RetryTimeout = $RetryTimeout
        $parms.EnableException = $EnableException

        [System.Collections.Generic.List[System.Object]] $resArray = @()
        $page = 1

        do {
            $history = Get-LcsEnvironmentHistory @parms

            $resArray.AddRange($history.Data)

            if ($history.ResultHasMorePages -eq $true) {
                $page += 1
                $parms.Page = $page
            }

            if (Test-PSFFunctionInterrupt) { return }

            if ($FailOnErrorMessage -and $deploymentStatus.ErrorMessage) {
                $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($deploymentStatus.ErrorMessage)</c>."
                $errorMessagePayload = "`r`n$($deploymentStatus | ConvertTo-Json)"
                Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
                Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
            }
        }
        while (($history.ResultHasMorePages -eq $true) -and $TraverseAllPages)
    
        $res = $null

        if ($resArray.Count -gt 0) {
            $res = $resArray.ToArray()
        }
        
        Invoke-TimeSignal -End

        $res | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Environment.History"
    }
}