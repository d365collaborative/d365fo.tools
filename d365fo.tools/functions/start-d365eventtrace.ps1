
<#
    .SYNOPSIS
        Start an Event Trace session
        
    .DESCRIPTION
        Start an Event Trace session with default values to help you getting started
        
    .PARAMETER ProviderName
        Name of the provider(s) you want to have part of your trace
        
        Accepts an array/list of provider names
        
    .PARAMETER OutputPath
        Path to the output folder where you want to store the ETL file that will be generated
        
        Default path is "C:\Temp\d365fo.tools\EventTrace"
        
    .PARAMETER SessionName
        Name that you want the tracing session to have while running the trace
        
        Default value is "d365fo.tools.trace"
        
    .PARAMETER FileName
        Name of the file that you want the trace to write its output to
        
        Default value is "d365fo.tools.trace.etl"
        
    .PARAMETER OutputFormat
        The desired output format of the ETL file being outputted from the tracing session
        
        Default value is "bincirc"
        
    .PARAMETER MinBuffer
        The minimum buffer size in MB that you want the tracing session to work with
        
        Default value is 10240
        
    .PARAMETER MaxBuffer
        The maximum buffer size in MB that you want the tracing session to work with
        
        Default value is 10240
        
    .PARAMETER BufferSizeKB
        The buffer size in KB that you want the tracing session to work with
        
        Default value is 1024
        
    .PARAMETER MaxLogFileSizeMB
        The maximum log file size in MB that you want the tracing session to work with
        
        Default value is 4096
        
    .EXAMPLE
        PS C:\> Start-D365EventTrace -ProviderName "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime"
        
        This will start a new Event Tracing session with the binary circular output format.
        It uses "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" as the providernames.
        It uses the default output folder "C:\Temp\d365fo.tools\EventTrace".
        
        It will use the default values for the remaining parameters.
        
    .EXAMPLE
        PS C:\> Start-D365EventTrace -ProviderName "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" -OutputFormat CSV
        
        This will start a new Event Tracing session with the comma separated output format.
        It uses "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" as the providernames.
        It uses the default output folder "C:\Temp\d365fo.tools\EventTrace".
        
        It will use the default values for the remaining parameters.
        
    .NOTES
        Tags: ETL, EventTracing, EventTrace
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet/function was inspired by the work of Michael Stashwick (@D365Stuff)
        
        He blog is located here: https://www.d365stuff.co/
        
        and the blogpost that pointed us in the right direction is located here: https://www.d365stuff.co/trace-batch-jobs-and-more-via-cmd-logman/
#>

function Start-D365EventTrace {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string[]] $ProviderName,

        [string] $OutputPath = (Join-Path -Path $Script:DefaultTempPath -ChildPath "EventTrace"),

        [string] $SessionName = "d365fo.tools.trace",

        [string] $FileName = "d365fo.tools.trace.etl",

        [ValidateSet('bin', 'bincirc', 'csv', 'sql', 'tsv')]
        [string] $OutputFormat = "bincirc",

        [Int32] $MinBuffer = 10240,

        [Int32] $MaxBuffer = 10240,

        [Int32] $BufferSizeKB = 1024,

        [Int32] $MaxLogFileSizeMB = 4096
    )
    
    begin {
        $providers = New-Object System.Collections.Generic.List[string]

        if (-not (Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

        Write-PSFMessage -Level Verbose -Message "Configuring the permissions on the folder to make sure the Start-Trace command can read the files." -Target $OutputPath
        
        $propagation = [system.security.accesscontrol.PropagationFlags]"None"
        $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
        $accessRule = New-Object  system.security.accesscontrol.filesystemaccessrule("BUILTIN\Users", "FullControl", $inherit, $propagation, "Allow")
        $aclFolder = Get-Acl -Path $OutputPath
        $aclFolder.AddAccessRule($accessRule)
        Set-Acl -Path $OutputPath -AclObject $aclFolder
        
        $providerListPath = Join-Path -Path $OutputPath -ChildPath "ProviderList.txt"
    }
    
    process {
        foreach ($name in $ProviderName) {
            Write-PSFMessage -Level Verbose -Message "Adding the $name to the list of providers." -Target $name
            $providers.Add($name)
        }
    }
    
    end {
        Write-PSFMessage -Level Verbose -Message "Storing the providers in '$providerListPath' as a UTF8 (NON-BOM) file." -Target $providerListPath

        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($providerListPath, $($providers.ToArray() -join [System.Environment]::NewLine), $Utf8NoBomEncoding)

        $outputFile = Join-Path -Path $OutputPath -ChildPath $FileName

        Write-PSFMessage -Level Verbose -Message "Starting the trace now."
        Start-Trace -SessionName $SessionName -OutputFilePath $outputFile -ProviderFilePath $providerListPath -ETS -Format $OutputFormat -MinBuffers $MinBuffer -MaxBuffers $MaxBuffer -BufferSizeInKB $BufferSizeKB -MaxLogFileSizeInMB $MaxLogFileSizeMB
    }
}