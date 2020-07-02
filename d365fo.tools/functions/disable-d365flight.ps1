
<#
    .SYNOPSIS
        Used to disable a flight
        
    .DESCRIPTION
        Provides a method for disabling a flight in D365FO.
        
    .PARAMETER FlightName
        Name of the flight to disable
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .EXAMPLE
        PS C:\> Disable-D365Flight -FlightName DMFEnableAllCompanyExport
        
        Disables the flight DMFEnableAllCompanyExport
        
    .LINK
        https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features
        
    .NOTES
        Tags: Flight, Flighting
        
        Author: Frank Hüther (@FrankHuether)
        
        The DataAccess.FlightingServiceCatalogID must already be set in the web.config file.
        
        At no circumstances can this cmdlet be used to enable a flight in a PROD environment.
#>
function Disable-D365Flight {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [String] $FlightName,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $SqlPwd = $Script:DatabaseUserPassword
    )

    try {
        $WebConfigFile = join-Path -path $Script:AOSPath $Script:WebConfig
        Write-PSFMessage -Level Verbose -Message "Retrieve the FlightingServiceCatalogID" -Target $WebConfigFile

        $FlightServiceNode = Select-Xml -XPath "/configuration/appSettings/add[@key='DataAccess.FlightingServiceCatalogID']/@value" -Path $WebConfigFile
        $FlightServiceId = $FlightServiceNode.Node.Value
    
        Write-PSFMessage -Level Verbose -Message "FlightingServiceCatalogID: $FlightServiceId" -Target $WebConfigFile
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while reading from the web.config file" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    if ($null -eq $FlightServiceId) {
        Write-PSFMessage -Level Host -Message "The DataAccess.FlightingServiceCatalogID setting must be set in the web.config file. See https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features for details"
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection
    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\disable-flight.sql") -join [Environment]::NewLine

    try {
        $sqlCommand.Connection.Open()

        Write-PSFMessage -Level Verbose -Message "Disabling flight: $FlightName"

        $null = $sqlCommand.Parameters.Add("@FlightName", $FlightName)
        $null = $sqlCommand.Parameters.Add("@FlightServiceId", $FlightServiceId)

        Write-PSFMessage -Level Verbose -Message "Disable the flight in database"

        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $null = $sqlCommand.ExecuteNonQuery()
    
        Write-PSFMessage -Level Verbose -Message "Flight $FlightName disabled with service ID $FlightServiceId"
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
        $sqlCommand.Dispose()
    }
}