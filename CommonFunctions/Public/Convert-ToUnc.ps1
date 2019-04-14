function Convert-ToUnc {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [ValidateScript( {
                if (Test-Connection -ComputerName $_ -Quiet -Count 1) {
                    $true
                }
                else {
                    throw "The computer $($_) is not available"
                }
            })]
        [string] $ComputerName
    )

    $Drive = (Split-Path $Path -Qualifier).Split(":")[0]
    return Join-Path -Path "\\" -ChildPath (Join-Path -Path $ComputerName -ChildPath (Join-Path -Path "$Drive$" -ChildPath (Split-Path -Path $Path -NoQualifier)))
}

