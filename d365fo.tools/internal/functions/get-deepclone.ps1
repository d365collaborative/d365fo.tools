function Get-DeepClone
{
    [cmdletbinding()]
    [OutputType('System.Collections.Hashtable')]
    param(
        $InputObject
    )
    process
    {    
        if($InputObject -is [hashtable]) {
            $clone = @{}
            foreach($key in $InputObject.keys)
            {
                $clone[$key] = Get-DeepClone $InputObject[$key]
            }
            return $clone
        } else {
            return $InputObject
        }        
    }
}