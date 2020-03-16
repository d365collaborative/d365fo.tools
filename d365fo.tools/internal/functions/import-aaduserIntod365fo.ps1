
<#
    .SYNOPSIS
        Import an Azure Active Directory (AAD) user
        
    .DESCRIPTION
        Import an Azure Active Directory (AAD) user into a Dynamics 365 for Finance & Operations environment
        
    .PARAMETER SqlCommand
        The SQL Command object that should be used when importing the AAD user
        
    .PARAMETER SignInName
        The sign in name (email address) for the user that you want to import
        
    .PARAMETER Name
        The name that the imported user should have inside the D365FO environment
        
    .PARAMETER Id
        The ID that the imported user should have inside the D365FO environment
        
    .PARAMETER SID
        The SID that correlates to the imported user inside the D365FO environment
        
    .PARAMETER StartUpCompany
        The default company (legal entity) for the imported user
        
    .PARAMETER IdentityProvider
        The provider for the imported to validated against
        
    .PARAMETER NetworkDomain
        The network domain of the imported user
        
    .PARAMETER ObjectId
        The Azure Active Directory object id for the imported user
        
    .PARAMETER Language
        Language that should be configured for the user, for when they sign-in to the D365 environment
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> Import-AadUserIntoD365FO -SqlCommand $SqlCommand -SignInName "Claire@contoso.com" -Name "Claire" -Id "claire" -SID "123XYZ" -StartupCompany "DAT" -IdentityProvider "XYZ" -NetworkDomain "Contoso.com" -ObjectId "123XYZ"
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        The SqlCommand object is passed to the Import-AadUserIntoD365FO along with all the necessary details for importing Claire@contoso.com as an user into the D365FO environment.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Import-AadUserIntoD365FO {
    [CmdletBinding()]
    param
    (
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [string] $SignInName,

        [string] $Name,

        [string] $Id,

        [string] $SID,

        [string] $StartUpCompany,

        [string] $IdentityProvider,

        [string] $NetworkDomain,

        [string] $ObjectId,

        [string] $Language
    )

    Write-PSFMessage -Level Verbose -Message "Testing the Email $signInName" -Target $signInName

    $UserFound = Test-AadUserInD365FO $sqlCommand $SignInName

    if ($UserFound -eq $false) {

        Write-PSFMessage -Level Verbose -Message "Testing the userid $Id" -Target $Id

        $idTaken = Test-AadUserIdInD365FO $sqlCommand $id

        if (Test-PSFFunctionInterrupt) { return }

        if ($idTaken -eq $false) {

            $userAdded = New-D365FOUser $sqlCommand $SignInName $Name $Id $Sid $StartUpCompany $IdentityProvider $NetworkDomain $ObjectId $Language

            if ($userAdded -eq $true) {

                $securityAdded = Add-AadUserSecurity $sqlCommand $Id

                Write-PSFMessage -Level Host -Message "User $SignInName Imported"

                if ($securityAdded -eq $false) {
                    Write-PSFMessage -Level Host -Message "User $SignInName did not get securityRoles"
                    #Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
                    #return
                }
            }
            else {
                Write-PSFMessage -Level Host -Message "User $SignInName, not added to D365FO"
                #Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
                #return
            }
        }
        else {
            Write-PSFMessage -Level Host -Message "An User with ID = '$ID' already exists"
            #Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            #return
        }

    }
    else {
        Write-PSFMessage -Level Host -Message "An User with Email $SignInName already exists in D365FO"
        #Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        #return
    }
}