#Define import directory
$Public = @(Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)

#dot source all the files
foreach ($import in $Public) {
    try {
        .$import.fullname
    }
    catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName