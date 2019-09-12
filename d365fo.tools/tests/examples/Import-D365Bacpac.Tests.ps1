$commandName = "Import-D365Bacpac"
################################### New Example test ###################################

$exampleRaw = "Import-D365Bacpac -ImportModeTier1 -BacpacFile `"C:\temp\uat.bacpac`" -NewDatabaseName `"ImportedDatabase`""
#Remember to escape any variables names in the line above.
#Remember to you need to output $true to the pester test, otherwise is fails.
#; `$var -eq `$true

#Here you declare any variable(s) you need to complete the test.

$example = $exampleRaw -replace "`n.*" -replace "PS C:\\>"

Describe "Specific example testing for $commandName" {

It "Example - $example" {
# mock the tested command so we don't actually do anything
# because it can be unsafe and we don't have the environment setup
# (so the only thing we are testing is that the code is semantically
# correct and provides all the needed params)
Mock $commandName {
# I am returning true here,
# but some of the examples drill down to the returned object
# so in strict mode we would fail
$true
}
# here simply invoke the example
$result = Invoke-Expression $example
# and check that we got result from the mock
$result | Should -BeTrue
}
}
################################### New Example test ###################################

$exampleRaw = "Import-D365Bacpac -ImportModeTier2 -SqlUser `"sqladmin`" -SqlPwd `"XyzXyz`" -BacpacFile `"C:\temp\uat.bacpac`" -AxDeployExtUserPwd `"XxXx`" -AxDbAdminPwd `"XxXx`" -AxRuntimeUserPwd `"XxXx`" -AxMrRuntimeUserPwd `"XxXx`" -AxRetailRuntimeUserPwd `"XxXx`" -AxRetailDataSyncUserPwd `"XxXx`" -AxDbReadonlyUserPwd `"XxXx`" -NewDatabaseName `"ImportedDatabase`""
#Remember to escape any variables names in the line above.
#Remember to you need to output $true to the pester test, otherwise is fails.
#; `$var -eq `$true

#Here you declare any variable(s) you need to complete the test.

$example = $exampleRaw -replace "`n.*" -replace "PS C:\\>"

Describe "Specific example testing for $commandName" {

It "Example - $example" {
# mock the tested command so we don't actually do anything
# because it can be unsafe and we don't have the environment setup
# (so the only thing we are testing is that the code is semantically
# correct and provides all the needed params)
Mock $commandName {
# I am returning true here,
# but some of the examples drill down to the returned object
# so in strict mode we would fail
$true
}
# here simply invoke the example
$result = Invoke-Expression $example
# and check that we got result from the mock
$result | Should -BeTrue
}
}
################################### New Example test ###################################

$exampleRaw = "Import-D365Bacpac -ImportModeTier1 -BacpacFile `"C:\temp\uat.bacpac`" -NewDatabaseName `"ImportedDatabase`" -DiagnosticFile `"C:\temp\ImportLog.txt`""
#Remember to escape any variables names in the line above.
#Remember to you need to output $true to the pester test, otherwise is fails.
#; `$var -eq `$true

#Here you declare any variable(s) you need to complete the test.

$example = $exampleRaw -replace "`n.*" -replace "PS C:\\>"

Describe "Specific example testing for $commandName" {

It "Example - $example" {
# mock the tested command so we don't actually do anything
# because it can be unsafe and we don't have the environment setup
# (so the only thing we are testing is that the code is semantically
# correct and provides all the needed params)
Mock $commandName {
# I am returning true here,
# but some of the examples drill down to the returned object
# so in strict mode we would fail
$true
}
# here simply invoke the example
$result = Invoke-Expression $example
# and check that we got result from the mock
$result | Should -BeTrue
}
}
################################### Entire help loaded ###################################

<#


NAME
    Import-D365Bacpac
    
SYNOPSIS
    Import a bacpac file
    
    
