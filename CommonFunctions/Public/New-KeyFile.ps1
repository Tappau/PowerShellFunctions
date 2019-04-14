<#
.SYNOPSIS
    Create a new key and saves it to a file.
.DESCRIPTION
    function provides the ability to create a 'key' file
.PARAMETER KeyFile
Full path to file that the key will be saved.
.PARAMETER KeySize
Desiried keysize, requires value to be 16, 24 or 32.
.PARAMETER Force
Specify this to overwrite the KeyFile if it already exists.
.EXAMPLE
    New-KeyFile -KeyFile C:\KeyFile.key -KeySize 16
    Generate a 16 byte[] key and saves it to C:\KeyFile.key
#>
function New-KeyFile {
    param (
        [string]$KeyFile,
        [ValidateSet(16,24,32)]
        [int]$KeySize,
        [switch] $Force
    )
    if((Test-Path $KeyFile) -and (-not $Force)){
        throw "File path already exists, use [-Force] if you wish to overwrite."        
    }
    $generatedKey = New-Object byte[] $KeySize
    [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($generatedKey)
    $generatedKey | Out-File $KeyFile    
}