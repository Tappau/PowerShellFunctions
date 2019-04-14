function Write-Log {
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO", "WARN", "ERROR", "FATAL", "DEBUG")]
        [string] $Level = "INFO",
        
        [Parameter(Mandatory=$true)]
        [string] $Message, 

        [Parameter(Mandatory=$true)]
        [string] $Logfile,

        [switch] $AndTerminal
    )
    
    $timestamp = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
    $logString = "$timestamp `t[$Level]`t$Message"

    Out-File -FilePath $Logfile -Append $logString
    if($AndTerminal){
        switch ($Level) {
            "WARN" { Write-Host $logString -ForegroundColor DarkYellow }
            {$_ -in "ERROR", "FATAL"} {Write-Host $logString -ForegroundColor Red}
            "DEBUG" {Write-Host $logString -ForegroundColor Gray}
            Default {Write-Host $logString}
        }
    }
    
}