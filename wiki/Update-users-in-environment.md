So you just moved your **GOLDEN** / **CONFIG** from either a local VM (**onebox**) or an Azure hosted environment to a MS hosted environment (**non-prod**)?

You just restored your **PROD** / **UAT** environment to a Azure hosted or a local VM (onebox)?

Now you need to grant access (back) to your users in the restored environment and you want to do it without all the mouse clicking?

Look no further!

We assume:
* That you already did run the `Install-Modele -Name d365fo.tools` on the machine / server you will be using for this.
* That the database has been restored and you are sitting on machine / server that either runs the SQL Server (Tier1, Azure / onebox) or a machine / server inside the same network environment as the Azure DB (Tier2 - MS hosted). 

For MS hosted Tier2 environments you need have the sql username and password ready, this is found on LCS under the implementation project and the details page for the desired environment. For the other environments you don't - if you run PowerShell with "Run As Administrator"

1. Start PowerShell (Start Menu - type powershell and click enter when you see the icon marked)
2. Run `Import-Module d365fo.tools`
3. Run `Set-D365Admin "insertyouremailaddress"`
   - Remember that the e-mail address needs to be a valid Azure Active Directory e-mail
   - E.g. `Set-D365Admin "allen@contoso.com"`
4. Wait for the command to finish
5. Run `Update-D365User -Email "%youremaildomain%"`
   - Fill in the domain of the users that you want to update and give back access to the specific environment
   - E.g. `Update-D365User -Email "%contoso.com%"`