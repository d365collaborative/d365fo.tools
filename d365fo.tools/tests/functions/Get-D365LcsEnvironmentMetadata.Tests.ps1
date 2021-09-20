Describe "Get-D365LcsEnvironmentMetadata Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365LcsEnvironmentMetadata).ParameterSets.Name | Should -Be 'Default', 'SearchByEnvironmentId', 'SearchByEnvironmentName', 'Pagination'
		}
		
		It 'Should have the expected parameter ProjectId' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['ProjectId']
			$parameter.Name | Should -Be 'ProjectId'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter BearerToken' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['BearerToken']
			$parameter.Name | Should -Be 'BearerToken'
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
		It 'Should have the expected parameter EnvironmentId' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['EnvironmentId']
			$parameter.Name | Should -Be 'EnvironmentId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByEnvironmentId'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByEnvironmentId'
			$parameter.ParameterSets['SearchByEnvironmentId'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentId'].Position | Should -Be -2147483648
			$parameter.ParameterSets['SearchByEnvironmentId'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentId'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentId'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter EnvironmentName' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['EnvironmentName']
			$parameter.Name | Should -Be 'EnvironmentName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByEnvironmentName'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByEnvironmentName'
			$parameter.ParameterSets['SearchByEnvironmentName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentName'].Position | Should -Be -2147483648
			$parameter.ParameterSets['SearchByEnvironmentName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByEnvironmentName'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter TraverseAllPages' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['TraverseAllPages']
			$parameter.Name | Should -Be 'TraverseAllPages'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Pagination'
			$parameter.ParameterSets.Keys | Should -Contain 'Pagination'
			$parameter.ParameterSets['Pagination'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Pagination'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Pagination'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Pagination'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Pagination'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter FirstPages' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['FirstPages']
			$parameter.Name | Should -Be 'FirstPages'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Pagination'
			$parameter.ParameterSets.Keys | Should -Contain 'Pagination'
			$parameter.ParameterSets['Pagination'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Pagination'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Pagination'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Pagination'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Pagination'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter LcsApiUri' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['LcsApiUri']
			$parameter.Name | Should -Be 'LcsApiUri'
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
		It 'Should have the expected parameter FailOnErrorMessage' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['FailOnErrorMessage']
			$parameter.Name | Should -Be 'FailOnErrorMessage'
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
		It 'Should have the expected parameter RetryTimeout' {
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['RetryTimeout']
			$parameter.Name | Should -Be 'RetryTimeout'
			$parameter.ParameterType.ToString() | Should -Be System.TimeSpan
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
			$parameter = (Get-Command Get-D365LcsEnvironmentMetadata).Parameters['EnableException']
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
		Default -
		Default -ProjectId -BearerToken -LcsApiUri -FailOnErrorMessage -RetryTimeout -EnableException
		#>
	}
 	Describe "Testing parameterset SearchByEnvironmentId" {
		<#
		SearchByEnvironmentId -
		SearchByEnvironmentId -ProjectId -BearerToken -EnvironmentId -LcsApiUri -FailOnErrorMessage -RetryTimeout -EnableException
		#>
	}
 	Describe "Testing parameterset SearchByEnvironmentName" {
		<#
		SearchByEnvironmentName -
		SearchByEnvironmentName -ProjectId -BearerToken -EnvironmentName -LcsApiUri -FailOnErrorMessage -RetryTimeout -EnableException
		#>
	}
 	Describe "Testing parameterset Pagination" {
		<#
		Pagination -
		Pagination -ProjectId -BearerToken -TraverseAllPages -FirstPages -LcsApiUri -FailOnErrorMessage -RetryTimeout -EnableException
		#>
	}

}