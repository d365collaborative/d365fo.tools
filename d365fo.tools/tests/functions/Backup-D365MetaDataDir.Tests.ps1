Describe "Backup-D365MetaDataDir Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Backup-D365MetaDataDir).ParameterSets.Name | Should -Be 'Default'
		}
		
		It 'Should have the expected parameter MetaDataDir' {
			$parameter = (Get-Command Backup-D365MetaDataDir).Parameters['MetaDataDir']
			$parameter.Name | Should -Be 'MetaDataDir'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 1
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter BackupDir' {
			$parameter = (Get-Command Backup-D365MetaDataDir).Parameters['BackupDir']
			$parameter.Name | Should -Be 'BackupDir'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 1
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -
		Default -MetaDataDir -BackupDir
		#>
	}

}