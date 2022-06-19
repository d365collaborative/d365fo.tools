Describe "New-D365Bacpac Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command New-D365Bacpac).ParameterSets.Name | Should -Be 'ExportTier2', 'ExportTier1'
		}
		
		It 'Should have the expected parameter ExportModeTier1' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['ExportModeTier1']
			$parameter.Name | Should -Be 'ExportModeTier1'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExportTier1'
			$parameter.ParameterSets.Keys | Should -Contain 'ExportTier1'
			$parameter.ParameterSets['ExportTier1'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ExportTier1'].Position | Should -Be 0
			$parameter.ParameterSets['ExportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExportTier1'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ExportModeTier2' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['ExportModeTier2']
			$parameter.Name | Should -Be 'ExportModeTier2'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExportTier2'
			$parameter.ParameterSets.Keys | Should -Contain 'ExportTier2'
			$parameter.ParameterSets['ExportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ExportTier2'].Position | Should -Be 0
			$parameter.ParameterSets['ExportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExportTier2'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExportTier2'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseServer' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['DatabaseServer']
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
			$parameter = (Get-Command New-D365Bacpac).Parameters['DatabaseName']
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
			$parameter = (Get-Command New-D365Bacpac).Parameters['SqlUser']
			$parameter.Name | Should -Be 'SqlUser'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExportTier2', '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain 'ExportTier2'
			$parameter.ParameterSets['ExportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ExportTier2'].Position | Should -Be 3
			$parameter.ParameterSets['ExportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ExportTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 3
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlPwd' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['SqlPwd']
			$parameter.Name | Should -Be 'SqlPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExportTier2', '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain 'ExportTier2'
			$parameter.ParameterSets['ExportTier2'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['ExportTier2'].Position | Should -Be 4
			$parameter.ParameterSets['ExportTier2'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExportTier2'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['ExportTier2'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 4
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter BackupDirectory' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['BackupDirectory']
			$parameter.Name | Should -Be 'BackupDirectory'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'ExportTier1'
			$parameter.ParameterSets.Keys | Should -Contain 'ExportTier1'
			$parameter.ParameterSets['ExportTier1'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['ExportTier1'].Position | Should -Be 5
			$parameter.ParameterSets['ExportTier1'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['ExportTier1'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['ExportTier1'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter NewDatabaseName' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['NewDatabaseName']
			$parameter.Name | Should -Be 'NewDatabaseName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 6
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter BacpacFile' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['BacpacFile']
			$parameter.Name | Should -Be 'BacpacFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 7
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter CustomSqlFile' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['CustomSqlFile']
			$parameter.Name | Should -Be 'CustomSqlFile'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 8
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DiagnosticFile' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['DiagnosticFile']
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
		It 'Should have the expected parameter ExportOnly' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['ExportOnly']
			$parameter.Name | Should -Be 'ExportOnly'
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
		It 'Should have the expected parameter MaxParallelism' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['MaxParallelism']
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
		It 'Should have the expected parameter ShowOriginalProgress' {
			$parameter = (Get-Command New-D365Bacpac).Parameters['ShowOriginalProgress']
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
			$parameter = (Get-Command New-D365Bacpac).Parameters['OutputCommandOnly']
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
			$parameter = (Get-Command New-D365Bacpac).Parameters['EnableException']
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
	
	Describe "Testing parameterset ExportTier2" {
		<#
		ExportTier2 -ExportModeTier2 -SqlUser -SqlPwd
		ExportTier2 -ExportModeTier2 -DatabaseServer -DatabaseName -SqlUser -SqlPwd -NewDatabaseName -BacpacFile -CustomSqlFile -DiagnosticFile -ExportOnly -MaxParallelism -ShowOriginalProgress -OutputCommandOnly -EnableException
		#>
	}
 	Describe "Testing parameterset ExportTier1" {
		<#
		ExportTier1 -ExportModeTier1
		ExportTier1 -ExportModeTier1 -DatabaseServer -DatabaseName -SqlUser -SqlPwd -BackupDirectory -NewDatabaseName -BacpacFile -CustomSqlFile -DiagnosticFile -ExportOnly -MaxParallelism -ShowOriginalProgress -OutputCommandOnly -EnableException
		#>
	}

}