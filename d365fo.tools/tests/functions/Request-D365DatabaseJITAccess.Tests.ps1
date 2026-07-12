Describe "Request-D365DatabaseJITAccess Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Request-D365DatabaseJITAccess).ParameterSets.Name | Should -Be 'ByInteractiveLogin', 'ByClientSecretAsSecureString', 'ByClientSecretAsPlainString', 'ByCredential'
		}
		
		It 'Should have the expected parameter Url' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['Url']
			$parameter.Name | Should -Be 'Url'
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
		It 'Should have the expected parameter ClientId' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['ClientId']
			$parameter.Name | Should -Be 'ClientId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ByClientSecretAsSecureString', 'ByClientSecretAsPlainString'
			$parameter.ParameterSets.Keys | Should -Contain 'ByClientSecretAsSecureString'
			$parameter.ParameterSets['ByClientSecretAsSecureString'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ByClientSecretAsSecureString'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ByClientSecretAsPlainString'
			$parameter.ParameterSets['ByClientSecretAsPlainString'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ByClientSecretAsPlainString'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ClientSecretAsPlainString' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['ClientSecretAsPlainString']
			$parameter.Name | Should -Be 'ClientSecretAsPlainString'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ByClientSecretAsPlainString'
			$parameter.ParameterSets.Keys | Should -Contain 'ByClientSecretAsPlainString'
			$parameter.ParameterSets['ByClientSecretAsPlainString'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ByClientSecretAsPlainString'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsPlainString'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ClientSecretAsSecureString' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['ClientSecretAsSecureString']
			$parameter.Name | Should -Be 'ClientSecretAsSecureString'
			$parameter.ParameterType.ToString() | Should -Be System.Security.SecureString
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ByClientSecretAsSecureString'
			$parameter.ParameterSets.Keys | Should -Contain 'ByClientSecretAsSecureString'
			$parameter.ParameterSets['ByClientSecretAsSecureString'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ByClientSecretAsSecureString'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ByClientSecretAsSecureString'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Credential' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['Credential']
			$parameter.Name | Should -Be 'Credential'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.PSCredential
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ByCredential'
			$parameter.ParameterSets.Keys | Should -Contain 'ByCredential'
			$parameter.ParameterSets['ByCredential'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ByCredential'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ByCredential'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ByCredential'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ByCredential'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Tenant' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['Tenant']
			$parameter.Name | Should -Be 'Tenant'
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
		It 'Should have the expected parameter ClientIPAddress' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['ClientIPAddress']
			$parameter.Name | Should -Be 'ClientIPAddress'
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
		It 'Should have the expected parameter Role' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['Role']
			$parameter.Name | Should -Be 'Role'
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
		It 'Should have the expected parameter Reason' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['Reason']
			$parameter.Name | Should -Be 'Reason'
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
		It 'Should have the expected parameter SQLServerManagementStudioPath' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['SQLServerManagementStudioPath']
			$parameter.Name | Should -Be 'SQLServerManagementStudioPath'
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
		It 'Should have the expected parameter RawOutput' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['RawOutput']
			$parameter.Name | Should -Be 'RawOutput'
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
		It 'Should have the expected parameter OutputAsJson' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['OutputAsJson']
			$parameter.Name | Should -Be 'OutputAsJson'
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
		It 'Should have the expected parameter EnableException' {
			$parameter = (Get-Command Request-D365DatabaseJITAccess).Parameters['EnableException']
			$parameter.Name | Should -Be 'EnableException'
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
	
	Describe "Testing parameterset ByInteractiveLogin" {
		<#
		ByInteractiveLogin -Url -Tenant
		ByInteractiveLogin -Url -Tenant -ClientIPAddress -Role -Reason -SQLServerManagementStudioPath -RawOutput -OutputAsJson -EnableException
		#>
	}
 	Describe "Testing parameterset ByClientSecretAsSecureString" {
		<#
		ByClientSecretAsSecureString -Url -ClientId -ClientSecretAsSecureString -Tenant
		ByClientSecretAsSecureString -Url -ClientId -ClientSecretAsSecureString -Tenant -ClientIPAddress -Role -Reason -SQLServerManagementStudioPath -RawOutput -OutputAsJson -EnableException
		#>
	}
 	Describe "Testing parameterset ByClientSecretAsPlainString" {
		<#
		ByClientSecretAsPlainString -Url -ClientId -ClientSecretAsPlainString -Tenant
		ByClientSecretAsPlainString -Url -ClientId -ClientSecretAsPlainString -Tenant -ClientIPAddress -Role -Reason -SQLServerManagementStudioPath -RawOutput -OutputAsJson -EnableException
		#>
	}
 	Describe "Testing parameterset ByCredential" {
		<#
		ByCredential -Url -Credential -Tenant
		ByCredential -Url -Credential -Tenant -ClientIPAddress -Role -Reason -SQLServerManagementStudioPath -RawOutput -OutputAsJson -EnableException
		#>
	}

}