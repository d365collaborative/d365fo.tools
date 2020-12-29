Describe "Get-D365BacpacTable Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365BacpacTable).ParameterSets.Name | Should -Be 'Default', 'SortSizeAsc', 'SortSizeDesc'
		}
		
		It 'Should have the expected parameter Path' {
			$parameter = (Get-Command Get-D365BacpacTable).Parameters['Path']
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
			$parameter = (Get-Command Get-D365BacpacTable).Parameters['Table']
			$parameter.Name | Should -Be 'Table'
			$parameter.ParameterType.ToString() | Should -Be System.String[]
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Top' {
			$parameter = (Get-Command Get-D365BacpacTable).Parameters['Top']
			$parameter.Name | Should -Be 'Top'
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
		It 'Should have the expected parameter SortSizeAsc' {
			$parameter = (Get-Command Get-D365BacpacTable).Parameters['SortSizeAsc']
			$parameter.Name | Should -Be 'SortSizeAsc'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SortSizeAsc'
			$parameter.ParameterSets.Keys | Should -Contain 'SortSizeAsc'
			$parameter.ParameterSets['SortSizeAsc'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SortSizeAsc'].Position | Should -Be -2147483648
			$parameter.ParameterSets['SortSizeAsc'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SortSizeAsc'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SortSizeAsc'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SortSizeDesc' {
			$parameter = (Get-Command Get-D365BacpacTable).Parameters['SortSizeDesc']
			$parameter.Name | Should -Be 'SortSizeDesc'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SortSizeDesc'
			$parameter.ParameterSets.Keys | Should -Contain 'SortSizeDesc'
			$parameter.ParameterSets['SortSizeDesc'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SortSizeDesc'].Position | Should -Be -2147483648
			$parameter.ParameterSets['SortSizeDesc'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SortSizeDesc'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SortSizeDesc'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -Path
		Default -Path -Table -Top
		#>
	}
 	Describe "Testing parameterset SortSizeAsc" {
		<#
		SortSizeAsc -Path
		SortSizeAsc -Path -Table -Top -SortSizeAsc
		#>
	}
 	Describe "Testing parameterset SortSizeDesc" {
		<#
		SortSizeDesc -Path
		SortSizeDesc -Path -Table -Top -SortSizeDesc
		#>
	}

}