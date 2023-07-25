Describe "Invoke-D365AzureStorageDownload Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365AzureStorageDownload).ParameterSets.Name | Should -Be 'Default', 'Latest'
		}
		
		It 'Should have the expected parameter AccountId' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['AccountId']
			$parameter.Name | Should -Be 'AccountId'
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
		It 'Should have the expected parameter AccessToken' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['AccessToken']
			$parameter.Name | Should -Be 'AccessToken'
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
		It 'Should have the expected parameter SAS' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['SAS']
			$parameter.Name | Should -Be 'SAS'
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
		It 'Should have the expected parameter Container' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['Container']
			$parameter.Name | Should -Be 'Container'
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
		It 'Should have the expected parameter FileName' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['FileName']
			$parameter.Name | Should -Be 'FileName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Default'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
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
		It 'Should have the expected parameter Latest' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['Latest']
			$parameter.Name | Should -Be 'Latest'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Latest'
			$parameter.ParameterSets.Keys | Should -Contain 'Latest'
			$parameter.ParameterSets['Latest'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Latest'].Position | Should -Be 4
			$parameter.ParameterSets['Latest'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Latest'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Latest'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Force' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['Force']
			$parameter.Name | Should -Be 'Force'
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
		It 'Should have the expected parameter EnableException' {
			$parameter = (Get-Command Invoke-D365AzureStorageDownload).Parameters['EnableException']
			$parameter.Name | Should -Be 'EnableException'
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
	
	Describe "Testing parameterset Default" {
		<#
		Default -FileName
		Default -AccountId -AccessToken -SAS -Container -FileName -Path -Force -EnableException
		#>
	}
 	Describe "Testing parameterset Latest" {
		<#
		Latest -Latest
		Latest -AccountId -AccessToken -SAS -Container -Path -Latest -Force -EnableException
		#>
	}

}