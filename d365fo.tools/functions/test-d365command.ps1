
<#
    .SYNOPSIS
        Validate or show parameter set details with colored output
        
    .DESCRIPTION
        Analyze a function and it's parameters
        
        The cmdlet / function is capable of validating a string input with function name and parameters
        
    .PARAMETER CommandText
        The string that you want to analyze
        
        If there is parameter value present, you have to use the opposite quote strategy to encapsulate the string correctly
        
        E.g. for double quotes
        -CommandText 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile2 "C:\temp\uat.bacpac"'
        
        E.g. for single quotes
        -CommandText "Import-D365Bacpac -ExportModeTier2 -SqlUser 'sqladmin' -SqlPwd 'XyzXyz' -BacpacFile2 'C:\temp\uat.bacpac'"
        
    .PARAMETER Mode
        The operation mode of the cmdlet / function
        
        Valid options are:
        - Validate
        - ShowParameters
        
    .PARAMETER SplatInput
        Pass in your hashtable that you use for your command execution and have it validated
        
    .PARAMETER ShowSplatStyleV1
        Include an hashtable splatting for all parameter sets in the output
        
        The example is built like this:
        PS C:\> $params = @{}
        PS C:\> $params.PropertyName = "SAMPLEVALUE"
        PS C:\> Test-FakeCommand @params
        
        
    .PARAMETER ShowSplatStyleV2
        Include an hashtable splatting for all parameter sets in the output
        
        The example is built like this:
        PS C:\> $params = @{
        PS C:\> PropertyName = "SAMPLEVALUE"
        PS C:\> }
        PS C:\> Test-FakeCommand @params
        
    .PARAMETER IncludeHelp
        Switch to instruct the cmdlet / function to output a simple guide with the colors in it
        
    .EXAMPLE
        PS C:\> Test-D365Command -CommandText 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile2 "C:\temp\uat.bacpac"' -Mode "Validate" -IncludeHelp
        
        This will validate all the parameters that have been passed to the Import-D365Bacpac cmdlet.
        All supplied parameters that matches a parameter will be marked with an asterisk.
        Will print the coloring help.
        
    .EXAMPLE
        PS C:\> Test-D365Command -CommandText 'Import-D365Bacpac' -Mode "ShowParameters" -IncludeHelp
        
        This will display all the parameter sets and their individual parameters.
        Will print the coloring help.
        
    .EXAMPLE
        PS C:\> $params = @{}
        PS C:\> $params.DatabaseName = "SAMPLEVALUE"
        PS C:\> Test-D365Command -CommandText 'Import-D365Bacpac -ImportModeTier2' -SplatInput $params -Mode "Validate"
        
        This builds a hashtable with a property names "DatabaseName".
        The hashtable is passed to the cmdlet to be part of the validation.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Test-D365Command {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $CommandText,

        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('Validate', 'ShowParameters')]
        [string] $Mode,

        [hashtable] $SplatInput,

        [switch] $ShowSplatStyleV1,

        [switch] $ShowSplatStyleV2,

        [switch] $IncludeHelp
    )

    $commonParameters = 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable', 'Confirm', 'WhatIf'
    
    $colorParmsNotFound = "Red"
    $colorCommandName = "Green"
    $colorMandatoryParam = "Yellow"
    $colorNonMandatoryParam = "DarkGray"
    $colorFoundAsterisk = "Green"
    $colorNotFoundAsterisk = "Magenta"
    $colParmValue = "DarkCyan"
    $colorEqualSign = "DarkGray"
    $colorVariable = "Green"
    $colorProperty = "White"
    $colorCommandNameSplat = "Yellow"
    $colorComment = "DarkGreen"

    if(-not ($null -eq $SplatInput)) {
        $CommandText = "$CommandText "+ $(($SplatInput.Keys | ForEach-Object {"-$($_) `"$($SplatInput.Item($_))`""}) -Join " " )
    }

    #Match to find the command name: Non-Whitespace until the first whitespace
    $commandMatch = ($CommandText | Select-String '\S+\s*').Matches

    if ($null -eq $commandMatch) {
        Write-PSFMessage -Level Host -Message "The function was unable to extract a valid command name from the supplied command text. Please try again."
        Stop-PSFFunction -Message "Stopping because of missing command name."
        return
    }

    $commandName = $commandMatch.Value.Trim()

    $res = Get-Command $commandName -ErrorAction Ignore

    if ($null -eq $res) {
        Write-PSFMessage -Level Host -Message "The function was unable to get the help of the command. Make sure that the command name is valid and try again."
        Stop-PSFFunction -Message "Stopping because command name didn't return any help."
        return
    }

    $sbHelp = New-Object System.Text.StringBuilder
    $sbParmsNotFound = New-Object System.Text.StringBuilder
    $sbSplatStyleV1 = New-Object System.Text.StringBuilder
    $sbSplatStyleV2 = New-Object System.Text.StringBuilder

    switch ($Mode) {
        "Validate" {
            #Match to find the parameters: Whitespace Dash Non-Whitespace
            $inputParameterMatch = ($CommandText | Select-String '\s{1}[-]\S+' -AllMatches).Matches
                    
            if (-not ($null -eq $inputParameterMatch)) {
                $inputParameterNames = $inputParameterMatch.Value.Trim("-", " ")
                Write-PSFMessage -Level Verbose -Message "All input parameters - $($inputParameterNames -join ",")" -Target ($inputParameterNames -join ",")
            }
            else {
                Write-PSFMessage -Level Host -Message "The function was unable to extract any parameters from the supplied command text. Please try again."
                Stop-PSFFunction -Message "Stopping because of missing input parameters."
                return
            }

            $availableParameterNames = (Get-Command $commandName).Parameters.keys | Where-Object {$commonParameters -NotContains $_}
            Write-PSFMessage -Level Verbose -Message "Available parameters - $($availableParameterNames -join ",")" -Target ($availableParameterNames -join ",")

            $inputParameterNotFound = $inputParameterNames | Where-Object {$availableParameterNames -NotContains $_}

            if ($inputParameterNotFound.Length -gt 0) {
                $null = $sbParmsNotFound.AppendLine("Parameters that <c='em'>don't exists</c>")
                $inputParameterNotFound | ForEach-Object {
                    $null = $sbParmsNotFound.AppendLine("<c='$colorParmsNotFound'>$($_)</c>")
                }
            }

            foreach ($parmSet in (Get-Command $commandName).ParameterSets) {
                $null = $sb = New-Object System.Text.StringBuilder
                $null = $sb.AppendLine("ParameterSet Name: <c='em'>$($parmSet.Name)</c> - Validated List")
                $null = $sb.Append("<c='$colorCommandName'>$commandName </c>")

                $parmSetParameters = $parmSet.Parameters | Where-Object name -NotIn $commonParameters
        
                foreach ($parameter in $parmSetParameters) {
                    $parmFoundInCommandText = $parameter.Name -In $inputParameterNames
                            
                    $color = "$colorNonMandatoryParam"
        
                    if ($parameter.IsMandatory -eq $true) { $color = "$colorMandatoryParam" }
        
                    $null = $sb.Append("<c='$color'>-$($parameter.Name)</c>")
        
                    if ($parmFoundInCommandText) {
                        $null = $sb.Append("<c='$colorFoundAsterisk'>* </c>")
                    }
                    elseif ($parameter.IsMandatory -eq $true) {
                        $null = $sb.Append("<c='$colorNotFoundAsterisk'>* </c>")
                    }
                    else {
                        $null = $sb.Append(" ")
                    }
        
                    if (-not ($parameter.ParameterType -eq [System.Management.Automation.SwitchParameter])) {
                        $null = $sb.Append("<c='$colParmValue'>PARAMVALUE </c>")
                    }
                }
        
                $null = $sb.AppendLine("")
                Write-PSFHostColor -String "$($sb.ToString())"
            }

            $null = $sbHelp.AppendLine("")
            $null = $sbHelp.AppendLine("<c='$colorParmsNotFound'>$colorParmsNotFound</c> = Parameter not found")
            $null = $sbHelp.AppendLine("<c='$colorCommandName'>$colorCommandName</c> = Command Name")
            $null = $sbHelp.AppendLine("<c='$colorMandatoryParam'>$colorMandatoryParam</c> = Mandatory Parameter")
            $null = $sbHelp.AppendLine("<c='$colorNonMandatoryParam'>$colorNonMandatoryParam</c> = Optional Parameter")
            $null = $sbHelp.AppendLine("<c='$colParmValue'>$colParmValue</c> = Parameter value")
            $null = $sbHelp.AppendLine("<c='$colorFoundAsterisk'>*</c> = Parameter was filled")
            $null = $sbHelp.AppendLine("<c='$colorNotFoundAsterisk'>*</c> = Mandatory missing")
        }

        "ShowParameters" {
            foreach ($parmSet in (Get-Command $commandName).ParameterSets) {
                $sb = New-Object System.Text.StringBuilder
                $sbSplatStyleV1 = New-Object System.Text.StringBuilder
                $sbSplatStyleV2 = New-Object System.Text.StringBuilder

                $null = $sb.AppendLine("ParameterSet Name: <c='em'>$($parmSet.Name)</c> - Parameter List")
                $null = $sb.Append("<c='$colorCommandName'>$commandName </c>")
                
                $null = $sbSplatStyleV1.AppendLine("<c='$colorComment'>#Hashtable splatting style V1 - ParameterSet Name: </c><c='em'>$($parmSet.Name)</c>").AppendLine("<c='$colorVariable'>`$params</c> <c='$colorEqualSign'>=</c> <c='$colorProperty'>@{}</c>")
                $null = $sbSplatStyleV2.AppendLine("<c='$colorComment'>#Hashtable splatting style V2 - ParameterSet Name: </c><c='em'>$($parmSet.Name)</c>").AppendLine("<c='$colorVariable'>`$params</c> <c='$colorEqualSign'>=</c> <c='$colorProperty'>@{</c>")

                $parmSetParameters = $parmSet.Parameters | Where-Object name -NotIn $commonParameters
        
                foreach ($parameter in $parmSetParameters) {
                    $color = "$colorNonMandatoryParam"
                    $mandatoryComment = $null

                    if ($parameter.IsMandatory -eq $true) {
                        $color = "$colorMandatoryParam"

                        $mandatoryComment = "   <c='$color'>#MANDATORY</c>"
                    }

                    $null = $sbSplatStyleV1.AppendLine("<c='$colorVariable'>`$params</c><c='$colorProperty'>.$($parameter.Name)</c> <c='$colorEqualSign'>=</c> <c='$colParmValue'>`"SAMPLEVALUE`"</c>$mandatoryComment")
                    $null = $sbSplatStyleV2.AppendLine("<c='$colorProperty'>$($parameter.Name)</c> <c='$colorEqualSign'>=</c> <c='$colParmValue'>`"SAMPLEVALUE`"</c>$mandatoryComment")
        
                    $null = $sb.Append("<c='$color'>-$($parameter.Name) </c>")
        
                    if (-not ($parameter.ParameterType -eq [System.Management.Automation.SwitchParameter])) {
                        $null = $sb.Append("<c='$colParmValue'>PARAMVALUE </c>")
                    }
                }
        
                $null = $sb.AppendLine("")
                $null = $sbSplatStyleV2.AppendLine("<c='$colorProperty'>}</c>")
                $null = $sbSplatStyleV1.AppendLine("<c='$colorCommandNameSplat'>$commandName</c> <c='$colorVariable'>@params</c>")
                $null = $sbSplatStyleV2.AppendLine("<c='$colorCommandNameSplat'>$commandName</c> <c='$colorVariable'>@params</c>")

                Write-PSFHostColor -String "$($sb.ToString())"
                
                if ($ShowSplatStyleV1) { Write-PSFHostColor -String "$($sbSplatStyleV1.ToString())" }
                if ($ShowSplatStyleV2) { Write-PSFHostColor -String "$($sbSplatStyleV2.ToString())" }
            }

            $null = $sbHelp.AppendLine("")
            $null = $sbHelp.AppendLine("<c='$colorCommandName'>$colorCommandName</c> = Command Name")
            $null = $sbHelp.AppendLine("<c='$colorMandatoryParam'>$colorMandatoryParam</c> = Mandatory Parameter")
            $null = $sbHelp.AppendLine("<c='$colorNonMandatoryParam'>$colorNonMandatoryParam</c> = Optional Parameter")
            $null = $sbHelp.AppendLine("<c='$colParmValue'>$colParmValue</c> = Parameter value")
        }
        Default {}
    }

    if ($sbParmsNotFound.ToString().Trim().Length -gt 0) {
        Write-PSFHostColor -String "$($sbParmsNotFound.ToString())"
    }
 
    if ($IncludeHelp) {
        Write-PSFHostColor -String "$($sbHelp.ToString())"
    }
}