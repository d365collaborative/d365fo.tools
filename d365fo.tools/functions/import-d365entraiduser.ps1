function Import-D365EntraIdUser {
    [CmdletBinding(DefaultParameterSetName = "UserListImport")]
    param (
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "UserListImport")]
        [string[]] $Users,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "GroupNameImport")]
        [String] $EntraIDGroupName,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "GroupIdImport")]
        [string] $EntraIDGroupId,

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
        [string] $CertificateName,

        [Parameter(Mandatory = $false, Position = 12, ParameterSetName = "UserListImport")]
        [switch] $SkipEntraID,

        [Parameter(Mandatory = $false, Position = 13, ParameterSetName = "GroupNameImport")]
        [switch] $ForceExactGroupName

      )
    
      begin {
        # TODO refactor into internal function
        $microsoftGraphModules = @("Microsoft.Graph.Authentication", "Microsoft.Graph.Users", "Microsoft.Graph.Groups")
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

        if ($SkipEntraID -eq $false) {
            Connect-MicrosoftGraph -TenantId $TenantId -ClientId $ClientId -CertificateName $CertificateName
        }
        if (Test-PSFFunctionInterrupt) { return }
      }

      process {
        switch ($PSCmdlet.ParameterSetName) {
          "UserListImport" {
            Import-UserList -Users $Users -Verbose
          }
          "GroupNameImport" {
              Import-GroupMembers -GroupName $EntraIDGroupName -Verbose
          }
          "GroupIdImport" {
              Import-GroupMembers -GroupId $EntraIDGroupId -Verbose
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

    $UsersToImport = New-Object -TypeName "System.Collections.ArrayList"

    foreach ($user in $Users) {

        if ($SkipEntraID -eq $true) {
            $name = Get-LoginFromEmail $user
            $null = $UsersToImport.Add([PSCustomObject]@{
                    Mail        = $user
                    GivenName   = $name
                    DisplayName = $name
                    Id          = ''
                })
        }
        else {
            $entraIdUser = Get-MgUser -Filter "startswith(DisplayName, '$user') or startswith(UserPrincipalName, '$user')" # equivalent to `Get-AzureAdUser -SearchString $user`, see https://learn.microsoft.com/en-us/powershell/module/azuread/get-azureaduser?view=azureadps-2.0#example-3-search-among-retrieved-users
            if ($null -eq $entraIdUser) {
                Write-PSFMessage -Level Critical "Could not find user $_ in Entra ID."
            }
            else {
                $null = $UsersToImport.Add($entraIdUser)
            }
        }
    }

    Import-UsersToDatabase -Users $UsersToImport
}

function Import-GroupMembers {
    [CmdletBinding(DefaultParameterSetName = "GroupByName")]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "GroupByName")]
        [string] $GroupName,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "GroupById")]
        [string] $GroupId,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "GroupByName")]
        [switch] $ForceExactGroupName
    )

    switch ($PSCmdlet.ParameterSetName) {
        "GroupByName" {
            if ($ForceExactGroupName -eq $true) {
                Write-PSFMessage -Level Verbose -Message "Search Entra ID gorup by its exact name : $GroupName"
                $group = Get-MgGroup -Filter "DisplayName eq '$GroupName'"
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Search Entra ID group by searching within its name : $GroupName"
                $group = Get-MgGroup -ConsistencyLevel eventual -Search "DisplayName:$GroupName" # equivalent to `Get-AzureADGroup -SearchString $GroupName`, see https://learn.microsoft.com/en-us/powershell/module/azuread/get-azureadgroup?view=azureadps-2.0#example-2-get-groups-that-contain-a-search-string
            }
        }
        "GroupById" {
            Write-PSFMessage -Level Verbose -Message "Search Entra ID group by its id : $GroupId"
            $group = Get-MgGroup -GroupId $GroupId
        }
    }

    if ($null -eq $group) {
        Write-PSFMessage -Level Host -Message "Unable to find the specified group in the AAD. Please ensure the group exists and that you have enough permissions to access it."
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping because of errors"
        return
    }

    if ($group.Length -gt 1) {
        Write-PSFMessage -Level Host -Message "More than one group found"
        foreach ($foundGroup in $group) {
            Write-PSFMessage -Level Host -Message "Group found $($foundGroup.DisplayName)"
        }
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping because of errors"
        return
    }

    Write-PSFMessage -Level Host -Message "Processing Entra ID user group `"$($group.DisplayName)`""
    $groupMembers = Get-MgGroupMember -GroupId $group.Id
    $UsersToImport = New-Object -TypeName "System.Collections.ArrayList"
    foreach ($groupMember in $groupMembers) {
        $type = $null
        $null = $groupMember.AdditionalProperties.TryGetValue("@odata.type", [ref]$type)
        if ($type -eq "#microsoft.graph.user") {
          $groupMemberUser = Get-MgUser -UserId $groupMember.Id
          $null = $UsersToImport.Add($groupMemberUser)
        }
    }
    Write-PSFMessage -Level Host -Message "Importing $($UsersToImport.Count) users from group `"$($group.DisplayName)`""
    Import-UsersToDatabase -Users $UsersToImport
}

