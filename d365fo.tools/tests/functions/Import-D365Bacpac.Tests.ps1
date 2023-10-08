Describe "Import-D365Bacpac Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Import-D365Bacpac).ParameterSets.Name | Should -Be 'ImportTier1', 'ImportOnlyTier2', 'ImportTier2'
		}
		
		It 'Should have the expected parameter ImportModeTier1' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['ImportModeTier1']
			$parameter.Name | Should -Be 'ImportModeTier1'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportTier1'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier1'
			$parameter.ParameterSets['ImportTier1'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier1'].Position | Should -Be 0
			$parameter.ParameterSets['ImportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ImportModeTier2' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['ImportModeTier2']
			$parameter.Name | Should -Be 'ImportModeTier2'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 0
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 0
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseServer' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['DatabaseServer']
			$parameter.Name | Should -Be 'DatabaseServer'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 1
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseName' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['DatabaseName']
			$parameter.Name | Should -Be 'DatabaseName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 2
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlUser' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['SqlUser']
			$parameter.Name | Should -Be 'SqlUser'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier1', 'ImportTier2', '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 3
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier1'
			$parameter.ParameterSets['ImportTier1'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].Position | Should -Be 3
			$parameter.ParameterSets['ImportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 3
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 3
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['SqlPwd']
			$parameter.Name | Should -Be 'SqlPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier1', 'ImportTier2', '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 4
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier1'
			$parameter.ParameterSets['ImportTier1'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].Position | Should -Be 4
			$parameter.ParameterSets['ImportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 4
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 4
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter BacpacFile' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['BacpacFile']
			$parameter.Name | Should -Be 'BacpacFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 5
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter NewDatabaseName' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['NewDatabaseName']
			$parameter.Name | Should -Be 'NewDatabaseName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 6
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxDeployExtUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxDeployExtUserPwd']
			$parameter.Name | Should -Be 'AxDeployExtUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 7
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 7
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxDbAdminPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxDbAdminPwd']
			$parameter.Name | Should -Be 'AxDbAdminPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 8
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 8
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxRuntimeUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxRuntimeUserPwd']
			$parameter.Name | Should -Be 'AxRuntimeUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 9
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 9
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxMrRuntimeUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxMrRuntimeUserPwd']
			$parameter.Name | Should -Be 'AxMrRuntimeUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 10
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 10
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxRetailRuntimeUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxRetailRuntimeUserPwd']
			$parameter.Name | Should -Be 'AxRetailRuntimeUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 11
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 11
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxRetailDataSyncUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxRetailDataSyncUserPwd']
			$parameter.Name | Should -Be 'AxRetailDataSyncUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 12
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 12
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AxDbReadonlyUserPwd' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['AxDbReadonlyUserPwd']
			$parameter.Name | Should -Be 'AxDbReadonlyUserPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be 13
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier2'
			$parameter.ParameterSets['ImportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].Position | Should -Be 13
			$parameter.ParameterSets['ImportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ImportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CustomSqlFile' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['CustomSqlFile']
			$parameter.Name | Should -Be 'CustomSqlFile'
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
		It 'Should have the expected parameter ModelFile' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['ModelFile']
			$parameter.Name | Should -Be 'ModelFile'
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
		It 'Should have the expected parameter DiagnosticFile' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['DiagnosticFile']
			$parameter.Name | Should -Be 'DiagnosticFile'
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
		It 'Should have the expected parameter ImportOnly' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['ImportOnly']
			$parameter.Name | Should -Be 'ImportOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ImportOnlyTier2', 'ImportTier1'
			$parameter.ParameterSets.Keys | Should -Contain 'ImportOnlyTier2'
			$parameter.ParameterSets['ImportOnlyTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ImportOnlyTier2'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportOnlyTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'ImportTier1'
			$parameter.ParameterSets['ImportTier1'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].Position | Should -Be -2147483648
			$parameter.ParameterSets['ImportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ImportTier1'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter MaxParallelism' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['MaxParallelism']
			$parameter.Name | Should -Be 'MaxParallelism'
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
		It 'Should have the expected parameter LogPath' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['LogPath']
			$parameter.Name | Should -Be 'LogPath'
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
		It 'Should have the expected parameter ShowOriginalProgress' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['ShowOriginalProgress']
			$parameter.Name | Should -Be 'ShowOriginalProgress'
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
		It 'Should have the expected parameter OutputCommandOnly' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['OutputCommandOnly']
			$parameter.Name | Should -Be 'OutputCommandOnly'
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
			$parameter = (Get-Command Import-D365Bacpac).Parameters['EnableException']
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
		It 'Should have the expected parameter Properties' {
			$parameter = (Get-Command Import-D365Bacpac).Parameters['Properties']
			$parameter.Name | Should -Be 'Properties'
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
	}
	
	Describe "Testing parameterset ImportTier1" {
		<#
		ImportTier1 -ImportModeTier1 -BacpacFile -NewDatabaseName
		ImportTier1 -ImportModeTier1 -DatabaseServer -DatabaseName -SqlUser -SqlPwd -BacpacFile -NewDatabaseName -CustomSqlFile -ModelFile -DiagnosticFile -ImportOnly -MaxParallelism -LogPath -ShowOriginalProgress -OutputCommandOnly -EnableException -Properties
		#>
	}
 	Describe "Testing parameterset ImportOnlyTier2" {
		<#
		ImportOnlyTier2 -ImportModeTier2 -SqlUser -SqlPwd -BacpacFile -NewDatabaseName -ImportOnly
		ImportOnlyTier2 -ImportModeTier2 -DatabaseServer -DatabaseName -SqlUser -SqlPwd -BacpacFile -NewDatabaseName -AxDeployExtUserPwd -AxDbAdminPwd -AxRuntimeUserPwd -AxMrRuntimeUserPwd -AxRetailRuntimeUserPwd -AxRetailDataSyncUserPwd -AxDbReadonlyUserPwd -CustomSqlFile -ModelFile -DiagnosticFile -ImportOnly -MaxParallelism -LogPath -ShowOriginalProgress -OutputCommandOnly -EnableException -Properties
		#>
	}
 	Describe "Testing parameterset ImportTier2" {
		<#
		ImportTier2 -ImportModeTier2 -SqlUser -SqlPwd -BacpacFile -NewDatabaseName -AxDeployExtUserPwd -AxDbAdminPwd -AxRuntimeUserPwd -AxMrRuntimeUserPwd -AxRetailRuntimeUserPwd -AxRetailDataSyncUserPwd -AxDbReadonlyUserPwd
		ImportTier2 -ImportModeTier2 -DatabaseServer -DatabaseName -SqlUser -SqlPwd -BacpacFile -NewDatabaseName -AxDeployExtUserPwd -AxDbAdminPwd -AxRuntimeUserPwd -AxMrRuntimeUserPwd -AxRetailRuntimeUserPwd -AxRetailDataSyncUserPwd -AxDbReadonlyUserPwd -CustomSqlFile -ModelFile -DiagnosticFile -MaxParallelism -LogPath -ShowOriginalProgress -OutputCommandOnly -EnableException -Properties
		#>
	}

}