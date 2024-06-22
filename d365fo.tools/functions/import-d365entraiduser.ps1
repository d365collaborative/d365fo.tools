function Import-D365EntraIdUser {
    [CmdletBinding(DefaultParameterSetName = "UserListImport")]
    param (
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "UserListImport")]
        [string[]] $Users,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $StartupCompany = 'DAT',

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 6)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, Position = 7)]
        [string] $TenantId,

        [Parameter(Mandatory = $false, Position = 8)]
        [string] $ClientId,

        [Parameter(Mandatory = $false, Position = 9)]
        [string] $CertificateName

      )
    
      begin {
        # TODO refactor into internal function
        $microsoftGraphModules = @("Microsoft.Graph.Authentication", "Microsoft.Graph.Users")
        $microsoftGraphModules | ForEach-Object {
          if (-not (Get-Module -Name $_ -ListAvailable)) {
            Write-PSFMessage -Level Host -Message "Module $_ is not installed. Installing it now."
            Install-Module -Name $_ -Force -AllowClobber -Scope CurrentUser -Repository PSGallery
          }
        }

        # TODO refactor into internal function
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }
        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        $instanceProvider = Get-InstanceIdentityProvider
        $canonicalProvider = Get-CanonicalIdentityProvider

        Connect-MicrosoftGraph -TenantId $TenantId -ClientId $ClientId -CertificateName $CertificateName
        if (Test-PSFFunctionInterrupt) { return }
      }

      process {
        switch ($PSCmdlet.ParameterSetName) {
          "UserListImport" {
            Import-UserList -Users $Users -Verbose
          }
        }
      }

}

function Connect-MicrosoftGraph {
    [CmdletBinding(DefaultParameterSetName = 'ByCertificateName')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $TenantId,
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'ByCertificateName')]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'ByCertificateThumbprint')]
        [string] $ClientId,
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'ByCertificateName')]
        [string] $CertificateName,
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'ByCertificateThumbprint')]
        [string] $CertificateThumbprint,
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'ByClientSecret')]
        [PSCredential] $ClientSecretCredential
    )

    try {
      Write-PSFMessage -Level Host -Message "Connecting to Microsoft Graph"
      $byClientSecret = $PSBoundParameters.ContainsKey('ClientSecretCredential')
      $byCertificateName = $PSBoundParameters.ContainsKey('CertificateName') -and $PSBoundParameters.ContainsKey('ClientId')
      $byCertificateThumbprint = $PSBoundParameters.ContainsKey('CertificateThumbprint') -and $PSBoundParameters.ContainsKey('ClientId')
      if ($byClientSecret -or $byCertificateName -or $byCertificateThumbprint) {
        switch ($PSCmdlet.ParameterSetName) {
            'ByCertificateName' {
                Connect-MicrosoftGraphCertificate -TenantId $TenantId -ClientId $ClientId -CertificateName $CertificateName
            }
            'ByCertificateThumbprint' {
                Connect-MicrosoftGraphCertificate -TenantId $TenantId -ClientId $ClientId -CertificateThumbprint $CertificateThumbprint
            }
            'ByClientSecret' {
                Connect-MicrosoftGraphClientSecret -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
            }
        }
      }
      else {
        Connect-MgGraph -NoWelcome -ErrorAction Stop
      }
    }
    catch {
      Write-PSFMessage -Level Host -Message "Something went wrong while connecting to Microsoft Graph" -Exception $PSItem.Exception
      Stop-PSFFunction -StepsUpward 1 -Message "Stopping because of errors"
      return
    }

}

function Connect-MicrosoftGraphCertificate {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $TenantId,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $ClientId,
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'ByName')]
        [string] $CertificateName,
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'ByThumbprint')]
        [string] $CertificateThumbprint
    )

    $params = @{
        TenantId = $TenantId
        ClientId = $ClientId
        NoWelcome = $true
    }

    switch ($PSCmdlet.ParameterSetName) {
        'ByName' {
            $params.CertificateSubjectName = "CN=$CertificateName"
        }
        'ByThumbprint' {
            $params.CertificateThumbprint = $CertificateThumbprint
        }
    }
    Connect-MgGraph @params
}