function Import-UsersToDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [object[]] $Users
    )

    try {
        $sqlCommand.Connection.Open()

        foreach ($user in $Users) {

            $identityProvider = $canonicalProvider

            Write-PSFMessage -Level Verbose -Message "Getting tenant from $($user.Mail)."
            $tenant = Get-TenantFromEmail $user.Mail

            Write-PSFMessage -Level Verbose -Message "Getting domain from $($user.Mail)."
            $networkDomain = Get-NetworkDomain $user.Mail

            Write-PSFMessage -Level Verbose -Message "InstanceProvider : $InstanceProvider"
            Write-PSFMessage -Level Verbose -Message "Tenant : $Tenant"

            if ($user.Mail.ToLower().Contains("outlook.com") -eq $true) {
                $identityProvider = "live.com"
            }
            else {
                if ($instanceProvider.ToLower().Contains($tenant.ToLower()) -ne $True) {
                    Write-PSFMessage -Level Verbose -Message "Getting identity provider from  $($user.Mail)."
                    $identityProvider = Get-IdentityProvider $user.Mail
                }
            }

            Write-PSFMessage -Level Verbose -Message "Getting sid from  $($user.Mail) and identity provider : $identityProvider."
            $sid = Get-UserSIDFromAad $user.Mail $identityProvider
            Write-PSFMessage -Level Verbose -Message "Generated SID : $sid"
            $id = ""
            if ($IdValue -eq 'Login') {
                $id = $IdPrefix + $(Get-LoginFromEmail $user.Mail)
            }
            elseif($IdValue -eq 'UserPrincipalName') {
                $id = $IdPrefix + $user.UserPrincipalName
            }
            else {
                $id = $IdPrefix + $user.GivenName
            }
            if ($id.Length -gt 20) {
                $oldId = $id
                $id = $id -replace '^(.{0,20}).*','$1'
                Write-PSFMessage -Level Host -Message "The id <c='em'>'$oldId'</c> does not fit the <c='em'>20 character limit</c> on UserInfo table's ID field and will be truncated to <c='em'>'$id'</c>"
            }
            Write-PSFMessage -Level Verbose -Message "Id for user $($user.Mail) : $id"

            $name = ""
            if ($NameValue -eq 'DisplayName') {
                $name = $user.DisplayName + $NameSuffix
            }
            else {
                $name = $user.GivenName + $NameSuffix
            }
            Write-PSFMessage -Level Verbose -Message "Name for user $($user.Mail) : $name"

            Write-PSFMessage -Level Verbose -Message "Importing $($user.Mail) - SID $sid - Provider $identityProvider"

            Import-AadUserIntoD365FO $SqlCommand $user.Mail $name $id $sid $StartupCompany $identityProvider $networkDomain $user.Id

            if (Test-PSFFunctionInterrupt) { return }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
        $sqlCommand.Dispose()
    }

}