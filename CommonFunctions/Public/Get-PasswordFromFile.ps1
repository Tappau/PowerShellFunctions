<#
.SYNOPSIS 
Pulls in the password as a SecureString.
.DESCRIPTION 
Pulls the encrypted password utilizing the key file provided to output a SecureString.
.PARAMETER PwdFile
Full path to file that the "password" is saved.
.PARAMETER KeyFile
Full path to file that the "key" is saved.

.EXAMPLE   
Get-SecurePassword -PwdFile C:\MyPassword.txt -KeyFile C:\MyKey.key

Retrieves the password found in C:\MyPassword.txt and decrypts it using the key found in C:\MyKey.key. 
Outputs the SecureString object to be used in a PSCredential object.
#>
function Get-PasswordFromFile {
    param (
        [System.IO.FileInfo]$PwdFile,
        [System.IO.FileInfo]$KeyFile
    )
    if ( !(Test-Path $PwdFile) ) {
        throw "Password File provided does not exist."
    }
    if ( !(Test-Path $KeyFile) ) {
        throw "KeyFile was not found."
    }

    $keyValue = Get-Content $KeyFile
    return (Get-Content $PwdFile | ConvertTo-SecureString -Key $keyValue)    
}