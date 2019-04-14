$root = Split-Path $PSCommandPath -Parent
$ModuleName = "CommonFunctions"
$Author = "Tappau"
$Description = "Powershell module of helpful tasks, I've required at somepoint"

#Create the module and related files
New-ModuleManifest -Path $root\$ModuleName.psd1 `
    -RootModule $root\$ModuleName.psm1 `
    -Description $Description `
    -powershellVersion 4.0 `
    -Author $Author `
    -ModuleVersion '1.0' `
    -ProjectUri "http://github.com/Tappau/PowerShellFunctions"