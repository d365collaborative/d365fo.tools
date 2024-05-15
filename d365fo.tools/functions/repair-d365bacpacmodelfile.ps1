
<#
    .SYNOPSIS
        Repair a bacpac model file
        
    .DESCRIPTION
        As the backend of the Azure SQL infrastructure keeps evolving, the bacpac file can contain invalid instructions while we are trying to import into a local SQL Server installation on a Tier1 environment
        
    .PARAMETER Path
        Path to the bacpac model file that you want to work against
        
    .PARAMETER OutputPath
        Path to where the repaired model file should be placed
        
        The default value is going to create a file next to the Path (input) file, with the '-edited' name appended to it

    .PARAMETER PathRepairSimple
        Path to the json file, that contains all the instructions to be executed in the "Simple" section
        
        The default json file is part of the module, and can be located with the below command:
        explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)[0].Path -Parent) -ChildPath "internal\misc")
        - Look for the "RepairBacpac.Simple.json" file
        
        Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Simple.json
        
        Simple means, that we can remove complex elements, based on some basic logic. E.g.
        
        {
        "Search": "*<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*",
        "End": "*</Element>*"
        }
        
        "*<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*" can identify below, and together with "*</Element>*" - we know when to stop.
        
        <Element Type="SqlPermissionStatement" Name="[Grant.Delete.Object].[ms_db_configreader].[dbo].[dbo].[AutotuneBase]">
        <Property Name="Permission" Value="4" />
        <Relationship Name="Grantee">
        <Entry>
        <References Name="[ms_db_configreader]" />
        </Entry>
        </Relationship>
        <Relationship Name="Grantor">
        <Entry>
        <References ExternalSource="BuiltIns" Name="[dbo]" />
        </Entry>
        </Relationship>
        <Relationship Name="SecuredObject">
        <Entry>
        <References Name="[dbo].[AutotuneBase]" />
        </Entry>
        </Relationship>
        </Element>
        
    .PARAMETER PathRepairQualifier
        Path to the json file, that contains all the instructions to be executed in the "Qualifier" section
        
        The default json file is part of the module, and can be located with the below command:
        explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)[0].Path -Parent) -ChildPath "internal\misc")
        - Look for the "RepairBacpac.Qualifier.json" file
        
        Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Qualifier.json
        
        Qualifier means, that we can remove complex elements, based on some basic logic. E.g.
        
        {
        "Search": "*<Element Type=\"SqlRoleMembership\">*",
        "Qualifier": "*<References Name=*ms_db_configwriter*",
        "End": "*</Element>*"
        }
        
        "*<Element Type=\"SqlRoleMembership\">*" can identify below, "*<References Name=*ms_db_configwriter*" qualifies that we are locating the correct one and together with "*</Element>*" - we know when to stop.
        
        <Element Type="SqlRoleMembership">
            <Relationship Name="Member">
                <Entry>
                    <References Name="[ms_db_configwriter]" />
                </Entry>
            </Relationship>
            <Relationship Name="Role">
                <Entry>
                    <References ExternalSource="BuiltIns" Name="[db_ddladmin]" />
                </Entry>
            </Relationship>
        </Element>
        
    .PARAMETER PathRepairReplace
        Path to the json file, that contains all the instructions to be executed in the "Replace" section
        
        The default json file is part of the module, and can be located with the below command:
        explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)[0].Path -Parent) -ChildPath "internal\misc")
        - Look for the "RepairBacpac.Replace.json" file
        
        Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Replace.json
        
        Replace means, that we can replace/remove strings, based on some basic logic. E.g.
        
        {
        "Search": "<Property Name=\"AutoDrop\" Value=\"True\" />",
        "Replace": ""
        }
        
        "<Property Name=\"AutoDrop\" Value=\"True\" />" can identify below, and "" is the value we want to replace with it.
        
        <Property Name="AutoDrop" Value="True" />
        
    .PARAMETER KeepFiles
        Instruct the cmdlet to keep the files from the repair process
        
        The files are very large, so only use this as a way to analyze why your model file didn't end up in the desired state
        
        Use it while you evolve/develop your instructions, but remove it from ANY full automation scripts
        
    .EXAMPLE
        An example
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        Author: Florian Hopfner (@FH-Inway)

        Json files has to be an array directly in the root of the file. All " (double quotes) has to be escaped with \" - otherwise it will not work as intended.
        
        This cmdlet is inspired by the work of "Brad Bateman" (github: @batetech)
        
        His github profile can be found here:
        https://github.com/batetech
        
        Florian Hopfner did a gist implementation, which has been used as the foundation for this implementation
        
        The original gist is: https://gist.github.com/FH-Inway/f485c720b43b72bffaca5fb6c094707e
        
        His github profile can be found here:
        https://github.com/FH-Inway
