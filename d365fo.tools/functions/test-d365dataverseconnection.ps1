
<#
    .SYNOPSIS
        Test the dataverse connection
        
    .DESCRIPTION
        Invokes the built-in http communication endpount, that validates the connection between the D365FO environment and dataverse
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .EXAMPLE
        PS C:\> Test-D365DataverseConnection
        
        This will invoke the http communication component, that validates the basic settings between D365FO and Dataverse.
        It will output the raw details from the call, to make it easier to troubleshoot the connectivity between D365FO and Dataverse.
        
    .NOTES
        General notes
#>
function Test-D365DataverseConnection {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string] $BinDir = "$Script:BinDir\bin"
    )

    begin {
    }

    process {
        $cdsApiPath = "sdkmessages";
        $httpCommunicationDllPath = Join-Path -Path $BinDir -ChildPath "Microsoft.Dynamics.HttpCommunication.dll"
        
        if (-not (Test-PathExists -Path $httpCommunicationDllPath -Type Leaf)) {
            return
        }

        Write-PSFMessage -Level Verbose -Message "Loading the 'Microsoft.Dynamics.HttpCommunication.dll' file into the current session."
        Add-Type -Path $httpCommunicationDllPath

        try {
            Write-PSFMessage -Level Verbose -Message "Building the logger object, to handle the output from the test."
            $assembly = [System.Reflection.Assembly]::LoadFile($httpCommunicationDllPath)
            $loggerType = $assembly.GetType("Microsoft.Dynamics.HttpCommunication.Logging.InMemoryLogger")
            $bindingFlags = [System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::Public
            $loggerConstructor = $loggerType.GetConstructor($bindingFlags, $null, [System.Type]::EmptyTypes, $null)
            $logger = $loggerConstructor.Invoke($null)

            Write-PSFMessage -Level Verbose -Message "Building the client/request object, to execute the test / validation."
            $cdsWebApiClient = New-Object Microsoft.Dynamics.HttpCommunication.Cds.CdsWebApiClient $logger;
            $bindingFlags = [System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic
            $method = [Microsoft.Dynamics.HttpCommunication.Cds.CdsWebApiClient].GetMethod("GetWithStringResponse", $bindingFlags, $null, @([string]), $null)
            
            Write-PSFMessage -Level Verbose -Message "Invoking the test / validation request."
            $task = $method.Invoke($cdsWebApiClient, @($cdsApiPath))
            $response = $task.GetAwaiter().GetResult()

            $logger.LogContent.ToString()
        }
        catch {
            Write-PSFHostColor -String $logger.LogContent.ToString() -DefaultColor Red

            if ($logger.LogContent.ToString() -like '*Cannot Find Thumbprint by Certificatename*') {
                Write-PSFMessage -Level Host -Message "The <c='em'>'Cannot Find Thumbprint by Certificatename'</c> indicates that you need to run the <c='em'>'New-D365EntraIntegration'</c> cmdlet."
                Write-PSFMessage -Level Host -Message "You should read the following links: <c='em'>https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations</c> and <c='em'>https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/business-events/che-be-ve-error</c>."
                Stop-PSFFunction -Message "Stopping because the 'Cannot Find Thumbprint by Certificatename' error was encounted"
                return
            }
            elseif ($logger.LogContent.ToString() -like '*Expected aud https://securityservice.operations365.dynamics.com*') {
                Write-PSFMessage -Level Host -Message "The <c='em'>'Expected aud https://securityservice.operations365.dynamics.com'</c> indicates that you need to configure Azure Entra (Registered Application) between your <c='em'>D365FO</c> environment and the connected <c='em'>Dataverse</c> environment."
                Write-PSFMessage -Level Host -Message "You should read the following link: <c='em'>https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/business-events/che-be-ve-error</c>."
                Stop-PSFFunction -Message "Stopping because the 'Cannot Find Thumbprint by Certificatename' error was encounted"
                return
            }
        }
    }

    end {
    }
}