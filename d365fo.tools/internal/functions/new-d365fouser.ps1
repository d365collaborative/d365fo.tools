
<#
    .SYNOPSIS
        Creates a new user
        
    .DESCRIPTION
        Creates a new user in a Dynamics 365 for Finance & Operations instance
        
    .PARAMETER sqlCommand
        The SQL Command object that should be used when creating the new user
        
    .PARAMETER SignInName
        The sign in name (email address) for the user that you want the SID from
        
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
        PS C:\> New-D365FOUser -SqlCommand $SqlCommand -SignInName "Claire@contoso.com" -Name "Claire" -Id "claire" -SID "123XYZ" -StartupCompany "DAT" -IdentityProvider "XYZ" -NetworkDomain "Contoso.com" -ObjectId "123XYZ"
        
        This will get a SqlCommand object that will connect to the localhost server and the AXDB databae, with the sql credential "User123".
        The SqlCommand object is passed to the Import-AadUserIntoD365FO along with all the necessary details for importing Claire@contoso.com as an user into the D365FO environment.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-D365FOUser {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param (
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
    
    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\Add-AadUserIntoD365FO.sql") -join [Environment]::NewLine

    Write-PSFMessage -Level Verbose -Message "Adding User : $SignInName,$Name,$Id,$SID,$StartUpCompany,$IdentityProvider,$NetworkDomain"

    $null = $sqlCommand.Parameters.Add("@SignInName", $SignInName)
    $null = $sqlCommand.Parameters.Add("@Name", $Name)
    $null = $sqlCommand.Parameters.Add("@SID", $SID)
    $null = $sqlCommand.Parameters.Add("@NetworkDomain", $NetworkDomain)
    $null = $sqlCommand.Parameters.Add("@IdentityProvider", $IdentityProvider)
    $null = $sqlCommand.Parameters.Add("@StartUpCompany", $StartUpCompany)
    $null = $sqlCommand.Parameters.Add("@Id", $Id)
    $null = $sqlCommand.Parameters.Add("@ObjectId", $ObjectId)
    $null = $sqlCommand.Parameters.Add("@Language", $Language)

    Write-PSFMessage -Level Verbose -Message "Creating the user in database"

    Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

    $rowsCreated = $sqlCommand.ExecuteScalar()
    
    Write-PSFMessage -Level Verbose -Message "Rows inserted $rowsCreated for user $SignInName"
    
    $SqlCommand.Parameters.Clear()

    $rowsCreated -eq 1
}