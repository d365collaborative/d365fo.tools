Describe "Clear-D365BacpacTableData Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Clear-D365BacpacTableData).ParameterSets.Name | Should -Be 'Copy', 'Keep'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Clear-D365BacpacTableData).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
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
		It 'Should have the expected parameter Table' {
			$parameter = (Get-Command Clear-D365BacpacTableData).Parameters['Table']
			$parameter.Name | Should -Be 'Table'
			$parameter.ParameterType.ToString() | Should -Be System.String[]
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter OutputPath' {
			$parameter = (Get-Command Clear-D365BacpacTableData).Parameters['OutputPath']
			$parameter.Name | Should -Be 'OutputPath'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Copy'
			$parameter.ParameterSets.Keys | Should -Contain 'Copy'
			$parameter.ParameterSets['Copy'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Copy'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Copy'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Copy'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Copy'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ClearFromSource' {
			$parameter = (Get-Command Clear-D365BacpacTableData).Parameters['ClearFromSource']
			$parameter.Name | Should -Be 'ClearFromSource'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Keep'
			$parameter.ParameterSets.Keys | Should -Contain 'Keep'
			$parameter.ParameterSets['Keep'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Keep'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Keep'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Keep'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Keep'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Copy" {
		<#
		Copy -Path -Table -OutputPath
		Copy -Path -Table -OutputPath
		#>
	}
 	Describe "Testing parameterset Keep" {
		<#
		Keep -Path -Table -ClearFromSource
		Keep -Path -Table -ClearFromSource
		#>
	}

}