Describe "Invoke-D365SDPInstall Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365SDPInstall).ParameterSets.Name | Should -Be 'QuickInstall', 'DevInstall', 'Manual'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 1
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter MetaDataDir' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['MetaDataDir']
			$parameter.Name | Should -Be 'MetaDataDir'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 2
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter QuickInstallAll' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['QuickInstallAll']
			$parameter.Name | Should -Be 'QuickInstallAll'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'QuickInstall'
			$parameter.ParameterSets.Keys | Should -Contain 'QuickInstall'
			$parameter.ParameterSets['QuickInstall'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['QuickInstall'].Position | Should -Be 3
			$parameter.ParameterSets['QuickInstall'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['QuickInstall'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['QuickInstall'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DevInstall' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['DevInstall']
			$parameter.Name | Should -Be 'DevInstall'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'DevInstall'
			$parameter.ParameterSets.Keys | Should -Contain 'DevInstall'
			$parameter.ParameterSets['DevInstall'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['DevInstall'].Position | Should -Be 3
			$parameter.ParameterSets['DevInstall'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['DevInstall'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['DevInstall'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Command' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['Command']
			$parameter.Name | Should -Be 'Command'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Manual'
			$parameter.ParameterSets.Keys | Should -Contain 'Manual'
			$parameter.ParameterSets['Manual'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Manual'].Position | Should -Be 3
			$parameter.ParameterSets['Manual'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Manual'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Manual'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Step' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['Step']
			$parameter.Name | Should -Be 'Step'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 4
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter RunbookId' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['RunbookId']
			$parameter.Name | Should -Be 'RunbookId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 5
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter LogPath' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['LogPath']
			$parameter.Name | Should -Be 'LogPath'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ShowOriginalProgress' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['ShowOriginalProgress']
			$parameter.Name | Should -Be 'ShowOriginalProgress'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter OutputCommandOnly' {
			$parameter = (Get-Command Invoke-D365SDPInstall).Parameters['OutputCommandOnly']
			$parameter.Name | Should -Be 'OutputCommandOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset QuickInstall" {
		<#
		QuickInstall -Path
		QuickInstall -Path -MetaDataDir -QuickInstallAll -Step -RunbookId -LogPath -ShowOriginalProgress -OutputCommandOnly
		#>
	}
 	Describe "Testing parameterset DevInstall" {
		<#
		DevInstall -Path
		DevInstall -Path -MetaDataDir -DevInstall -Step -RunbookId -LogPath -ShowOriginalProgress -OutputCommandOnly
		#>
	}
 	Describe "Testing parameterset Manual" {
		<#
		Manual -Path -Command
		Manual -Path -MetaDataDir -Command -Step -RunbookId -LogPath -ShowOriginalProgress -OutputCommandOnly
		#>
	}

}