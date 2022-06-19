Describe "Add-D365AzureStorageConfig Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Add-D365AzureStorageConfig).ParameterSets.Name | Should -Be 'AccessToken', 'SAS'
		}
		
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AccountId' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['AccountId']
			$parameter.Name | Should -Be 'AccountId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AccessToken' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['AccessToken']
			$parameter.Name | Should -Be 'AccessToken'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'AccessToken'
			$parameter.ParameterSets.Keys | Should -Contain 'AccessToken'
			$parameter.ParameterSets['AccessToken'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['AccessToken'].Position | Should -Be -2147483648
			$parameter.ParameterSets['AccessToken'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['AccessToken'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['AccessToken'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SAS' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['SAS']
			$parameter.Name | Should -Be 'SAS'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SAS'
			$parameter.ParameterSets.Keys | Should -Contain 'SAS'
			$parameter.ParameterSets['SAS'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['SAS'].Position | Should -Be -2147483648
			$parameter.ParameterSets['SAS'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SAS'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SAS'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Container' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['Container']
			$parameter.Name | Should -Be 'Container'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Temporary' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['Temporary']
			$parameter.Name | Should -Be 'Temporary'
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
		It 'Should have the expected parameter Force' {
			$parameter = (Get-Command Add-D365AzureStorageConfig).Parameters['Force']
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
	}
	
	Describe "Testing parameterset AccessToken" {
		<#
		AccessToken -Name -AccountId -AccessToken -Container
		AccessToken -Name -AccountId -AccessToken -Container -Temporary -Force
		#>
	}
 	Describe "Testing parameterset SAS" {
		<#
		SAS -Name -AccountId -SAS -Container
		SAS -Name -AccountId -SAS -Container -Temporary -Force
		#>
	}

}