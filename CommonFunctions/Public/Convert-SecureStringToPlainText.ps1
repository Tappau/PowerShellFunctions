function Convert-SecureStringToPlainText {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Security.SecureString]$SecurePassword
    )

    try {
        $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $plaintext = [Runtime.InteropServices.Marshal]::PtrToStringAuto($pointer)
        return $plaintext
    }
    finally {
        #release pointer
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    }    
}