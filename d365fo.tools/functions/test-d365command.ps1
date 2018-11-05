function Test-D365Command {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $CommandText,

        [ValidateSet('Validate', 'ShowParameters')]
        [string] $Mode,

        [switch] $IncludeHelp
    )

    $commonParameters = 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable', 'Confirm', 'WhatIf'

    #Match to find the command name: Non-Whitespace until the first whitespace
    $commandMatch = ($CommandText | Select-String '\S+\s*').Matches

    if (-not ($null -eq $commandMatch)) {
        #$commandName = ($CommandText | Select-String '\S+\s{1}').Matches.Value.Trim()
        $commandName = $commandMatch.Value.Trim()

        $res = Get-Command $commandName -ErrorAction Ignore

        if (-not ($null -eq $res)) {

            $null = $sbHelp = New-Object System.Text.StringBuilder
            $null = $sbParmsNotFound = New-Object System.Text.StringBuilder
            

            switch ($Mode) {
                "Validate" {
                    #Match to find the parameters: Whitespace Dash Non-Whitespace
                    $inputParameterMatch = ($CommandText | Select-String '\s{1}[-]\S+' -AllMatches).Matches
                    
                    if (-not ($null -eq $inputParameterMatch)) {
                        $inputParameterNames = $inputParameterMatch.Value.Trim("-", " ")
                    }
                    else {
                        Write-PSFMessage -Level Host -Message "The function was unable to extract any parameters from the supplied command text. Please try again."
                        Stop-PSFFunction -Message "Stopping because of missing input parameters."
                        return
                    }

                    $availableParameterNames = (Get-Command $commandName).Parameters.keys | Where-Object {$commonParameters -NotContains $_}
                    $inputParameterNotFound = $inputParameterNames | Where-Object {$availableParameterNames -NotContains $_}

                    $null = $sbParmsNotFound.AppendLine("Parameters that <c='em'>don't exists</c>")
                    #Show all the parameters that could be match here: $inputParameterNotFound
                    $inputParameterNotFound | ForEach-Object {
                        $null = $sbParmsNotFound.AppendLine("<c='red'>$($_)</c>")
                    }


                    (Get-Command $commandName).ParameterSets | ForEach-Object {
                        $null = $sb = New-Object System.Text.StringBuilder
                        
                        $null = $sb.AppendLine("ParameterSet Name: <c='em'>$($_.Name)</c> - Validated List")
                      
        
                        $null = $sb.Append("<c='Green'>$commandName </c>")
                        $parmSetParameters = $_.Parameters | Where-Object name -NotIn $commonParameters
        
                        $parmSetParameters | ForEach-Object {
                            $parmFoundInCommandText = $_.Name -In $inputParameterNames
                            
                            $color = "darkgray"
        
                            if ($_.IsMandatory -eq $true) { $color = "yellow" }
        
                            $null = $sb.Append("<c='$color'>-$($_.Name)</c>")
                            
        
                            if ($parmFoundInCommandText) {
                                $color = "green"
                                $null = $sb.Append("<c='$color'>* </c>")
                            }
                            elseif ($_.IsMandatory -eq $true) {
                                $color = "magenta"
                                $null = $sb.Append("<c='$color'>* </c>")
                            }
                            else {
                                $null = $sb.Append(" ")
                                
                            }
        
                            if (-not ($_.ParameterType -eq [System.Management.Automation.SwitchParameter])) {
                                $null = $sb.Append("<c='DarkCyan'>PARAMVALUE </c>")
        
                            }
                        }
        
                        $null = $sb.AppendLine("")
                        Write-PSFMessage -Level Host -Message "$($sb.ToString())"
                    }

                    $null = $sbHelp.AppendLine("")
                    $null = $sbHelp.AppendLine("<c='Red'>Red</c> = Parameter not found")
                    $null = $sbHelp.AppendLine("<c='Green'>Green</c> = Command Name")
                    $null = $sbHelp.AppendLine("<c='yellow'>Yellow</c> = Mandatory Parameter")
                    $null = $sbHelp.AppendLine("<c='darkgray'>DarkGray</c> = Optional Parameter")
                    $null = $sbHelp.AppendLine("<c='DarkCyan'>DarkCyan</c> = Parameter value")
                    $null = $sbHelp.AppendLine("<c='Green'>*</c> = Parameter was filled")
                    $null = $sbHelp.AppendLine("<c='magenta'>*</c> = Mandatory missing")
                }

                "ShowParameters" {
                    (Get-Command $commandName).ParameterSets | ForEach-Object {
                        $null = $sb = New-Object System.Text.StringBuilder
                        
                        $null = $sb.AppendLine("ParameterSet Name: <c='em'>$($_.Name)</c> - Parameter List")
                        
                        
                        $null = $sb.Append("<c='Green'>$commandName </c>")
                        $parmSetParameters = $_.Parameters | Where-Object name -NotIn $commonParameters
        
                        $parmSetParameters | ForEach-Object {
                            $color = "darkgray"
        
                            if ($_.IsMandatory -eq $true) { $color = "yellow" }
        
                            $null = $sb.Append("<c='$color'>-$($_.Name) </c>")
        
                            if (-not ($_.ParameterType -eq [System.Management.Automation.SwitchParameter])) {
                                $null = $sb.Append("<c='DarkCyan'>PARAMVALUE </c>")
        
                            }
                        }
        
                        $null = $sb.AppendLine("")
                        Write-PSFMessage -Level Host -Message "$($sb.ToString())"
                    }

                    $null = $sbHelp.AppendLine("")
                    $null = $sbHelp.AppendLine("<c='Green'>Green</c> = Command Name")
                    $null = $sbHelp.AppendLine("<c='yellow'>Yellow</c> = Mandatory Parameter")
                    $null = $sbHelp.AppendLine("<c='darkgray'>DarkGray</c> = Optional Parameter")
                    $null = $sbHelp.AppendLine("<c='DarkCyan'>DarkCyan</c> = Parameter value")
                }
                Default {}
            }

            Write-PSFMessage -Level Host -Message "$($sbParmsNotFound.ToString())"

            if ($IncludeHelp) {
                Write-PSFMessage -Level Host -Message "$($sbHelp.ToString())"
            }
        }
        else {
            Write-PSFMessage -Level Host -Message "The function was unable to get the help of the command. Make sure that the command name is valid and try again."
            Stop-PSFFunction -Message "Stopping because command name didn't return any help."
            return
        }
    }
    else {
        Write-PSFMessage -Level Host -Message "The function was unable to extract a valid command name from the supplied command text. Please try again."
        Stop-PSFFunction -Message "Stopping because of missing command name."
        return
    }
}