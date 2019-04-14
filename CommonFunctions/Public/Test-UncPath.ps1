<#
.SYNOPSIS
    Test if a path is UNC
.DESCRIPTION
    Will return true if Path begins with \\
.PARAMETER Path
    Path of that is subject of test
.EXAMPLE
    Test-UncPath -Path "C:\Windows"
    Will return false as not a UNC Path
.EXAMPLE
    Test-UncPath -Path "\\localhost\C$\Windows"
    Will return true as not a UNC Path
#>
function Test-UncPath {
    param (
        [Parameter(Mandatory=$true)]
        $Path
    )
    if($Path.StartsWith("\\")){ return $true } else { return $false }    
}