SYNTAX
    Import-D365Bacpac [-ImportModeTier1] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>] 
    [[-SqlPwd] <String>] [-BacpacFile] <String> [-NewDatabaseName] <String> [[-CustomSqlFile] <String>] [-DiagnosticFil
    e <String>] [-ImportOnly] [-EnableException] [<CommonParameters>]
    
    Import-D365Bacpac [-ImportModeTier2] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [-SqlUser] <String> [-
    SqlPwd] <String> [-BacpacFile] <String> [-NewDatabaseName] <String> [[-AxDeployExtUserPwd] <String>] [[-AxDbAdminPw
    d] <String>] [[-AxRuntimeUserPwd] <String>] [[-AxMrRuntimeUserPwd] <String>] [[-AxRetailRuntimeUserPwd] <String>] [
    [-AxRetailDataSyncUserPwd] <String>] [[-AxDbReadonlyUserPwd] <String>] [[-CustomSqlFile] <String>] [-DiagnosticFile
     <String>] -ImportOnly [-EnableException] [<CommonParameters>]
    
    Import-D365Bacpac [-ImportModeTier2] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [-SqlUser] <String> [-
    SqlPwd] <String> [-BacpacFile] <String> [-NewDatabaseName] <String> [-AxDeployExtUserPwd] <String> [-AxDbAdminPwd] 
    <String> [-AxRuntimeUserPwd] <String> [-AxMrRuntimeUserPwd] <String> [-AxRetailRuntimeUserPwd] <String> [-AxRetailD
    ataSyncUserPwd] <String> [-AxDbReadonlyUserPwd] <String> [[-CustomSqlFile] <String>] [-DiagnosticFile <String>] [-E
    nableException] [<CommonParameters>]
    
    
DESCRIPTION
    Import a bacpac file to either a Tier1 or Tier2 environment
    

PARAMETERS
    -ImportModeTier1 [<SwitchParameter>]
        Switch to instruct the cmdlet that it will import into a Tier1 environment
        
        The cmdlet will expect to work against a SQL Server instance
        
        Required?                    true
        Position?                    1
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ImportModeTier2 [<SwitchParameter>]
        Switch to instruct the cmdlet that it will import into a Tier2 environment
        
        The cmdlet will expect to work against an Azure DB instance
        
        Required?                    true
        Position?                    1
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -DatabaseServer <String>
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
        Required?                    false
        Position?                    2
        Default value                $Script:DatabaseServer
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -DatabaseName <String>
        The name of the database
        
        Required?                    false
        Position?                    3
        Default value                $Script:DatabaseName
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -SqlUser <String>
        The login name for the SQL Server instance
        
        Required?                    false
        Position?                    4
        Default value                $Script:DatabaseUserName
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -SqlPwd <String>
        The password for the SQL Server user
        
        Required?                    false
        Position?                    5
        Default value                $Script:DatabaseUserPassword
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -BacpacFile <String>
        Path to the bacpac file you want to import into the database server
        
        Required?                    true
        Position?                    6
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -NewDatabaseName <String>
        Name of the new database that will be created while importing the bacpac file
        
        This will create a new database on the database server and import the content of the bacpac into
        
        Required?                    true
        Position?                    7
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxDeployExtUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    8
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxDbAdminPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    9
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxRuntimeUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    10
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxMrRuntimeUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    11
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxRetailRuntimeUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    12
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxRetailDataSyncUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    13
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AxDbReadonlyUserPwd <String>
        Password that is obtained from LCS
        
        Required?                    false
        Position?                    14
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CustomSqlFile <String>
        Path to the sql script file that you want the cmdlet to execute against your data after it has been imported
        
        Required?                    false
        Position?                    15
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -DiagnosticFile <String>
        Path to where you want the import to output a diagnostics file to assist you in troubleshooting the import
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ImportOnly [<SwitchParameter>]
        Switch to instruct the cmdlet to only import the bacpac into the new database
        
        The cmdlet will create a new database and import the content of the bacpac file into this
        
        Nothing else will be executed
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -EnableException [<SwitchParameter>]
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
NOTES
    
    
        Tags: Database, Bacpac, Tier1, Tier2, Golden Config, Config, Configuration
        
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase"
    
    PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase"
    
    This will instruct the cmdlet that the import will be working against a SQL Server instance.
    It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
    The next thing to do is to switch the active database out with the new one you just imported.
    "ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile "C:\temp\uat.bacpac" -Ax
    DeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUs
    erPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -AxDbReadonlyUserPwd "XxXx" -NewDatabaseName "ImportedDatabase"
    
    PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase" -SqlUser "sqladmin" -SqlPwd "XyzXyz"
    
    This will instruct the cmdlet that the import will be working against an Azure DB instance.
    It requires all relevant passwords from LCS for all the builtin user accounts used in a Tier 2 environment.
    It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
    The next thing to do is to switch the active database out with the new one you just imported.
    "ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase" -Dia
    gnosticFile "C:\temp\ImportLog.txt"
    
    This will instruct the cmdlet that the import will be working against a SQL Server instance.
    It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
    It will output a diagnostic file to "C:\temp\ImportLog.txt".
    
    
    
    
    
RELATED LINKS



#>
