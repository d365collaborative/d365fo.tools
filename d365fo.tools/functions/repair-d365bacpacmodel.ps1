function Repair-D365BacpacModel {
    [CmdletBinding()]
    param (
        [string] $Path,

        [string] $OutputPath,

        [string] $PathRepairSimple = "$script:ModuleRoot\internal\misc\RepairBacpac.Simple.json",

        [string] $PathRepairQualifier = "$script:ModuleRoot\internal\misc\RepairBacpac.Qualifier.json",

        [string] $PathRepairReplace = "$script:ModuleRoot\internal\misc\RepairBacpac.Replace.json"
    )

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

    for ($i = 0; $i -lt $arrReplace.Count; $i++) {
        $forInput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.replace.input.xml"
        $forOutput = Join-Path -Path $directoryObj.FullName -ChildPath "$i.replace.output.xml"

        Copy-Item -Path $localInput -Destination $forInput -Force
        Repair-BacpacModelReplace -Path $forInput -OutputPath $forOutput -Search $arrReplace[$i].Search -Replace $arrReplace[$i].Replace

        $localInput = $forOutput
    }

    Copy-Item -Path $forOutput -Destination $OutputPath -Force
}