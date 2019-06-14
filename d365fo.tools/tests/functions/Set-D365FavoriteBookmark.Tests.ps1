Describe "Set-D365FavoriteBookmark Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Set-D365FavoriteBookmark).ParameterSets.Name | Should -Be 'D365FO', 'AzureDevOps'
		}
		
		It 'Should have the expected parameter URL' {
			$parameter = (Get-Command Set-D365FavoriteBookmark).Parameters['URL']
			$parameter.Name | Should -Be 'URL'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter D365FO' {
			$parameter = (Get-Command Set-D365FavoriteBookmark).Parameters['D365FO']
			$parameter.Name | Should -Be 'D365FO'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'D365FO'
			$parameter.ParameterSets.Keys | Should -Contain 'D365FO'
			$parameter.ParameterSets['D365FO'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['D365FO'].Position | Should -Be -2147483648
			$parameter.ParameterSets['D365FO'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['D365FO'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['D365FO'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AzureDevOps' {
			$parameter = (Get-Command Set-D365FavoriteBookmark).Parameters['AzureDevOps']
			$parameter.Name | Should -Be 'AzureDevOps'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'AzureDevOps'
			$parameter.ParameterSets.Keys | Should -Contain 'AzureDevOps'
			$parameter.ParameterSets['AzureDevOps'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['AzureDevOps'].Position | Should -Be -2147483648
			$parameter.ParameterSets['AzureDevOps'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['AzureDevOps'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['AzureDevOps'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset D365FO" {
		<#
		D365FO -
		D365FO -URL -D365FO
		#>
	}
 	Describe "Testing parameterset AzureDevOps" {
		<#
		AzureDevOps -
		AzureDevOps -URL -AzureDevOps
		#>
	}

}