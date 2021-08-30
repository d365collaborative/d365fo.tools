So you are working on a project where you have to export/import a bacpac file from any NON-PROD environment.

You might have to login to several different servers / machines to ensure that the different D365 services are stopped / shutdown before continuing with your planned work.

Look no further!

We assume:
* That you already did run the `Install-Module -Name d365fo.tools` on the machine / server you will be using for this. 
* That you will be running this from 1 of the AOS machines / Servers in the Tier 2 environment.

1. Start PowerShell (Start Menu - type powershell and click enter when you see the icon marked)
2. Run `Import-Module d365fo.tools`


**Tier-1 examples**
Run `Get-D365Environment -All`

*This will display the current status of all the D365 services on the machine*

Run `Stop-D365Environment -All`

*This stop all the D365 services on the machine. It will list the current status for all services*

Run `Start-D365Environment -All`

*This start all the D365 services on the machine. It will list the current status for all services*

**Tier-2 examples**
Run `Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All`

*This will display the current status of all the D365 services across all the supplied machines.*

Run `Stop-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All`

*This stop all the D365 services across all the supplied machines. It will list the current status for all services*

Run `Start-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All`

*This start all the D365 services across all the supplied machines. It will list the current status for all services*