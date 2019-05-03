Describe "Invoke-D365LcsApiRefreshToken Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Invoke-D365LcsApiRefreshToken).ParameterSets.Name | Should -Be 'Object', 'Simple'
		}
		
		It 'Should have the expected parameter ClientId' {
			$parameter = (Get-Command Invoke-D365LcsApiRefreshToken).Parameters['ClientId']
			$parameter.Name | Should -Be 'ClientId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Object', 'Simple'
			$parameter.ParameterSets.Keys | Should -Contain 'Object'
			$parameter.ParameterSets['Object'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Object'].Position | Should -Be 1
			$parameter.ParameterSets['Object'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Object'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Object'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Simple'
			$parameter.ParameterSets['Simple'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Simple'].Position | Should -Be 1
			$parameter.ParameterSets['Simple'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Simple'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Simple'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter RefreshToken' {
			$parameter = (Get-Command Invoke-D365LcsApiRefreshToken).Parameters['RefreshToken']
			$parameter.Name | Should -Be 'RefreshToken'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Simple'
			$parameter.ParameterSets.Keys | Should -Contain 'Simple'
			$parameter.ParameterSets['Simple'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Simple'].Position | Should -Be 2
			$parameter.ParameterSets['Simple'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Simple'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Simple'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter InputObject' {
			$parameter = (Get-Command Invoke-D365LcsApiRefreshToken).Parameters['InputObject']
			$parameter.Name | Should -Be 'InputObject'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.PSObject
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Object'
			$parameter.ParameterSets.Keys | Should -Contain 'Object'
			$parameter.ParameterSets['Object'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Object'].Position | Should -Be 2
			$parameter.ParameterSets['Object'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Object'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Object'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Object" {
		<#
		Object -ClientId
		Object -ClientId -InputObject
		#>
	}
 	Describe "Testing parameterset Simple" {
		<#
		Simple -ClientId -RefreshToken
		Simple -ClientId -RefreshToken
		#>
	}

}