Describe "Get-D365PackageLabelResourceFile Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365PackageLabelResourceFile).ParameterSets.Name | Should -Be 'Default', 'Specific'
		}
		
		It 'Should have the expected parameter PackageDirectory' {
			$parameter = (Get-Command Get-D365PackageLabelResourceFile).Parameters['PackageDirectory']
			$parameter.Name | Should -Be 'PackageDirectory'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Specific', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Specific'
			$parameter.ParameterSets['Specific'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Specific'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Specific'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Specific'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Specific'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Default'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Get-D365PackageLabelResourceFile).Parameters['Name']
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
		It 'Should have the expected parameter Language' {
			$parameter = (Get-Command Get-D365PackageLabelResourceFile).Parameters['Language']
			$parameter.Name | Should -Be 'Language'
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
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -PackageDirectory
		Default -PackageDirectory -Name -Language
		#>
	}
 	Describe "Testing parameterset Specific" {
		<#
		Specific -PackageDirectory
		Specific -PackageDirectory -Name -Language
		#>
	}

}