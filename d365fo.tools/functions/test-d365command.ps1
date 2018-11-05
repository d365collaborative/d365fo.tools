function Test-D365Command {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $CommandText
    )

    $commonParameters = 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable', 'Confirm', 'WhatIf'

    #Match to find the command name: Non-Whitespace until the first whitespace
    $commandName = ($CommandText | Select-String '\S+\s{1}').Matches.Value.Trim()
    
    #Match to find the parameters: Whitespace Dash Non-Whitespace
    $inputParameterNames = ($CommandText | Select-String '\s{1}[-]\S+' -AllMatches).Matches.Value.Trim("-"," ")

    $availableParameterNames = (Get-Command $commandName).Parameters.keys | Where-Object {$commonParameters -notcontains $_}

    $inputParameterNotFound = $inputParameterNames | Where-Object {$availableParameterNames -notcontains $_}

    #Show all the parameters that could be match here: $inputParameterNotFound

    <#
    (Get-Command $commandName).ParameterSets | ForEach-Object {
        "This is the name: $($_.Name)"
        $parmSetParameterNames = $_.Parameters.Name | Where-Object {$commonParameters -notcontains $_}
        $parmSetParameterNames
    }
    #>

    (Get-Command $commandName).ParameterSets | ForEach-Object {
        $null = $sb = New-Object System.Text.StringBuilder
        $null = $sb.AppendLine("")
        $null = $sb.AppendLine("ParameterSet Name: <c='em'>$($_.Name)</c> - Full List")
        $null = $sb.AppendLine("<c='em'>Green</c> = Command Name | <c='yellow'>Yellow</c> = Mandatory Parameter | <c='darkgray'>DarkGray</c> = Optional Parameter | <c='DarkCyan'>DarkCyan</c> = Parameter value")
        $null = $sb.Append("<c='em'>$commandName </c>")
        $parmSetParameters = $_.Parameters | Where-Object name -NotIn $commonParameters

        $parmSetParameters | ForEach-Object {
            $color = "darkgray"

            if($_.IsMandatory -eq $true) { $color = "yellow" }

            $null = $sb.Append("<c='$color'>-$($_.Name) </c>")

            if(-not ($_.ParameterType -eq [System.Management.Automation.SwitchParameter])) {
            $null = $sb.Append("<c='DarkCyan'>PARAMVALUE </c>")

            }
        }

        Write-PSFMessage -Level Host -Message "$($sb.ToString())"
    }


}

<#

$CommandText = 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile "C:\temp\uat.bacpac"'

$CommandText = 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd2 "XyzXyz" -BacpacFile "C:\temp\uat.bacpac"'

#>