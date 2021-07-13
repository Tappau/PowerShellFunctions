<#
.SYNOPSIS
    Will return full path to the installutil.exe on the executing machine
.DESCRIPTION
    Will retrive full path to installutil.exe as not available as standard in %PATH%
.PARAMETER x86
    If provided will retrieve the x86 (32bit) version
.EXAMPLE
    Set-Alias installutil (Get-InstallUtil)
    Will set an alias installutil to have the value returned by this function.
#>
function Get-InstallUtil {
    param(
        [switch] $x86
    )

    $runTimeDir = [System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
    $exe = Resolve-Path (Join-Path $runTimeDir 'installutil.exe')

    if($x86){
        return $exe.Path.Replace('Framework64', 'Framework')
    }
    else{
        return $exe.Path
    }
}