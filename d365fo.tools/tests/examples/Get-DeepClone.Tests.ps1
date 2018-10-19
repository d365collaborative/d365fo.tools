$commandName = "Get-DeepClone"
$exampleRaw = "PS C:\> Get-DeepClone -InputObject `$HashTable"

$HashTable = @{}

$example = $exampleRaw -replace "`n.*" -replace "PS C:\\>" 

Describe "Specific example testing for $commandName" {

    It "Example - $example" {
        # mock the tested command so we don't actually do anything
        # because it can be unsafe and we don't have the environment setup
        # (so the only thing we are testing is that the code is semantically
        # correct and provides all the needed params)
        Mock $commandName { 
            # I am returning true here,
            # but some of the examples drill down to the returned object
            # so in strict mode we would fail
            $true 
        }

        # here simply invoke the example
        $result = Invoke-Expression $example
        # and check that we got result from the mock
        $result | Should -BeTrue
    }
}