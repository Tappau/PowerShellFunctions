function Get-MsBuild {
    param (
        [int] $MaxVersion = 2017
    )

    $2017BuildTools = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\msbuild.exe"
    $2017Enterprise = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"
    $2017Professional = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\msbuild.exe"
    $2017Community = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
    $fallback2015Path = "${Env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"
    $fallback2013Path = "${Env:ProgramFiles(x86)}\MSBuild\12.0\Bin\MSBuild.exe"
    $fallbackPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319"
		
    If ((2017 -le $MaxVersion) -And (Test-Path $2017BuildTools)) { return $2017BuildTools } 
    If ((2017 -le $MaxVersion) -And (Test-Path $2017Enterprise)) { return $2017Enterprise } 
    If ((2017 -le $MaxVersion) -And (Test-Path $2017Professional)) { return $2017Professional } 
    If ((2017 -le $MaxVersion) -And (Test-Path $2017Community)) { return $2017Community } 
    If ((2015 -le $MaxVersion) -And (Test-Path $fallback2015Path)) { return $fallback2015Path } 
    If ((2013 -le $MaxVersion) -And (Test-Path $fallback2013Path)) { return $fallback2013Path } 
    If (Test-Path $fallbackPath) { return $fallbackPath } 
        
    throw "Unable to find msbuild"
}