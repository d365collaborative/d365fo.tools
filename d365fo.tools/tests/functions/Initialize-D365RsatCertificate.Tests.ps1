Describe "Initialize-D365RsatCertificate Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Initialize-D365RsatCertificate).ParameterSets.Name | Should -Be 'KeepCertificateFile'
		}
		
		It 'Should have the expected parameter CertificateFileName' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['CertificateFileName']
			$parameter.Name | Should -Be 'CertificateFileName'
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
		It 'Should have the expected parameter PrivateKeyFileName' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['PrivateKeyFileName']
			$parameter.Name | Should -Be 'PrivateKeyFileName'
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
		It 'Should have the expected parameter Password' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['Password']
			$parameter.Name | Should -Be 'Password'
			$parameter.ParameterType.ToString() | Should -Be System.Security.SecureString
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CertificateOnly' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['CertificateOnly']
			$parameter.Name | Should -Be 'CertificateOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter KeepCertificateFile' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['KeepCertificateFile']
			$parameter.Name | Should -Be 'KeepCertificateFile'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'KeepCertificateFile'
			$parameter.ParameterSets.Keys | Should -Contain 'KeepCertificateFile'
			$parameter.ParameterSets['KeepCertificateFile'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].Position | Should -Be -2147483648
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter OutputPath' {
			$parameter = (Get-Command Initialize-D365RsatCertificate).Parameters['OutputPath']
			$parameter.Name | Should -Be 'OutputPath'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'KeepCertificateFile'
			$parameter.ParameterSets.Keys | Should -Contain 'KeepCertificateFile'
			$parameter.ParameterSets['KeepCertificateFile'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].Position | Should -Be -2147483648
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['KeepCertificateFile'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset KeepCertificateFile" {
		<#
		KeepCertificateFile -
		KeepCertificateFile -CertificateFileName -PrivateKeyFileName -Password -CertificateOnly -KeepCertificateFile -OutputPath
		#>
	}

}