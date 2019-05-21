function Test-AccountNumber
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$AccountNumber
    )

    [bool]($AccountNumber -match '^\d{8}$')
}