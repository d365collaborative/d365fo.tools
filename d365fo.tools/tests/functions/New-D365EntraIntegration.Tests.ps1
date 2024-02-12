Describe "New-D365EntraIntegration Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command New-D365EntraIntegration).ParameterSets.Name | Should -Be 'NewCertificate', 'ExistingCertificate'
		}
		
		It 'Should have the expected parameter ClientId' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['ClientId']
			$parameter.Name | Should -Be 'ClientId'
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
		It 'Should have the expected parameter ExistingCertificateFile' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['ExistingCertificateFile']
			$parameter.Name | Should -Be 'ExistingCertificateFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExistingCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'ExistingCertificate'
			$parameter.ParameterSets['ExistingCertificate'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ExistingCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ExistingCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExistingCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExistingCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ExistingCertificatePrivateKeyFile' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['ExistingCertificatePrivateKeyFile']
			$parameter.Name | Should -Be 'ExistingCertificatePrivateKeyFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExistingCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'ExistingCertificate'
			$parameter.ParameterSets['ExistingCertificate'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ExistingCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ExistingCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExistingCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExistingCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CertificateName' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['CertificateName']
			$parameter.Name | Should -Be 'CertificateName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'NewCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'NewCertificate'
			$parameter.ParameterSets['NewCertificate'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['NewCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CertificateExpirationYears' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['CertificateExpirationYears']
			$parameter.Name | Should -Be 'CertificateExpirationYears'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'NewCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'NewCertificate'
			$parameter.ParameterSets['NewCertificate'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['NewCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter NewCertificateFile' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['NewCertificateFile']
			$parameter.Name | Should -Be 'NewCertificateFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'NewCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'NewCertificate'
			$parameter.ParameterSets['NewCertificate'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['NewCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter NewCertificatePrivateKeyFile' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['NewCertificatePrivateKeyFile']
			$parameter.Name | Should -Be 'NewCertificatePrivateKeyFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'NewCertificate'
			$parameter.ParameterSets.Keys | Should -Contain 'NewCertificate'
			$parameter.ParameterSets['NewCertificate'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].Position | Should -Be -2147483648
			$parameter.ParameterSets['NewCertificate'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['NewCertificate'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CertificatePassword' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['CertificatePassword']
			$parameter.Name | Should -Be 'CertificatePassword'
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
		It 'Should have the expected parameter Force' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['Force']
			$parameter.Name | Should -Be 'Force'
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
		It 'Should have the expected parameter AddAppRegistrationToWifConfig' {
			$parameter = (Get-Command New-D365EntraIntegration).Parameters['AddAppRegistrationToWifConfig']
			$parameter.Name | Should -Be 'AddAppRegistrationToWifConfig'
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
	}
	
	Describe "Testing parameterset NewCertificate" {
		<#
		NewCertificate -ClientId
		NewCertificate -ClientId -CertificateName -CertificateExpirationYears -NewCertificateFile -NewCertificatePrivateKeyFile -CertificatePassword -Force -AddAppRegistrationToWifConfig
		#>
	}
 	Describe "Testing parameterset ExistingCertificate" {
		<#
		ExistingCertificate -ClientId -ExistingCertificateFile
		ExistingCertificate -ClientId -ExistingCertificateFile -ExistingCertificatePrivateKeyFile -CertificatePassword -Force -AddAppRegistrationToWifConfig
		#>
	}

}