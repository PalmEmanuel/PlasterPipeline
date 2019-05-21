function New-MoneyTransaction
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [int]$Amount,

        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(!(Test-AccountNumber $_))
            {
                throw 'Please provide a valid account number containing exactly 8 digits!'
            }
            $true
        })]
        [string]$FromAccountNumber,

        [Parameter(
            Mandatory,
            Position = 2,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(!(Test-AccountNumber $_))
            {
                throw 'Please provide a valid account number containing exactly 8 digits!'
            }
            $true
        })]
        [string]$ToAccountNumber
    )

    if ($Amount -lt 1 -or $Amount -gt 500)
    {
        throw "The amount is larger than what is supported, please contact the bank!"
    }

    Remove-MoneyFromAccount -AccountNumber $FromAccountNumber -Amount $Amount
    Add-MoneyToAccount -AccountNumber $ToAccountNumber -Amount $Amount
}