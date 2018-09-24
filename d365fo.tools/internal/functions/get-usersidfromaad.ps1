function Get-UserSIDFromAad($SignInName, $Provider) {

    try {

        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.BusinessPlatform.SharedTypes.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.PerformanceCounters.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Security.SidGenerator.dll"

        $SID = [Microsoft.Dynamics.Ax.Security.SidGenerator]::Generate($SignInName, $Provider)
        Write-Verbose "Generated SID $SID"

        return $SID

    }
    catch [System.Reflection.ReflectionTypeLoadException] {
        Write-Output "Message: $($_.Exception.Message)"
        Write-Output "StackTrace: $($_.Exception.StackTrace)"
        Write-Output "LoaderExceptions: $($_.Exception.LoaderExceptions)"
    }

}

