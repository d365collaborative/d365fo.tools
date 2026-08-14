# Handles testing of help examples that require a more customized approach.

$commands = @(
    'Get-D365LcsApiToken' # Cannot be mocked due to custom attribute.
)

function Initialize-SeparateExampleMocks {
    param(
        [string] $CommandName
    )

    switch ($CommandName) {
        'Get-D365LcsApiToken' {
            InModuleScope d365fo.tools {
                $Script:LcsApiClientId = 'default-client-id'
                $Script:LcsApiLcsApiUri = 'https://lcsapi.lcs.dynamics.com'
                $Script:AADOAuthEndpoint = 'https://login.microsoftonline.com/common/oauth2/token'
            }

            Mock Invoke-TimeSignal -ModuleName d365fo.tools {}
            Mock Invoke-PasswordGrant -ModuleName d365fo.tools { $true }
        }
        default {
            throw "No separate example test configuration exists for command '$CommandName'."
        }
    }
}

function Assert-SeparateExampleMocks {
    param(
        [string] $CommandName
    )

    switch ($CommandName) {
        'Get-D365LcsApiToken' {
            Assert-MockCalled Invoke-PasswordGrant -ModuleName d365fo.tools -Times 1
        }
        default {
            throw "No separate example assertion exists for command '$CommandName'."
        }
    }
}

Describe 'Dedicated example-backed runtime tests' {
    It 'Get-D365LcsApiToken accepts a plain text password and forwards the expected grant parameters' {
        Mock Invoke-TimeSignal -ModuleName d365fo.tools {}
        Mock Invoke-PasswordGrant -ModuleName d365fo.tools { $true }

        $result = Get-D365LcsApiToken -ClientId 'plain-text-client-id' -Username 'serviceaccount@domain.com' -Password 'TopSecretPassword' -LcsApiUri 'https://lcsapi.lcs.dynamics.com'

        $result | Should -BeTrue
        Assert-MockCalled Invoke-PasswordGrant -ModuleName d365fo.tools -Times 1 -Exactly -ParameterFilter {
            $Resource -eq 'https://lcsapi.lcs.dynamics.com' -and
            $ClientId -eq 'plain-text-client-id' -and
            $Username -eq 'serviceaccount@domain.com' -and
            $Password -eq 'TopSecretPassword' -and
            $Scope -eq 'openid'
        }
    }

    It 'Get-D365LcsApiToken accepts a SecureString password and forwards the expected grant parameters' {
        Mock Invoke-TimeSignal -ModuleName d365fo.tools {}
        Mock Invoke-PasswordGrant -ModuleName d365fo.tools { $true }

        $securePassword = ConvertTo-SecureString -String 'TopSecretPassword' -AsPlainText -Force
        $result = Get-D365LcsApiToken -ClientId 'secure-string-client-id' -Username 'serviceaccount@domain.com' -Password $securePassword -LcsApiUri 'https://lcsapi.lcs.dynamics.com'

        $result | Should -BeTrue
        Assert-MockCalled Invoke-PasswordGrant -ModuleName d365fo.tools -Times 1 -Exactly -ParameterFilter {
            $Resource -eq 'https://lcsapi.lcs.dynamics.com' -and
            $ClientId -eq 'secure-string-client-id' -and
            $Username -eq 'serviceaccount@domain.com' -and
            $Password -eq 'TopSecretPassword' -and
            $Scope -eq 'openid'
        }
    }
}

foreach ( $commandName in $commands) {
    $examples = Get-Help $commandName -Examples

    Describe "Examples from $commandName" {
        $examples.Examples.Example | foreach {
            $example = $_.Code -replace "`n.*" -replace "PS C:\\>"

            if ( ($example -like "*|*" ) -or (-not ($example -match $commandName)) -or ($example -like "*).*")) {
                It "Example - $example" -Skip { $true }
            } elseif ($example -match '(?<=^(([^"|^'']\*(?<!\\)"[^"|^'']\*(?<!\\)"[^"|^'']\*)\*|[^"|^'']*))=') {
                $varAssignment = ($example -split "=")[0]

                It "Example - $example" {
                    Initialize-SeparateExampleMocks -CommandName $commandName

                    $exampleExtended = "$example;$varAssignment"
                    $result = Invoke-Expression $exampleExtended

                    $result | Should -BeTrue
                    Assert-SeparateExampleMocks -CommandName $commandName
                }
            } else {
                It "Example - $example" {
                    Initialize-SeparateExampleMocks -CommandName $commandName

                    $result = Invoke-Expression $example

                    $result | Should -BeTrue
                    Assert-SeparateExampleMocks -CommandName $commandName
                }
            }
        }
    }
}