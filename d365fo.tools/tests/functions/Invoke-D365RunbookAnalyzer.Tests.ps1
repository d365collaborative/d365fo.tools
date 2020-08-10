Describe "Invoke-D365RunbookAnalyzer Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365RunbookAnalyzer).ParameterSets.Name | Should -Be 'Default', 'FailedOnlyAsObjects', 'FailedOnly'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Invoke-D365RunbookAnalyzer).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'FailedOnlyAsObjects', 'FailedOnly', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'FailedOnlyAsObjects'
			$parameter.ParameterSets['FailedOnlyAsObjects'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['FailedOnlyAsObjects'].Position | Should -Be -2147483648
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromPipeline | Should -Be $True
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'FailedOnly'
			$parameter.ParameterSets['FailedOnly'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['FailedOnly'].Position | Should -Be -2147483648
			$parameter.ParameterSets['FailedOnly'].ValueFromPipeline | Should -Be $True
			$parameter.ParameterSets['FailedOnly'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['FailedOnly'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Default'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter FailedOnly' {
			$parameter = (Get-Command Invoke-D365RunbookAnalyzer).Parameters['FailedOnly']
			$parameter.Name | Should -Be 'FailedOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'FailedOnly'
			$parameter.ParameterSets.Keys | Should -Contain 'FailedOnly'
			$parameter.ParameterSets['FailedOnly'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['FailedOnly'].Position | Should -Be -2147483648
			$parameter.ParameterSets['FailedOnly'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['FailedOnly'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['FailedOnly'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter FailedOnlyAsObjects' {
			$parameter = (Get-Command Invoke-D365RunbookAnalyzer).Parameters['FailedOnlyAsObjects']
			$parameter.Name | Should -Be 'FailedOnlyAsObjects'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'FailedOnlyAsObjects'
			$parameter.ParameterSets.Keys | Should -Contain 'FailedOnlyAsObjects'
			$parameter.ParameterSets['FailedOnlyAsObjects'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['FailedOnlyAsObjects'].Position | Should -Be -2147483648
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['FailedOnlyAsObjects'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -Path
		Default -Path
		#>
	}
 	Describe "Testing parameterset FailedOnlyAsObjects" {
		<#
		FailedOnlyAsObjects -Path
		FailedOnlyAsObjects -Path -FailedOnlyAsObjects
		#>
	}
 	Describe "Testing parameterset FailedOnly" {
		<#
		FailedOnly -Path
		FailedOnly -Path -FailedOnly
		#>
	}

}