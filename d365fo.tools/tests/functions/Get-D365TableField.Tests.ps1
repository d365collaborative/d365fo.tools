Describe "Get-D365TableField Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Get-D365TableField).ParameterSets.Name | Should -Be 'Default', 'SearchByNameForce', 'TableName'
		}
		
		It 'Should have the expected parameter TableId' {
			$parameter = (Get-Command Get-D365TableField).Parameters['TableId']
			$parameter.Name | Should -Be 'TableId'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Default'].Position | Should -Be 1
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Get-D365TableField).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce', 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 1
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 2
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 2
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter FieldId' {
			$parameter = (Get-Command Get-D365TableField).Parameters['FieldId']
			$parameter.Name | Should -Be 'FieldId'
			$parameter.ParameterType.ToString() | Should -Be System.Int32
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 3
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 3
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $True
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseServer' {
			$parameter = (Get-Command Get-D365TableField).Parameters['DatabaseServer']
			$parameter.Name | Should -Be 'DatabaseServer'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce', 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 3
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 4
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 4
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter DatabaseName' {
			$parameter = (Get-Command Get-D365TableField).Parameters['DatabaseName']
			$parameter.Name | Should -Be 'DatabaseName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce', 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 4
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 5
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 5
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlUser' {
			$parameter = (Get-Command Get-D365TableField).Parameters['SqlUser']
			$parameter.Name | Should -Be 'SqlUser'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce', 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 5
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 6
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 6
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SqlPwd' {
			$parameter = (Get-Command Get-D365TableField).Parameters['SqlPwd']
			$parameter.Name | Should -Be 'SqlPwd'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce', 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 6
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be 7
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be 7
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter TableName' {
			$parameter = (Get-Command Get-D365TableField).Parameters['TableName']
			$parameter.Name | Should -Be 'TableName'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'TableName'
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['TableName'].Position | Should -Be 1
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter IncludeTableDetails' {
			$parameter = (Get-Command Get-D365TableField).Parameters['IncludeTableDetails']
			$parameter.Name | Should -Be 'IncludeTableDetails'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'TableName', 'Default'
			$parameter.ParameterSets.Keys | Should -Contain 'TableName'
			$parameter.ParameterSets['TableName'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['TableName'].Position | Should -Be -2147483648
			$parameter.ParameterSets['TableName'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['TableName'].ValueFromRemainingArguments | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Contain 'Default'
			$parameter.ParameterSets['Default'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Default'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Default'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Default'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SearchAcrossTables' {
			$parameter = (Get-Command Get-D365TableField).Parameters['SearchAcrossTables']
			$parameter.Name | Should -Be 'SearchAcrossTables'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'SearchByNameForce'
			$parameter.ParameterSets.Keys | Should -Contain 'SearchByNameForce'
			$parameter.ParameterSets['SearchByNameForce'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['SearchByNameForce'].Position | Should -Be 2
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['SearchByNameForce'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Default" {
		<#
		Default -TableId
		Default -TableId -Name -FieldId -DatabaseServer -DatabaseName -SqlUser -SqlPwd -IncludeTableDetails
		#>
	}
 	Describe "Testing parameterset SearchByNameForce" {
		<#
		SearchByNameForce -SearchAcrossTables
		SearchByNameForce -Name -DatabaseServer -DatabaseName -SqlUser -SqlPwd -SearchAcrossTables
		#>
	}
 	Describe "Testing parameterset TableName" {
		<#
		TableName -TableName
		TableName -Name -FieldId -DatabaseServer -DatabaseName -SqlUser -SqlPwd -TableName -IncludeTableDetails
		#>
	}

}