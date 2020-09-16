
<#
    .SYNOPSIS
        Analyze the compiler output log
        
    .DESCRIPTION
        Analyze the compiler output log and generate an excel file contain worksheets per type: Errors, Warnings, Tasks
        
        It could be a Visual Studio compiler log or it could be a Invoke-D365ModuleCompile log you want analyzed
        
    .PARAMETER Path
        Path to the compiler log file that you want to work against
        
        A BuildModelResult.log or a Dynamics.AX.*.xppc.log file will both work
        
    .PARAMETER Identifier
        Identifier used to name the error output when hitting parsing errors
        
    .PARAMETER OutputPath
        Path where you want the excel file (xlsx-file) saved to
        
    .PARAMETER SkipWarnings
        Instructs the cmdlet to skip warnings while analyzing the compiler output log file
        
    .PARAMETER SkipTasks
        Instructs the cmdlet to skip tasks while analyzing the compiler output log file
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
    .EXAMPLE
        PS C:\> Invoke-CompilerResultAnalyzer -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -Identifier "Custom" -OutputPath "C:\Temp\d365fo.tools\custom-CompilerResults.xslx" -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
        
        This will analyze the compiler log file and generate a compiler result excel file.
        
    .NOTES
        Tags: Compiler, Build, Errors, Warnings, Tasks
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Vilmos Kintera" (twitter: @DAXRunBase)
        
        All credits goes to him for showing how to extract these information
        
        His blog can be found here:
        https://www.daxrunbase.com/blog/
        
        The specific blog post that we based this cmdlet on can be found here:
        https://www.daxrunbase.com/2020/03/31/interpreting-compiler-results-in-d365fo-using-powershell/
        
        The github repository containing the original scrips can be found here:
        https://github.com/DAXRunBase/PowerShell-and-Azure
