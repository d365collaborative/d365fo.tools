Describe "Set-D365StartPage Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Set-D365StartPage).ParameterSets.Name | Should -Be 'Default', 'Url'
		}
		
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Set-D365StartPage).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Default'].Position | Should -Be 1
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Url' {
			$parameter = (Get-Command Set-D365StartPage).Parameters['Url']
			$parameter.Name | Should -Be 'Url'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Url'
			$parameter.ParameterSets.Keys | Should -Contain 'Url'
			$parameter.ParameterSets['Url'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Url'].Position | Should -Be 1
			$parameter.ParameterSets['Url'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Url'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Url'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -Name
		Default -Name
		#>
	}
 	Describe "Testing parameterset Url" {
		<#
		Url -Url
		Url -Url
		#>
	}

}