function Get-ApplicationEnvironment {
    $AOSPath = [System.Environment]::ExpandEnvironmentVariables("%ServiceDrive%") + "\AOSService\webroot"
    if (!$script:IsAdminRuntime) {
        $Path = Join-Path $AOSPath "bin\Microsoft.Dynamics.ApplicationPlatform.Environment.dll"

        if(Test-Path -Path $Path -PathType Leaf) {
            Add-Type -Path $Path
            
            $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
        }
    }
    else {
        $break = $false

        Write-Verbose "Shadow cloning the Microsoft.Dynamics.ApplicationPlatform.Environment.dll to avoid locking issues."

        $BasePath = "$AOSPath\bin\"
        [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
        
        $null = $Files2Process.Add("Microsoft.Dynamics.AX.Authentication.Instrumentation")
        $null = $Files2Process.Add("Microsoft.Dynamics.AX.Configuration.Base")
        $null = $Files2Process.Add("Microsoft.Dynamics.BusinessPlatform.SharedTypes")
        $null = $Files2Process.Add("Microsoft.Dynamics.AX.Framework.EncryptionEngine")
        $null = $Files2Process.Add("Microsoft.Web.Administration")
        $null = $Files2Process.Add("Microsoft.Dynamics.ApplicationPlatform.Environment")
        
        foreach ($name in $Files2Process) {
            
            $ShadowClone = Join-Path $BasePath "$name`_shadow.dll"
            $Path = Join-Path $BasePath "$name.dll"
            
            if (Test-Path -Path $Path -PathType Leaf) {
                Copy-Item -Path $Path -Destination $ShadowClone -Force

                $null = [AppDomain]::CurrentDomain.Load(([System.IO.File]::ReadAllBytes($ShadowClone)))

                Remove-Item -Path $ShadowClone -Force
            }
            else {
                $break = $true
                break
            }
        }
    
        if($break -eq $false) {
            $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
        }
    }
    
    $environment
}