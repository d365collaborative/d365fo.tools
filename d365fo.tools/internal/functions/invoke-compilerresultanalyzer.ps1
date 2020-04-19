
function Invoke-CompilerResultAnalyzer {
    [CmdletBinding()]
    [OutputType('')]
    param (
        [string] $Path,

        [string] $Identifier,

        [string] $OutputFilePath,

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
        try {
            $warningText = Select-String -LiteralPath $Path -Pattern '(^.*) Warning: (.*)' | ForEach-Object { $_.Line }
            
            # Skip modules that do not have warnings
            if ($warningText) {
                foreach ($line in $warningText) {
                    $lineLocal = $line
                        
                    # Remove positioning text in the format of "[(5,5),(5,39)]: " for methods
                    if ($lineLocal -match $positionRegex) {
                        $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }
    
                    try {
                        # Regular expression matching to split line details into groups
                        $Matches = [regex]::split($lineLocal, $warningRegex)
                        $object = [PSCustomObject]@{
                            OutputType = $Matches[1].trim()
                            ObjectType = $Matches[2].trim()
                            Path       = $Matches[3].trim()
                            Text       = $Matches[4].trim()
                        }

                        # Store all entries
                        $warningObjects.Add($object)
                    }
                    catch {
                        Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for warnings <</c><c='Red'>$line</c><c='Yellow'>></c>"
                        # Write-Host "($Identifier) Error during processing line for warnings <" -ForegroundColor Yellow -NoNewline
                        # Write-Host "$line" -ForegroundColor Red -NoNewline
                        # Write-Host ">" -ForegroundColor Yellow
                        #Write-Host $regex
                    }
                    #break
                }
            }
        }
        catch {
            Write-PSFMessage -Level Host "Error while processing warnings"
        }
    }

    if (-not $SkipTasks) {
        try {
            $taskText = Select-String -LiteralPath $Path -Pattern '(^.*)TaskListItem Information: (.*)' | ForEach-Object { $_.Line }

            # Skip modules that do not have tasks
            if ($taskText) {
                foreach ($line in $taskText) {
                    $lineLocal = $line
                        
                    # Remove positioning text in the format of "[(5,5),(5,39)]: " for methods
                    if ($lineLocal -match $positionRegex) {
                        $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }

                    # Remove TODO part
                    if ($lineLocal -match '(?:TODO :|TODO:|TODO)') {
                        $lineReplaced = [regex]::Split($lineLocal, '(.*)(?:TODO :|TODO:|TODO)(.*)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                        $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                    }

                    try {
                        # Regular expression matching to split line details into groups
                        $Matches = [regex]::split($lineLocal, $taskRegex)
                        $object = [PSCustomObject]@{
                            OutputType = $Matches[1].trim()
                            ObjectType = $Matches[2].trim()
                            Path       = $Matches[3].trim()
                            Text       = $Matches[4].trim()
                        }

                        # Store all entries
                        $taskObjects.Add($object)
                    }
                    catch {
                        Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for tasks <</c><c='Red'>$line</c><c='Yellow'>></c>"
                        # Write-Host "($Identifier) Error during processing line for tasks <" -ForegroundColor Yellow -NoNewline
                        # Write-Host "$line" -ForegroundColor Red -NoNewline
                        # Write-Host ">" -ForegroundColor Yellow
                    }
                    #break
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
                    $lineReplaced = [regex]::Split($lineLocal, $positionSplitRegex)
                    $lineLocal = $lineReplaced[1] + $lineReplaced[2]
                }

                try {
                    # Regular expression matching to split line details into groups
                    $Matches = [regex]::split($lineLocal, $errorRegex)
                    $object = [PSCustomObject]@{
                        ErrorType  = $Matches[1].trim()
                        ObjectType = $Matches[2].trim()
                        Path       = $Matches[3].trim()
                        Text       = $Matches[4].trim()
                    }

                    # Store all entries
                    $errorObjects.Add($object)
                }
                catch {
                    Write-PSFHostColor -Level Host "<c='Yellow'>($Identifier) Error during processing line for errors <</c><c='Red'>$line</c><c='Yellow'>></c>"
                    # Write-Host "($Identifier) Error during processing line for errors <" -ForegroundColor Yellow -NoNewline
                    # Write-Host "$line" -ForegroundColor Red -NoNewline
                    # Write-Host ">" -ForegroundColor Yellow
                    #Write-Host $regex
                }
                #break
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Error during processing errors"
    }

    $errorObjects.ToArray() | Export-Excel -Path $OutputFilePath -WorksheetName "Errors" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

    $groupErrorTexts = $errorObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctErrorText"
    $groupErrorTexts | Export-Excel -Path $OutputFilePath -WorksheetName "Errors-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
        
    if (-not $SkipWarnings) {
        $warningObjects.ToArray() | Export-Excel -Path $OutputFilePath -WorksheetName "Warnings" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

        $groupWarningTexts = $warningObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctWarningText"
        $groupWarningTexts | Export-Excel -Path $OutputFilePath -WorksheetName "Warnings-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
    }
    else {
        Remove-Worksheet -Path $OutputFilePath -WorksheetName "Warnings"
        Remove-Worksheet -Path $OutputFilePath -WorksheetName "Warnings-Summary"
    }

    if (-not $SkipTasks) {
        $taskObjects.ToArray() | Export-Excel -Path $OutputFilePath -WorksheetName "Tasks" -ClearSheet -AutoFilter -AutoSize -BoldTopRow

        $groupTaskTexts = $taskObjects.ToArray() | Group-Object -Property Text | Sort-Object -Property "Count" -Descending | Select-PSFObject Count, "Name as DistinctTaskText"
        $groupTaskTexts | Export-Excel -Path $OutputFilePath -WorksheetName "Tasks-Summary" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
    }
    else {
        Remove-Worksheet -Path $OutputFilePath -WorksheetName "Tasks"
        Remove-Worksheet -Path $OutputFilePath -WorksheetName "Tasks-Summary"
    }

    [PSCustomObject]@{
        File     = $OutputFilePath
        Filename = $(Split-Path -Path $OutputFilePath -Leaf)
    }

    Invoke-TimeSignal -End
}