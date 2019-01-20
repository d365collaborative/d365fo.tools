function Get-AsyncResult {
    [CmdletBinding()]
    [OutputType('Object')]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [object] $Task
    )

    $Task.GetAwaiter().GetResult()
}