Describe "Get-D365AzureStorageFile Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365AzureStorageFile).ParameterSets.Name | Should -Be 'Default', 'Latest'
		}
		
		It 'Should have the expected parameter AccountId' {
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['AccountId']
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
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['AccessToken']
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
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['SAS']
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
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['Container']
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
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Latest' {
			$parameter = (Get-Command Get-D365AzureStorageFile).Parameters['Latest']
			$parameter.Name | Should -Be 'Latest'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Latest'
			$parameter.ParameterSets.Keys | Should -Contain 'Latest'
			$parameter.ParameterSets['Latest'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Latest'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Latest'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Latest'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Latest'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -
		Default -AccountId -AccessToken -SAS -Container -Name
		#>
	}
 	Describe "Testing parameterset Latest" {
		<#
		Latest -Latest
		Latest -AccountId -AccessToken -SAS -Container -Latest
		#>
	}

}