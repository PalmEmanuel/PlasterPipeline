param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleName = (Get-Item "$ModulePath\..").Name
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }

    It 'Loads from module path without errors' {
        { Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop } | Should -Not -Throw
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }
}

Describe "$ModuleName Function Tests" -Tag 'Unit' {
    BeforeAll {
        Import-Module "$ModulePath\$ModuleName.psd1"
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

    # Private functions tests in module scope
    InModuleScope $ModuleName {
        Context 'Test-AccountNumber' {
            It 'Is true when correct format' {
                Test-AccountNumber '12345678' | Should -BeTrue
            }
            It 'Is false when incorrect format' {
                Test-AccountNumber 'abc123' | Should -BeFalse
            }
        }

        Context 'Add-MoneyToAccount' {
            It 'Does not throw with correct values' {
                { Add-MoneyToAccount -AccountNumber '12345678' -Amount 250 } | Should -Not -Throw
            }
            It 'Throws with too high amount' {
                { Add-MoneyToAccount -AccountNumber '12345678' -Amount 750 } | Should -Throw
            }
            It 'Throws with negative amount' {
                { Add-MoneyToAccount -AccountNumber '12345678' -Amount -50 } | Should -Throw
            }
        }

        Context 'Remove-MoneyFromAccount' {
            It 'Does not throw with correct values' {
                { Remove-MoneyFromAccount -AccountNumber '12345678' -Amount 250 } | Should -Not -Throw
            }
            It 'Throws with too high amount' {
                { Remove-MoneyFromAccount -AccountNumber '12345678' -Amount 750 } | Should -Throw
            }
            It 'Throws with negative amount' {
                { Remove-MoneyFromAccount -AccountNumber '12345678' -Amount -50 } | Should -Throw
            }
        }
    }

    # Public function tests
    Context 'Get-AccountBalance' {
        It 'Does not throw with correct values' {
            $Balance = Get-AccountBalance '12345678'

            $Balance | Should -BeGreaterOrEqual 0
            $Balance | Should -BeLessOrEqual 5000
        }
        It 'Throws with incorrect account number format' {
            { Get-AccountBalance 'abc123' } | Should -Throw
        }
    }

    Context 'New-MoneyTransaction' {
        # Another way to manage private functions in tests
        Mock 'Add-MoneyToAccount' -ModuleName $ModuleName -MockWith {} -Verifiable
        Mock 'Remove-MoneyFromAccount' -ModuleName $ModuleName -MockWith {} -Verifiable

        It 'Adds and removes money and does not throw with correct calues' {
            { New-MoneyTransaction 250 '12345678' '87654321' } | Should -Not -Throw
        }

        Assert-VerifiableMock

        It 'Throws with incorrect values' {
            { New-MoneyTransaction 750 'abc123' 'def456' }
        }
    }
}