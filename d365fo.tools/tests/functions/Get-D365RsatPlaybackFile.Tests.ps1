Describe "Get-D365RsatPlaybackFile Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365RsatPlaybackFile).ParameterSets.Name | Should -Be 'Default', 'ExecutionUser'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Get-D365RsatPlaybackFile).Parameters['Path']
			$parameter.Name | Should -Be 'Path'
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
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Get-D365RsatPlaybackFile).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
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
		It 'Should have the expected parameter ExecutionUsername' {
			$parameter = (Get-Command Get-D365RsatPlaybackFile).Parameters['ExecutionUsername']
			$parameter.Name | Should -Be 'ExecutionUsername'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExecutionUser'
			$parameter.ParameterSets.Keys | Should -Contain 'ExecutionUser'
			$parameter.ParameterSets['ExecutionUser'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ExecutionUser'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ExecutionUser'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExecutionUser'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExecutionUser'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -
		Default -Path -Name
		#>
	}
 	Describe "Testing parameterset ExecutionUser" {
		<#
		ExecutionUser -
		ExecutionUser -Name -ExecutionUsername
		#>
	}

}