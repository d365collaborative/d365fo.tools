Describe "Invoke-D365InstallSqlPackage Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365InstallSqlPackage).ParameterSets.Name | Should -Be 'ImportUrl', 'ImportLatest'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Invoke-D365InstallSqlPackage).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportLatest', 'ImportUrl'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportLatest'
			$parameter.ParameterSets['ImportLatest'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportLatest'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportUrl'
			$parameter.ParameterSets['ImportUrl'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportUrl'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Latest' {
			$parameter = (Get-Command Invoke-D365InstallSqlPackage).Parameters['Latest']
			$parameter.Name | Should -Be 'Latest'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportLatest'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportLatest'
			$parameter.ParameterSets['ImportLatest'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportLatest'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportLatest'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Url' {
			$parameter = (Get-Command Invoke-D365InstallSqlPackage).Parameters['Url']
			$parameter.Name | Should -Be 'Url'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportUrl'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportUrl'
			$parameter.ParameterSets['ImportUrl'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportUrl'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportUrl'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset ImportUrl" {
		<#
		ImportUrl -
		ImportUrl -Path -Url
		#>
	}
 	Describe "Testing parameterset ImportLatest" {
		<#
		ImportLatest -
		ImportLatest -Path -Latest
		#>
	}

}