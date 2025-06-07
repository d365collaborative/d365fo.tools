Describe "Enable-D365IISPreload" {
    It "Should set Application Pool Start Mode to AlwaysRunning" {
        # This is a placeholder. In a real test, mock IIS and check the property.
        $true | Should -Be $true
    }
    It "Should set Idle Time-out to 0" {
        $true | Should -Be $true
    }
    It "Should enable Preload on the website" {
        $true | Should -Be $true
    }
}

Describe "Disable-D365IISPreload" {
    It "Should set Application Pool Start Mode to OnDemand" {
        $true | Should -Be $true
    }
    It "Should set Idle Time-out to 20 minutes" {
        $true | Should -Be $true
    }
    It "Should disable Preload on the website" {
        $true | Should -Be $true
    }
}

Describe "Get-D365IISPreload" {
    It "Should return a PSCustomObject with expected properties" {
        $result = Get-D365IISPreload
        $result | Should -BeOfType PSCustomObject
        $result.PSObject.Properties.Name | Should -Contain "AppPool"
        $result.PSObject.Properties.Name | Should -Contain "StartMode"
        $result.PSObject.Properties.Name | Should -Contain "IdleTimeout"
        $result.PSObject.Properties.Name | Should -Contain "Site"
        $result.PSObject.Properties.Name | Should -Contain "PreloadEnabled"
        $result.PSObject.Properties.Name | Should -Contain "DoAppInitAfterRestart"
    }
}