#>
function Repair-D365BacpacModelFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $OutputPath,

        [string] $PathRepairSimple = "$script:ModuleRoot\internal\misc\RepairBacpac.Simple.json",

        [string] $PathRepairQualifier = "$script:ModuleRoot\internal\misc\RepairBacpac.Qualifier.json",

        [string] $PathRepairReplace = "$script:ModuleRoot\internal\misc\RepairBacpac.Replace.json",

        [switch] $KeepFiles
    )

    if ([string]::IsNullOrEmpty($OutputPath)) {
        $OutputPath = $Path.Replace([System.IO.Path]::GetExtension($path), "-edited$([System.IO.Path]::GetExtension($path))")
    }

    # Load all the simple delete instructions
    $arrSimple = Get-Content -Path $PathRepairSimple -Raw | ConvertFrom-Json
    
    # Create a local working directory, in the temporary directory
    $directoryObj = New-Item -Path "$([System.IO.Path]::GetTempPath())$((New-Guid).Guid)" -ItemType Directory -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    
    # Path to help us keep track of the file and what changes have been made - troubleshooting is easier with this one
    $localInput = Join-Path -Path $directoryObj.FullName -ChildPath "raw.simple.input.xml"

    # Clone input file to the local temporary file
    Copy-Item -Path $Path -Destination $localInput -Force

    for ($i = 0; $i -lt $arrSimple.Count; $i++) {
        $forInput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.simple.input.xml"
        $forOutput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.simple.output.xml"

        Copy-Item -Path $localInput -Destination $forInput -Force
        Repair-BacpacModelSimpleRemove -Path $forInput -OutputPath $forOutput -Search $arrSimple[$i].Search -End $arrSimple[$i].End

        $localInput = $forOutput
    }

    if ($arrSimple.Count -lt 1) {
        $forOutput = $localInput
    }

    $arrQualifier = Get-Content -Path $PathRepairQualifier -Raw | ConvertFrom-Json

    # Path to help us keep track of the file and what changes have been made - troubleshooting is easier with this one
    $localInput = Join-Path -Path $directoryObj.FullName -ChildPath "raw.qualifier.input.xml"

    # Clone input file to the local temporary file
    Copy-Item -Path $forOutput -Destination $localInput -Force

    if (-not $KeepFiles) {
        Get-ChildItem -Path "$($directoryObj.FullName)\*.simple.*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    for ($i = 0; $i -lt $arrQualifier.Count; $i++) {
        $forInput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.qualifier.input.xml"
        $forOutput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.qualifier.output.xml"

        Copy-Item -Path $localInput -Destination $forInput -Force
        Repair-BacpacModelQualifier -Path $forInput -OutputPath $forOutput -Search $arrQualifier[$i].Search -Qualifier $arrQualifier[$i].Qualifier -End $arrQualifier[$i].End

        $localInput = $forOutput
    }

    if ($arrQualifier.Count -lt 1) {
        $forOutput = $localInput
    }

    $arrReplace = Get-Content -Path $PathRepairReplace -Raw | ConvertFrom-Json

    # Path to help us keep track of the file and what changes have been made - troubleshooting is easier with this one
    $localInput = Join-Path -Path $directoryObj.FullName -ChildPath "raw.replace.input.xml"

    # Clone input file to the local temporary file
    Copy-Item -Path $forOutput -Destination $localInput -Force

    if (-not $KeepFiles) {
        Get-ChildItem -Path "$($directoryObj.FullName)\*.qualifier.*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    for ($i = 0; $i -lt $arrReplace.Count; $i++) {
        $forInput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.replace.input.xml"
        $forOutput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.replace.output.xml"

        Copy-Item -Path $localInput -Destination $forInput -Force
        Repair-BacpacModelReplace -Path $forInput -OutputPath $forOutput -Search $arrReplace[$i].Search -Replace $arrReplace[$i].Replace

        $localInput = $forOutput
    }

    Copy-Item -Path $forOutput -Destination $OutputPath -Force

    if (-not $KeepFiles) {
        Get-ChildItem -Path "$($directoryObj.FullName)\*.replace.*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}