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
.PARAMETER DateFormat
Determines the format for the DateTime stamp to be output in. Default value is dd/MM/yyyy HH:mm:ss
.EXAMPLE
Write-Log -Level ERROR -Message "Cannot find the file you specified" -LogFile C:\Logs\log.txt
Will write the message to the logfile provided

.EXAMPLE
Write-Log -Message "Starting Foo..." -LogFile C:\Logs\FooLog.log -AndTerminal
Will write "<timestamp> [INFO]  Starting Foo..." to logfile specified and also to screen.

.EXAMPLE
Write-Log -Message "Starting Foo..." -LogFile C:\Logs\FooLog.txt -DateFormat "yyyy-MM-dd"
Will write <timestamp> [INFO] Starting Foo... to logfile specified, where <timestamp> will be in stated format

.NOTES
Work in progress, can definitly be improved...
    1. Add ability to recieve input from pipe, in order to support redirecting to well formed log      
#>
function Write-Log {
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO", "WARN", "ERROR", "FATAL", "DEBUG")]
        [string] $Level = "INFO",
        
        [Parameter(Mandatory=$true)]
        [string] $Message, 

        [Parameter(Mandatory=$true)]
        [ValidateScript({
            if(-not ($_ | Test-Path)){ throw "File does not exist."}
            if(-not ($_ | Test-Path -PathType Leaf)){throw 'The path argument must of a file. Folder paths are not allowed.'}
            if($_ -notmatch "(\.log|\.txt)"){throw new 'The file specified in the path must be either of type .log or .txt'}
            return $true
        })]
        [System.IO.FileInfo] $Logfile,
        [switch] $AndTerminal,

        [string] $DateFormat = "dd/MM/yyyy HH:mm:ss"
    )
    
    $timestamp = (Get-Date).ToString($DateFormat)
    $logString = "$timestamp `t[$Level]`t$Message"

    $logString | Out-File -FilePath $Logfile -Append
    if($AndTerminal){
        switch ($Level) {
            "WARN" { Write-Host $logString -ForegroundColor DarkYellow }
            {$_ -in "ERROR", "FATAL"} {Write-Host $logString -ForegroundColor Red}
            "DEBUG" {Write-Host $logString -ForegroundColor Gray}
            Default {Write-Host $logString}
        }
    }    
}