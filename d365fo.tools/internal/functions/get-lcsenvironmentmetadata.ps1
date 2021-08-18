function Get-LcsEnvironmentMetadata {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    # [CmdletBinding()]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(ParameterSetName = 'SearchByEnvironmentId')]
        [string] $EnvironmentId,

        [Parameter(ParameterSetName = 'SearchByEnvironmentName')]
        [string] $EnvironmentName,

        [Parameter(ParameterSetName = 'Pagination')]
        [int] $Page,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "GET"
        $parms.Uri = "$LcsApiUri/environmentinfo/v1/detail/project/$($ProjectId)"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout

        if ($PSCmdlet.ParameterSetName -eq "Pagination") {
            $parms.Uri += "/?page=$Page"
        }
        elseif ($PSCmdlet.ParameterSetName -eq "SearchByEnvironmentId") {
            $parms.Uri += "/?environmentId=$EnvironmentId"
        }
        elseif ($PSCmdlet.ParameterSetName -eq "SearchByEnvironmentName") {
            $parms.Uri += "/?environmentName=$EnvironmentName"
        }
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for getting the environment metadata a project in LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }

        Invoke-TimeSignal -End
    }
}