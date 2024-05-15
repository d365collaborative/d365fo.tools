
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
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the file specified in the OutputPath if it already exists

    .EXAMPLE
        PS C:\> Repair-D365BacpacModelFile -Path C:\Temp\INOX\Bacpac\Base.xml -PathRepairSimple '' -PathRepairQualifier '' -PathRepairReplace 'C:\Temp\RepairBacpac.Replace.Custom.json'
        
        This will only process the Replace section, as the other repair paths are empty - indicating to skip them
        
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

        [switch] $KeepFiles,

        [switch] $Force

    )
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        if ([string]::IsNullOrEmpty($OutputPath)) {
            $OutputPath = $Path.Replace([System.IO.Path]::GetExtension($path), "-edited$([System.IO.Path]::GetExtension($path))")
        }

        if (-not $Force) {
            if (-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or set the <c='em'>Force</c> parameter to overwrite the file."
                Stop-PSFFunction -Message "Stopping because output path was already present."
                return
            }
        }

        if (Test-PSFFunctionInterrupt) { return }
    }
    
    end {
        if (Test-PSFFunctionInterrupt) { return }

        # Create a local working directory, in the temporary directory
        $directoryObj = New-Item -Path "$([System.IO.Path]::GetTempPath())$((New-Guid).Guid)" -ItemType Directory -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    
        if ($KeepFiles) {
            Write-PSFMessage -Level Host -Message "The working directory used for this repair is:`r`n<c='em'>$($directoryObj.FullName)</c>`r`n - Please only use the KeepFiles when needed."
        }

        # Path to help us keep track of the file and what changes have been made - troubleshooting is easier with this one
        $localInput = Join-Path -Path $directoryObj.FullName -ChildPath "raw.simple&replace.input.xml"
        $forOutput = Join-Path -Path $directoryObj.FullName -ChildPath "0.simple&replace.output.xml"

        # Clone input file to the local temporary file
        Copy-Item -Path $Path -Destination $localInput -Force

        $arrSimple = @()
        if (-not [string]::IsNullOrEmpty($PathRepairSimple)) {
            # Load all the simple delete instructions
            $arrSimple = Get-Content -Path $PathRepairSimple -Raw | ConvertFrom-Json
        }

        $arrReplace = @()
        if (-not [string]::IsNullOrEmpty($PathRepairReplace)) {
            # Load all the replace instructions
            $arrReplace = Get-Content -Path $PathRepairReplace -Raw | ConvertFrom-Json
        }

        Repair-BacpacModelSimpleAndReplace -Path $localInput -OutputPath $forOutput -RemoveInstructions $arrSimple -ReplaceInstructions $arrReplace

        $arrQualifier = @()
        if (-not [string]::IsNullOrEmpty($PathRepairQualifier)) {
            # Load all the qualification delete instructions
            $arrQualifier = Get-Content -Path $PathRepairQualifier -Raw | ConvertFrom-Json
        }

        # Path to help us keep track of the file and what changes have been made - troubleshooting is easier with this one
        $localInput = Join-Path -Path $directoryObj.FullName -ChildPath "raw.qualifier.input.xml"

        # Clone input file to the local temporary file
        Copy-Item -Path $forOutput -Destination $localInput -Force

        if (-not $KeepFiles) {
            Get-ChildItem -Path "$($directoryObj.FullName)\*.simple&replace.*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
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

        Copy-Item -Path $forOutput -Destination $OutputPath -Force

        if (-not $KeepFiles) {
            Get-ChildItem -Path "$($directoryObj.FullName)\*.qualifier.*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
    }
}