function Remove-MoneyFromAccount
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$AccountNumber,

        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipelineByPropertyName)]
        [ValidateRange(1,500)]
        [int]$Amount
    )

    Write-Verbose "Removing $Amount moneys from account $AccountNumber."
}