
<#
    .SYNOPSIS
        Used to get a flight
        
    .DESCRIPTION
        Provides a method for listing a flight in D365FO.
        
    .PARAMETER FlightName
        Name of the flight that you are looking for
        
        Supports wildcards "*"
        
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
        PS C:\> Get-D365Flight
        
        This will list all flights that are configured on the environment.
        It will show the name and the enabled status.
        
        A result set example:
        
        FlightName                         Enabled FlightServiceId
        ----------                         ------- ---------------
        WHSWorkCancelForcedFlight          1       12719367
        TAMRebateGlobalEnableFeature       1       12719367
        EnablePerfInfoSimpleLoggerV2       1       12719367
        EnablePerfInfoLogODataV2           1       12719367
        EnablePerfInfoLogEtwRequestTableV2 1       12719367
        EnablePerfInfoCursorLayerV2        1       12719367
        EnablePerfInfoFormEngineLayerV2    1       12719367
        EnablePerfInfoMutexWaitLayerV2     1       12719367
        EnablePerfInfoSecurityLayerV2      1       12719367
        EnablePerfInfoSessionLayerV2       1       12719367
        EnablePerfInfoSQLLayerV2           1       12719367
        EnablePerfInfoXppContainerLayerV2  1       12719367
        
    .EXAMPLE
        PS C:\> Get-D365Flight -FlightName WHSWorkCancelForcedFlight
        
        This will list the flight with the specified name on the environment.
        It will show the name and the enabled status.
        
        A result set example:
        
        FlightName                         Enabled FlightServiceId
        ----------                         ------- ---------------
        WHSWorkCancelForcedFlight          1       12719367
        
    .EXAMPLE
        PS C:\> Get-D365Flight -FlightName WHS*
        
        This will list the flight with the specified pattern on the environment.
        It will filter the output to match the "WHS*" pattern.
        It will show the name and the enabled status.
        
        A result set example:
        
        FlightName                         Enabled FlightServiceId
        ----------                         ------- ---------------
        WHSWorkCancelForcedFlight          1       12719367
        
    .NOTES
        Tags: Flight, Flighting
        
        Author: Mötz Jensen (@Splaxi)
        
        At no circumstances can this cmdlet be used to enable a flight in a PROD environment.
#>
function Get-D365Flight {
    [CmdletBinding()]
    param (
        [String] $FlightName = "*",

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

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
    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-flight.sql") -join [Environment]::NewLine

    try {
        $sqlCommand.Connection.Open()
    
        $reader = $sqlCommand.ExecuteReader()

        while ($reader.Read() -eq $true) {
            $res = [PSCustomObject]@{
                FlightName      = "$($reader.GetString($($reader.GetOrdinal("FLIGHTNAME"))))"
                Enabled         = [System.Convert]::ToBoolean($($reader.GetInt32($($reader.GetOrdinal("ENABLED")))))
                FlightServiceId = "$($reader.GetInt32($($reader.GetOrdinal("FLIGHTSERVICEID"))))"
            }

            if ($res.FlightName -NotLike $FlightName) { continue }
            if ($res.FlightServiceId -NotLike $FlightServiceId) { continue }

            $res
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $reader.close()

        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
}