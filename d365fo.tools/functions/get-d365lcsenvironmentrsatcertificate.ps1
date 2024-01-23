
<#
    .SYNOPSIS
        Get LCS environment rsat certificate from within a project
        
    .DESCRIPTION
        Download and persist the active rsat certificate from environments from within a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER EnvironmentId
        Id of the environment that you want to be working against
        
    .PARAMETER OutputPath
        Path to where you want the certificate files to be saved
        
        The default value is: "c:\temp\d365fo.tools\RsatCert\"
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER FailOnErrorMessage
        Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint
        
        Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
        This allows you to implement custom retry / error handling logic
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentRsatCertificate -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will download the active rsat certificate file for the environment from the LCS project.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        A result set example:
        
        Path     : c:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030
        CerFile  : C:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030\RSATCertificate_ABC-UAT_20240101-012030.cer
        PfxFile  : C:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030\RSATCertificate_ABC-UAT_20240101-012030.pfx
        FileName : RSATCertificate_ABC-UAT_20240101-012030.zip
        Password : 9zbPiLMTk676mkq5FvqQ
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentRsatCertificate -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" | Import-D365RsatSelfServiceCertificates
        
        This will download the active rsat certificate file for the environment from the LCS project.
        The resulting files are then imported into the certificate store on the local machine.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365LcsEnvironmentRsatCertificate {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType('PSCustomObject')]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
        
        [string] $OutputPath = $(Join-Path $Script:DefaultTempPath "RsatCert"),

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    process {
        Invoke-TimeSignal -Start

        if (-not (Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        $parms = @{}
        $parms.ProjectId = $ProjectId
        $parms.BearerToken = $BearerToken
        $parms.LcsApiUri = $LcsApiUri
        $parms.RetryTimeout = $RetryTimeout
        $parms.EnableException = $EnableException
        $parms.EnvironmentId = $EnvironmentId

        $resCertDetails = Get-LcsEnvironmentRsatCertificate @parms
           
        if (Test-PSFFunctionInterrupt) { return }

        if ($FailOnErrorMessage -and $deploymentStatus.ErrorMessage) {
            $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($deploymentStatus.ErrorMessage)</c>."
            $errorMessagePayload = "`r`n$($deploymentStatus | ConvertTo-Json)"
            Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
        }

        $outFile = Join-Path -Path $OutputPath -ChildPath $resCertDetails.Data.Filename
        Set-Content -Path $outFile -Value $([System.Convert]::FromBase64String($resCertDetails.Data.CertificateZipEncoded)) -Encoding Byte
        
        $outExtract = Join-Path -Path $OutputPath -ChildPath $([System.IO.Path]::GetFileNameWithoutExtension($outFile))
        Expand-Archive -Path $outFile -DestinationPath $outExtract -Force

        Invoke-TimeSignal -End

        [PSCustomObject][ordered]@{
            Path     = $outExtract
            CerFile  = Get-Item -Path "$outExtract\*.cer" | Select-Object -First 1 -ExpandProperty FullName
            PfxFile  = Get-Item -Path "$outExtract\*.pfx" | Select-Object -First 1 -ExpandProperty FullName
            FileName = $resCertDetails.Data.Filename
            Password = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($resCertDetails.Data.CertificateSecretEncoded))
        }
    }
}