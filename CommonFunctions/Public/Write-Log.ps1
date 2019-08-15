<#
.SYNOPSIS
    Will write string input to logfile provided, with formatted date time and log level.
.DESCRIPTION
    Will write a message to the logfile provided if doesn't exist will create then append from then on.
    Will display the message with execution timestamp (UK format) and loglevel

    This also has the option to print the same message to the host simultaneously
.PARAMETER Level
Log Level, default is 'INFO'
.PARAMETER Message
Message that should be printed
.PARAMETER LogFile
Path to the logfile, should end with .txt or .log
.PARAMETER AndTerminal
If provided, will also print the formatted log entry to current execution host instance.
.EXAMPLE
Write-Log -Level ERROR -Message "Cannot find the file you specified" -LogFile C:\Logs\log.txt
Will write the message to the logfile provided

.EXAMPLE
Write-Log -Message "Starting Foo..." -LogFile C:\Logs\FooLog.log -AndTerminal
Will write "<timestamp> [INFO]  Starting Foo..." to logfile specified and also to screen.

.NOTES
Work in progress, can definitly be improved...
    1. Add ability to recieve input from pipe, in order to support redirecting to well formed log
    2. Invoke some checking to ensure that the logfile is in .txt or .log format    
#>
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