<#
.SYNOPSIS
    Will display a prompt until a y/n response is provided.
.DESCRIPTION
    Will prompt user for confirmation expecting y/n answer and returning that as a boolean
.PARAMETER Message
    The text that should be shown will be appended with (Y/N) ?
.EXAMPLE
    Show-ConfirmationPrompt "Do you wish to continue"
    Will display as Do you wich to contine (Y/N) ?
    returns $true if Y/y otherwise $false
#>
function Show-ConfirmationPrompt {
    param (
        [string]$Message
    )
    do {
        $reply = Read-Host -Prompt ($Message + " (Y/N) ?")
    } until ("y","Y","n","N" -contains $reply)
    return ("y", "Y" -contains $reply)
}