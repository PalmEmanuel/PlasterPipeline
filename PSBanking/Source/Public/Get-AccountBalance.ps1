function Get-AccountBalance
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(!(Test-AccountNumber $_))
            {
                throw 'Please provide a valid account number containing exactly 8 digits!'
            }
            $true
        })]
        [string]$AccountNumber
    )

    Get-Random 5000
}