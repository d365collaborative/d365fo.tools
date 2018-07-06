function Get-ApplicationEnvironment
{
    Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.Environment.dll"
      
    $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
    
    $environment 
}