function Connect-MicrosoftGraphClientSecret {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $TenantId,
        [Parameter(Mandatory = $true, Position = 1)]
        [PSCredential] $ClientSecretCredential
    )

    $params = @{
        TenantId = $TenantId
        NoWelcome = $true
        ClientSecretCredential = $ClientSecretCredential
    }

    Connect-MgGraph @params
}

function Import-UserList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]] $Users
    )

    $sqlCommand.Connection.Open()

    $users | ForEach-Object {
        $entraIdUser = Get-MgUser -Filter "mail eq '$_'"
        if ($null -eq $entraIdUser) {
            Write-PSFMessage -Level Critical "Could not find user $_ in Entra ID."
        }
        $identityProvider = $canonicalProvider
        Write-PSFMessage -Level Verbose -Message "Getting tenant from $($entraIdUser.Mail)."
        $tenant = Get-TenantFromEmail $entraIdUser.Mail

        Write-PSFMessage -Level Verbose -Message "Getting domain from $($entraIdUser.Mail)."
        $networkDomain = Get-NetworkDomain $entraIdUser.Mail

        Write-PSFMessage -Level Verbose -Message "InstanceProvider : $InstanceProvider"
        Write-PSFMessage -Level Verbose -Message "Tenant : $Tenant"

        if ($entraIdUser.Mail.ToLower().Contains("outlook.com") -eq $true) {
            $identityProvider = "live.com"
        }
        else {
            if ($instanceProvider.ToLower().Contains($tenant.ToLower()) -ne $True) {
                Write-PSFMessage -Level Verbose -Message "Getting identity provider from  $($entraIdUser.Mail)."
                $identityProvider = Get-IdentityProvider $entraIdUser.Mail
            }
        }

        Write-PSFMessage -Level Verbose -Message "Getting sid from  $($entraIdUser.Mail) and identity provider : $identityProvider."
        $sid = Get-UserSIDFromAad $entraIdUser.Mail $identityProvider
        Write-PSFMessage -Level Verbose -Message "Generated SID : $sid"
        $id = ""
        if ($IdValue -eq 'Login') {
            $id = $IdPrefix + $(Get-LoginFromEmail $entraIdUser.Mail)
        }
        elseif($IdValue -eq 'UserPrincipalName') {
            $id = $IdPrefix + $entraIdUser.UserPrincipalName
        }
        else {
            $id = $IdPrefix + $entraIdUser.GivenName
        }
        
        if ($id.Length -gt 20) {
            $oldId = $id
            $id = $id -replace '^(.{0,20}).*','$1'
            Write-PSFMessage -Level Host -Message "The id <c='em'>'$oldId'</c> does not fit the <c='em'>20 character limit</c> on UserInfo table's ID field and will be truncated to <c='em'>'$id'</c>"
        }
        
        Write-PSFMessage -Level Verbose -Message "Id for user $($entraIdUser.Mail) : $id"

        $name = ""
        if ($NameValue -eq 'DisplayName') {
            $name = $entraIdUser.DisplayName + $NameSuffix
        }

        else {
            $name = $entraIdUser.GivenName + $NameSuffix
        }
        Write-PSFMessage -Level Verbose -Message "Name for user $($entraIdUser.Mail) : $name"
        Write-PSFMessage -Level Verbose -Message "Importing $($entraIdUser.Mail) - SID $sid - Provider $identityProvider"

        Import-AadUserIntoD365FO $SqlCommand $entraIdUser.Mail $name $id $sid $StartupCompany $identityProvider $networkDomain $entraIdUser.ObjectId

        if (Test-PSFFunctionInterrupt) { return }
    }
}