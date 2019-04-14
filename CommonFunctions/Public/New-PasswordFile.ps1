<# 
.SYNOPSIS 
    Creates a new password file.    
.DESCRIPTION 
    Creates a password file with the encrypted value based on the Key provided.
.PARAMETER PwdFile
    Full path to file that the "password" will be saved.
.PARAMETER Password
    Password value to be encrypted, if no value is passed in will prompt for a SecureString pasword using Read-Host
.PARAMETER Key
    Key to be used for encrypting the password.
.PARAMETER Force
    Specifying will force the provided PwdFile to be overwritten if it already exist.
.EXAMPLE   
    New-PasswordFile -PwdFile C:\MyPassword.txt -Key (Get-Content C:\MyKey.key)
    
    Description
    Encryptes the provided password with the key found in C:\MyKey.key, and saves to C:\MyPassword.txt
.EXAMPLE   
    $pwd = Get-Credential
    New-PasswordFile -PwdFile C:\MyPassword.txt -Password ($pwd.GetNetworkCredential().SecurePassword) -Key (Get-Content C:\MyKey.key)
    
    Description
    Captures the password provided in Get-Credential.
    Encrypts the password provided in $pwd with the key found in C:\MyKey.key, and saves to C:\MyPassword.txt
    #>	
function New-PasswordFile {
    param(
        [string]$PwdFile,
        [SecureString]$Password = (Read-Host -Prompt "Enter the password to add to the file" -AsSecureString),
        [Byte[]]$Key,
        [switch]$Force
    )
    
    if ( (Test-Path $PwdFile) -and (-not $Force) ) {
        throw "File path provided already exist, use [-Force] if you wish to overwrite the file."
    }
    
    ConvertFrom-SecureString -SecureString $Password -Key $Key | Out-File $PwdFile
}