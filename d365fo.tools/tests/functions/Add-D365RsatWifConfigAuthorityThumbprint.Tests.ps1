Describe "Add-D365RsatWifConfigAuthorityThumbprint Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Add-D365RsatWifConfigAuthorityThumbprint).ParameterSets.Name | Should -Be '__AllParameterSets'
		}
		
		It 'Should have the expected parameter CertificateThumbprint' {
			$parameter = (Get-Command Add-D365RsatWifConfigAuthorityThumbprint).Parameters['CertificateThumbprint']
			$parameter.Name | Should -Be 'CertificateThumbprint'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 1
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset __AllParameterSets" {
		<#
		__AllParameterSets -CertificateThumbprint
		__AllParameterSets -CertificateThumbprint
		#>
	}

}