Describe "Import-D365AadUser Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Import-D365AadUser).ParameterSets.Name | Should -Be 'UserListImport', 'GroupNameImport', 'GroupIdImport'
		}
		
		It 'Should have the expected parameter AadGroupName' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['AadGroupName']
			$parameter.Name | Should -Be 'AadGroupName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'GroupNameImport'
			$parameter.ParameterSets.Keys | Should -Contain 'GroupNameImport'
			$parameter.ParameterSets['GroupNameImport'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['GroupNameImport'].Position | Should -Be 1
			$parameter.ParameterSets['GroupNameImport'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['GroupNameImport'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['GroupNameImport'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Users' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['Users']
			$parameter.Name | Should -Be 'Users'
			$parameter.ParameterType.ToString() | Should -Be System.String[]
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'UserListImport'
			$parameter.ParameterSets.Keys | Should -Contain 'UserListImport'
			$parameter.ParameterSets['UserListImport'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['UserListImport'].Position | Should -Be 1
			$parameter.ParameterSets['UserListImport'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['UserListImport'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['UserListImport'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter StartupCompany' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['StartupCompany']
			$parameter.Name | Should -Be 'StartupCompany'
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
		It 'Should have the expected parameter DatabaseServer' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['DatabaseServer']
			$parameter.Name | Should -Be 'DatabaseServer'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 3
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseName' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['DatabaseName']
			$parameter.Name | Should -Be 'DatabaseName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 4
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlUser' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['SqlUser']
			$parameter.Name | Should -Be 'SqlUser'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 5
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlPwd' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['SqlPwd']
			$parameter.Name | Should -Be 'SqlPwd'
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
		It 'Should have the expected parameter IdPrefix' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['IdPrefix']
			$parameter.Name | Should -Be 'IdPrefix'
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
		It 'Should have the expected parameter NameSuffix' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['NameSuffix']
			$parameter.Name | Should -Be 'NameSuffix'
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
		It 'Should have the expected parameter IdValue' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['IdValue']
			$parameter.Name | Should -Be 'IdValue'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 9
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter NameValue' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['NameValue']
			$parameter.Name | Should -Be 'NameValue'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 10
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AzureAdCredential' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['AzureAdCredential']
			$parameter.Name | Should -Be 'AzureAdCredential'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.PSCredential
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be 11
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SkipAzureAd' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['SkipAzureAd']
			$parameter.Name | Should -Be 'SkipAzureAd'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'UserListImport'
			$parameter.ParameterSets.Keys | Should -Contain 'UserListImport'
			$parameter.ParameterSets['UserListImport'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['UserListImport'].Position | Should -Be 12
			$parameter.ParameterSets['UserListImport'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['UserListImport'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['UserListImport'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ForceExactAadGroupName' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['ForceExactAadGroupName']
			$parameter.Name | Should -Be 'ForceExactAadGroupName'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'GroupNameImport'
			$parameter.ParameterSets.Keys | Should -Contain 'GroupNameImport'
			$parameter.ParameterSets['GroupNameImport'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['GroupNameImport'].Position | Should -Be 13
			$parameter.ParameterSets['GroupNameImport'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['GroupNameImport'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['GroupNameImport'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter AadGroupId' {
			$parameter = (Get-Command Import-D365AadUser).Parameters['AadGroupId']
			$parameter.Name | Should -Be 'AadGroupId'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'GroupIdImport'
			$parameter.ParameterSets.Keys | Should -Contain 'GroupIdImport'
			$parameter.ParameterSets['GroupIdImport'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['GroupIdImport'].Position | Should -Be 14
			$parameter.ParameterSets['GroupIdImport'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['GroupIdImport'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['GroupIdImport'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset UserListImport" {
		<#
		UserListImport -Users
		UserListImport -Users -StartupCompany -DatabaseServer -DatabaseName -SqlUser -SqlPwd -IdPrefix -NameSuffix -IdValue -NameValue -AzureAdCredential -SkipAzureAd
		#>
	}
 	Describe "Testing parameterset GroupNameImport" {
		<#
		GroupNameImport -AadGroupName
		GroupNameImport -AadGroupName -StartupCompany -DatabaseServer -DatabaseName -SqlUser -SqlPwd -IdPrefix -NameSuffix -IdValue -NameValue -AzureAdCredential -ForceExactAadGroupName
		#>
	}
 	Describe "Testing parameterset GroupIdImport" {
		<#
		GroupIdImport -AadGroupId
		GroupIdImport -StartupCompany -DatabaseServer -DatabaseName -SqlUser -SqlPwd -IdPrefix -NameSuffix -IdValue -NameValue -AzureAdCredential -AadGroupId
		#>
	}

}