#>
function Invoke-CompilerResultAnalyzer {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidAssignmentToAutomaticVariable", "")]
    [CmdletBinding()]
    [OutputType('')]
    param (
        [string] $Path,

        [string] $Identifier,

        [string] $OutputPath,

        [switch] $SkipWarnings,

        [switch] $SkipTasks,

        [string] $PackageDirectory
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $PackageDirectory -Type Container)) { return }

    $positionRegex = '(?=\[\().*(?=\)\])'
    $positionSplitRegex = '(.*)(?=\[\().*(?:\)\]: )(.*)'

    $warningRegex = '(?:Compile Fatal|MetadataProvider|Metadata|Compile|Unspecified|Generation|ExternalReference|BestPractices) (Warning): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'
    $taskRegex = '(TaskListItem Information): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'
    $errorRegex = '(?:Compile Fatal|MetadataProvider|Metadata|Compile|Unspecified|Generation) (Error): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'

    $warningObjects = New-Object System.Collections.Generic.List[System.Object]
    $errorObjects = New-Object System.Collections.Generic.List[System.Object]
    $taskObjects = New-Object System.Collections.Generic.List[System.Object]
    
    if (-not $SkipWarnings) {
        Write-PSFMessage -Level Verbose -Message "Will analyze for warnings in the log file." -Target $SkipWarnings

        try {
            $warningText = Select-String -LiteralPath $Path -Pattern '(^.*) Warning: (.*)' | ForEach-Object { $_.Line }
            
            # Skip modules that do not have warnings
            if ($warningText) {
                Write-PSFMessage -Level Verbose -Message "Found warning lines in the log file."

                foreach ($line in $warningText) {
                    $lineLocal = $line
                        
                    # Remove positioning text in the format of "[(5,5),(5,39)]: " for methods
                    if ($lineLocal -match $positionRegex) {
                        Write-PSFMessage -Level Verbose -Message "Position notation was found in the warning line. Will remove it."

                        $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }
    
                    try {
                        Write-PSFMessage -Level Verbose -Message "Will split the warning line, and create result object."
                        # Regular expression matching to split line details into groups
                        $Matches = [regex]::split($lineLocal, $warningRegex)
                        $object = [PSCustomObject]@{
                            OutputType = $Matches[1].trim()
                            ObjectType = $Matches[2].trim()
                            Path       = $Matches[3].trim()
                            Text       = $Matches[4].trim()
                        }

                        $warningObjects.Add($object)
                    }
                    catch {
                        Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for warnings <</c><c='Red'>$line</c><c='Yellow'>></c>"
                    }
                }
            }
        }
        catch {
            Write-PSFMessage -Level Host "Error while processing warnings"
        }
    }

    if (-not $SkipTasks) {
        Write-PSFMessage -Level Verbose -Message "Will analyze for tasks in the log file." -Target $SkipTasks

        try {
            $taskText = Select-String -LiteralPath $Path -Pattern '(^.*)TaskListItem Information: (.*)' | ForEach-Object { $_.Line }

            # Skip modules that do not have tasks
            if ($taskText) {
                Write-PSFMessage -Level Verbose -Message "Found task lines in the log file."

                foreach ($line in $taskText) {
                    $lineLocal = $line
                        
                    # Remove positioning text in the format of "[(5,5),(5,39)]: " for methods
                    if ($lineLocal -match $positionRegex) {
                        Write-PSFMessage -Level Verbose -Message "Position notation was found in the task line. Will remove it."

                        $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }

                    # Remove TODO part
                    if ($lineLocal -match '(?:TODO :|TODO:|TODO)') {
                        Write-PSFMessage -Level Verbose -Message "TODO prefix string value was found in the line. Will remove it."

                        $lineReplaced = [regex]::Split($lineLocal, '(.*)(?:TODO :|TODO:|TODO)(.*)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }

                    try {
                        Write-PSFMessage -Level Verbose -Message "Will split the task line, and create result object."

                        # Regular expression matching to split line details into groups
                        $Matches = [regex]::split($lineLocal, $taskRegex)
                        $object = [PSCustomObject]@{
                            OutputType = $Matches[1].trim()
                            ObjectType = $Matches[2].trim()
                            Path       = $Matches[3].trim()
                            Text       = $Matches[4].trim()
                        }

                        $taskObjects.Add($object)
                    }
                    catch {
                        Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for tasks <</c><c='Red'>$line</c><c='Yellow'>></c>"
                    }
                }
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error during processing tasks"
        }
    }

    try {
        $errorText = Select-String -LiteralPath $Path -Pattern '(^.*) Error: (.*)' | ForEach-Object { $_.Line }

        # Skip modules that do not have errors
        if ($errorText) {
            foreach ($line in $errorText) {
                $lineLocal = $line

                # Remove positioning text in the format of "[(5,5),(5,39)]: " for methods
                if ($lineLocal -match $positionRegex) {
                    Write-PSFMessage -Level Verbose -Message "Position notation was found in the error line. Will remove it."

                    $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                    $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                }

                try {
                    Write-PSFMessage -Level Verbose -Message "Will split the error line, and create result object."

                    # Regular expression matching to split line details into groups
                    $Matches = [regex]::split($lineLocal, $errorRegex)
                    $object = [PSCustomObject]@{
                        ErrorType  = $Matches[1].trim()
                        ObjectType = $Matches[2].trim()
                        Path       = $Matches[3].trim()
                        Text       = $Matches[4].trim()
                    }

                    $errorObjects.Add($object)
                }
                catch {
                    Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for errors <</c><c='Red'>$line</c><c='Yellow'>></c>"
                }
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Error during processing errors"
    }

    Write-PSFMessage -Level Verbose -Message "Will start exporting the details to the excel file." -Target $OutputPath

    $errorObjects.ToArray() | Export-Excel -Path $OutputPath -WorksheetName "Errors" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

    $groupErrorTexts = $errorObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctErrorText"
    $groupErrorTexts | Export-Excel -Path $OutputPath -WorksheetName "Errors-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
        
    if (-not $SkipWarnings) {
        Write-PSFMessage -Level Verbose -Message "Building the warning details and saving them to the excel file." -Target $SkipWarnings
        
        $warningObjects.ToArray() | Export-Excel -Path $OutputPath -WorksheetName "Warnings" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

        $groupWarningTexts = $warningObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctWarningText"
        $groupWarningTexts | Export-Excel -Path $OutputPath -WorksheetName "Warnings-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
    }
    else {
        Remove-Worksheet -Path $OutputPath -WorksheetName "Warnings"
        Remove-Worksheet -Path $OutputPath -WorksheetName "Warnings-Summary"
    }

    if (-not $SkipTasks) {
        Write-PSFMessage -Level Verbose -Message "Building the task details and saving them to the excel file." -Target $SkipTasks

        $taskObjects.ToArray() | Export-Excel -Path $OutputPath -WorksheetName "Tasks" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

        $groupTaskTexts = $taskObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctTaskText"
        $groupTaskTexts | Export-Excel -Path $OutputPath -WorksheetName "Tasks-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
    }
    else {
        Remove-Worksheet -Path $OutputPath -WorksheetName "Tasks"
        Remove-Worksheet -Path $OutputPath -WorksheetName "Tasks-Summary"
    }

    [PSCustomObject]@{
        File     = $OutputPath
        Filename = $(Split-Path -Path $OutputPath -Leaf)
    }

    Invoke-TimeSignal -End
}