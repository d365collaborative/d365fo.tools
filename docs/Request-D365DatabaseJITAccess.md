---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Request-D365DatabaseJITAccess

## SYNOPSIS
Request just in time (JIT) database access for a unified development environment (UDE)

## SYNTAX

### ByInteractiveLogin (Default)
```
Request-D365DatabaseJITAccess -Url <String> -Tenant <String> [-ClientIPAddress <String>] [-Role <String>]
 [-Reason <String>] [-SQLServerManagementStudioPath <String>] [-RawOutput] [-OutputAsJson] [-EnableException]
 [<CommonParameters>]
```

### ByClientSecretAsSecureString
```
Request-D365DatabaseJITAccess -Url <String> -ClientId <String> -ClientSecretAsSecureString <SecureString>
 -Tenant <String> [-ClientIPAddress <String>] [-Role <String>] [-Reason <String>]
 [-SQLServerManagementStudioPath <String>] [-RawOutput] [-OutputAsJson] [-EnableException] [<CommonParameters>]
```

### ByClientSecretAsPlainString
```
Request-D365DatabaseJITAccess -Url <String> -ClientId <String> -ClientSecretAsPlainString <String>
 -Tenant <String> [-ClientIPAddress <String>] [-Role <String>] [-Reason <String>]
 [-SQLServerManagementStudioPath <String>] [-RawOutput] [-OutputAsJson] [-EnableException] [<CommonParameters>]
```

### ByCredential
```
Request-D365DatabaseJITAccess -Url <String> -Credential <PSCredential> -Tenant <String>
 [-ClientIPAddress <String>] [-Role <String>] [-Reason <String>] [-SQLServerManagementStudioPath <String>]
 [-RawOutput] [-OutputAsJson] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Utilize the D365FO Power Platform OData API to request just in time access (JIT) to a UDE database

This will allow you to get temporary database credentials for connecting to the database directly

If no credentials are provided (ClientId/ClientSecret or Credential), the function will automatically use interactive authentication via Azure PowerShell.

## EXAMPLES

### EXAMPLE 1
```
Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111"
```

This will request JIT database access for the D365FO environment using interactive authentication.
It will prompt you to sign in with your Azure AD credentials if not already signed in.
It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".

### EXAMPLE 2
```
Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will request JIT database access for the D365FO environment.
It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

### EXAMPLE 3
```
Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -ClientIPAddress "192.168.1.100" -Role "Writer" -Reason "Development work"
```

This will request JIT database access for the D365FO environment with Writer privileges.
It will use the client IP address "192.168.1.100", role "Writer", and reason "Development work".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

### EXAMPLE 4
```
Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -OutputAsJson
```

This will request JIT database access for the D365FO environment and display the result as json.
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

### EXAMPLE 5
```
$clientSecretSecure = Read-Host -AsSecureString "Enter the Client Secret"
```

PS C:\\\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsSecureString $clientSecretSecure

This will prompt the user to enter the client secret securely (the input will be masked).
Then it will request JIT database access for the D365FO environment using the secure string for authentication.
It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the client secret provided through the secure prompt.

### EXAMPLE 6
```
$credential = Get-Credential -UserName "dea8d7a9-1602-4429-b138-111111111111" -Message "Enter the Client Secret"
```

PS C:\\\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Credential $credential

This will prompt the user to enter the client secret through a secure credential dialog (using the ClientId as the username).
Then it will request JIT database access for the D365FO environment using the credential for authentication.
It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the client id and secret provided through the credential object.

### EXAMPLE 7
```
Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -SQLServerManagementStudioPath "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe"
```

This will request JIT database access for the D365FO environment using interactive authentication.
It will open SQL Server Management Studio and connect to the database using the obtained credentials.
It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".

## PARAMETERS

### -Url
URL / URI for the D365FO Power Platform environment that provides the JIT access API.

Note: This is not the URL of the D365FO environment itself (aka the Finance and Operations URL).
Instead, it is the URL of the Power Platform environment (aka the Environment URL) that the D365FO environment is integrated with.

For example: "https://operations-acme-uat.crm4.dynamics.com/"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The ClientId obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: ByClientSecretAsSecureString, ByClientSecretAsPlainString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecretAsPlainString
The ClientSecret obtained from the Azure Portal when you created a Registered Application

This is the plain text version of the ClientSecret parameter.

Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.

```yaml
Type: String
Parameter Sets: ByClientSecretAsPlainString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecretAsSecureString
The ClientSecret obtained from the Azure Portal when you created a Registered Application

This is the secure string version of the ClientSecret parameter.

Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.

```yaml
Type: SecureString
Parameter Sets: ByClientSecretAsSecureString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The Credential object containing Username (ClientId) and Password (ClientSecret)

The Username will be used as ClientId
The Password will be used as ClientSecret

Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.

```yaml
Type: PSCredential
Parameter Sets: ByCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientIPAddress
The IP address of the client that needs database access

Default value is "127.0.0.1" which will be replaced with the public IP address of the client as determined by querying "https://icanhazip.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 127.0.0.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
The database role to assign to the JIT access

Valid options are "Reader" and "Writer"

Default value is "Reader"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Reader
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reason
The reason for requesting JIT database access

Default value is "Administrative access via d365fo.tools"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Administrative access via d365fo.tools
Accept pipeline input: False
Accept wildcard characters: False
```

### -SQLServerManagementStudioPath
The full path to the SQL Server Management Studio executable (ssms.exe)

If provided, the function will automatically open SQL Server Management Studio and connect to the database using the obtained credentials.

Example: "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe"

Note: Since version 18, SQL Server Management Studio does no longer allow providing the password directly in the command line.
The password will be copied to clipboard instead for easy pasting.
It will be cleared from clipboard after 60 seconds.

Note: After SQL Server Management Studio has been started this way, it will display a "Connect to the following server?" warning dialog.
Confirm it with "Yes".
Next, because of the missing password, a "Connect to server" error dialog will be shown.
Confirm it with "OK".
Finally, a "Connect to server" form will be shown where the password can be pasted and the connection be established with the "Connect" button.
Answering "No" on the first warning dialog will take you directly to the "Connect to server" form, but the database information will not be pre-filled.

Note: The connection may fail at first because it takes some time until the client's IP address is whitelisted in the Azure SQL Database firewall rules.
If that happens, just try again after a minute or so.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
Instructs the cmdlet to include the outer structure of the response received from the endpoint

The output will still be a PSCustomObject

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputAsJson
Instructs the cmdlet to convert the output to a Json string

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts
Usually this parameter is not used directly, but via the Enable-D365Exception cmdlet
See https://github.com/d365collaborative/d365fo.tools/wiki/Exception-handling#what-does-the--enableexception-parameter-do for further information

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
Tags: JIT, Database, Access, UDE, OData, RestApi

Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
