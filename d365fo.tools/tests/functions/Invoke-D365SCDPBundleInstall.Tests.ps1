Describe "Invoke-D365SCDPBundleInstall Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365SCDPBundleInstall).ParameterSets.Name | Should -Be 'InstallOnly', 'Tfs'
		}
		
		It 'Should have the expected parameter InstallOnly' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['InstallOnly']
			$parameter.Name | Should -Be 'InstallOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'InstallOnly'
			$parameter.ParameterSets.Keys | Should -Contain 'InstallOnly'
			$parameter.ParameterSets['InstallOnly'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['InstallOnly'].Position | Should -Be 0
			$parameter.ParameterSets['InstallOnly'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['InstallOnly'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['InstallOnly'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Command' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['Command']
			$parameter.Name | Should -Be 'Command'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Tfs'
			$parameter.ParameterSets.Keys | Should -Contain 'Tfs'
			$parameter.ParameterSets['Tfs'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Tfs'].Position | Should -Be 0
			$parameter.ParameterSets['Tfs'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['Path']
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
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['MetaDataDir']
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
		It 'Should have the expected parameter TfsWorkspaceDir' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['TfsWorkspaceDir']
			$parameter.Name | Should -Be 'TfsWorkspaceDir'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Tfs'
			$parameter.ParameterSets.Keys | Should -Contain 'Tfs'
			$parameter.ParameterSets['Tfs'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Tfs'].Position | Should -Be 3
			$parameter.ParameterSets['Tfs'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter TfsUri' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['TfsUri']
			$parameter.Name | Should -Be 'TfsUri'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Tfs'
			$parameter.ParameterSets.Keys | Should -Contain 'Tfs'
			$parameter.ParameterSets['Tfs'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Tfs'].Position | Should -Be 4
			$parameter.ParameterSets['Tfs'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Tfs'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ShowModifiedFiles' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['ShowModifiedFiles']
			$parameter.Name | Should -Be 'ShowModifiedFiles'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 4
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ShowProgress' {
			$parameter = (Get-Command Invoke-D365SCDPBundleInstall).Parameters['ShowProgress']
			$parameter.Name | Should -Be 'ShowProgress'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 5
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset InstallOnly" {
		<#
		InstallOnly -InstallOnly -Path
		InstallOnly -InstallOnly -Path -MetaDataDir -ShowModifiedFiles -ShowProgress
		#>
	}
 	Describe "Testing parameterset Tfs" {
		<#
		Tfs -Path
		Tfs -Command -Path -MetaDataDir -TfsWorkspaceDir -TfsUri -ShowModifiedFiles -ShowProgress
		#>
	}

}