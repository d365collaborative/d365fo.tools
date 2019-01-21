
<#
    .SYNOPSIS
        Convert a Hashtable into a PSCustomObject
        
    .DESCRIPTION
        Convert a Hashtable into a PSCustomObject
        
    .PARAMETER InputObject
        The hashtable you want to convert
        
    .EXAMPLE
        PS C:\> $params = @{SqlUser = ""; SqlPwd = ""}
        PS C:\> $params | ConvertTo-PsCustomObject
        
        This will create a hashtable with 2 properties.
        It will convert the hashtable into a PSCustomObject
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        Original blog post with the function explained:
        https://blogs.msdn.microsoft.com/timid/2013/03/05/converting-pscustomobject-tofrom-hashtables/
#>

function ConvertTo-PsCustomObject {
    [OutputType('[PsCustomObject]')]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [object[]] $InputObject
    )
    
    begin { $i = 0 }
    
    process {
        foreach ($myHashtable in $InputObject) {
            if ($myHashtable.GetType().Name -eq 'hashtable') {
                $output = New-Object -TypeName PsObject
                Add-Member -InputObject $output -MemberType ScriptMethod -Name AddNote -Value {
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1]
                }

                $myHashtable.Keys | Sort-Object | ForEach-Object {
                    $output.AddNote($_, $myHashtable.$_)
                }

                $output
            }
            elseif ($myHashtable.GetType().Name -eq 'OrderedDictionary') {
                $output = New-Object -TypeName PsObject
                Add-Member -InputObject $output -MemberType ScriptMethod -Name AddNote -Value {
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1]
                }

                $myHashtable.Keys | ForEach-Object {
                    $output.AddNote($_, $myHashtable.$_)
                }

                $output
            }
            else {
                Write-PSFMessage -Level Warning -Message "Index `$i is not of type [hashtable]" -Target $i
            }

            $i += 1
        }
    }
}