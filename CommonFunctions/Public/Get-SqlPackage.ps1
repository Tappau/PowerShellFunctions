function Get-SqlPackage {
    param (
       
    )
    $DefaultSqlInstallDir = "C:\Program Files (x86)\Microsoft SQL Server"
    
    if (-not(Test-Path $DefaultSqlInstallDir)) {
        throw [System.IO.DirectoryNotFoundException] "$DefaultSqlInstallDir not found."
    }
    $exe = (Get-ChildItem $DefaultSqlInstallDir -Include "sqlpackage.exe" -Recurse).FullName
    
    if ($exe.Count -gt 1) {
        return $exe[$exe.Count - 1] ##Return last match in array.
    }elseif ($exe.Count -le 0) {
        throw "SqlPackage.exe not found"
    }
    else {
        return $exe
    }
}