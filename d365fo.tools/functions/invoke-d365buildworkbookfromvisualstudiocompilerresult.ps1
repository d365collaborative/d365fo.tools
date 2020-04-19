
function Invoke-D365BuildWorkbookFromVisualStudioCompilerResult {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [string] $Module = "*",

        [string] $OutputPath = $Script:DefaultTempPath,

        [switch] $SkipWarnings,

        [switch] $SkipTasks,

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $PackageDirectory -Type Container)) { return }
    
    $buildOutputFiles = Get-ChildItem -Path "$PackageDirectory\$Module\BuildModelResult.log" -ErrorAction SilentlyContinue -Force

    $positionRegex = '(?=\[\().*(?=\)\])'
    $positionSplitRegex = '(.*)(?=\[\().*(?:\)\]: )(.*)'

    $warningRegex = '(?:Compile Fatal|MetadataProvider|Metadata|Compile|Unspecified|Generation|ExternalReference|BestPractices) (Warning): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'
    $taskRegex = '(TaskListItem Information): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'
    $errorRegex = '(?:Compile Fatal|MetadataProvider|Metadata|Compile|Unspecified|Generation) (Error): (Query Method|Interface Method|Form Method LocalFunction|Form Control Method|Form Datasource Method|Form DataSource Method|Form DataSource DataField Method|Form Method|Map Method|Class Delegate|Table Method LocalFunction|Class Method LocalFunction|Table Method|Class Method|Table|Class|View|Form|)(?: |)(?:dynamics:|)(.*)(?:: )(.*)'

    foreach ($result in $buildOutputFiles) {
        
        $moduleName = Split-Path -Path $result.DirectoryName -Leaf
        $filePath = Join-Path -Path $OutputPath -ChildPath "$moduleName-CompilerResults.xlsx"

        $warningObjects = New-Object System.Collections.Generic.List[System.Object]
        $errorObjects = New-Object System.Collections.Generic.List[System.Object]
        $taskObjects = New-Object System.Collections.Generic.List[System.Object]
    
        if (-not $SkipWarnings) {
            try {
                $warningText = Select-String -LiteralPath $result.FullName -Pattern '(^.*) Warning: (.*)' | ForEach-Object { $_.Line }
            
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
                            Write-Host "Error during processing line for warnings <" -ForegroundColor Yellow -NoNewline
                            Write-Host "$line" -ForegroundColor Red -NoNewline
                            Write-Host ">" -ForegroundColor Yellow
                            #Write-Host $regex
                        }
                        #break
                    }
                }
            }
            catch {
                Write-Host "Error while processing warnings"
            }
        }

        if (-not $SkipTasks) {
            try {
                $taskText = Select-String -LiteralPath $result.FullName -Pattern '(^.*)TaskListItem Information: (.*)' | ForEach-Object { $_.Line }

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
                            $lineReplaced = [regex]::Split($lineLocal, '(.*)(?:TODO :|TODO:|TODO)(.*)')
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
                            Write-Host "Error during processing line for tasks <" -ForegroundColor Yellow -NoNewline
                            Write-Host "$line" -ForegroundColor Red -NoNewline
                            Write-Host ">" -ForegroundColor Yellow
                        }
                        #break
                    }
                }
            }
            catch {
                Write-Host
                Write-Host "Error during processing"
            }
        }

        try {
            $errorText = Select-String -LiteralPath $result.FullName -Pattern '(^.*) Error: (.*)' | ForEach-Object { $_.Line }

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
                        Write-Host "Error during processing line for errors <" -ForegroundColor Yellow -NoNewline
                        Write-Host "$line" -ForegroundColor Red -NoNewline
                        Write-Host ">" -ForegroundColor Yellow
                        #Write-Host $regex
                    }
                    #break
                }
            }
        }
        catch {
            Write-Host
            Write-Host "Error during processing"
        }

        $errorObjects.ToArray() | Export-Excel -Path $filePath -WorksheetName "Errors" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
        if (-not $SkipWarnings) {
            $warningObjects.ToArray() | Export-Excel -Path $filePath -WorksheetName "Warnings" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
        }

        if (-not $SkipTasks) {
            $taskObjects.ToArray() | Export-Excel -Path $filePath -WorksheetName "Tasks" -ClearSheet -AutoFilter -AutoSize -BoldTopRow
        }
    }



    Invoke-TimeSignal -End
}