# PowerShell Functions
A dynamic module of functions I have utilised/needed at somepoint or other.

## List of functions

| Function                        | Info                                                                                                                                                                                                                   |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Convert-SecureStringToPlainText | Will Convert a [securesting] to PlainText                                                                                                                                                                              |
| Convert-ToUnc                   | Will Convert any Full Path to a UNC Path given a -ComputerName                                                                                                                                                         |
| Get-ComputerInformation         | Will display a table of results                                                                                                                                                                                        |
| Get-MsBuild                     | Will return the full path to given msbuild if not able will return default msbuild at %windir%\Microsoft.Net\                                                                                                          |
| Get-SqlPackage                  | Return full path to sqlpackage.exe                                                                                                                                                                                     |
| Get-UserSetVariables            | Will display a list of all the user defined variables within current session                                                                                                                                           |
| Invoke-Sql                      | Will execute using Integrated security if no user/password infomation is passed. Capable of executing non-query, and fully supports query parameters. Will return a list of custom objects to enable further PS querys |
| Show-ConfirmationPrompt         | Will display message as question, returning $true/$false upon entry of (y/n) is case-insensitive                                                                                                                       |
| Test-UncPath                    | Will return if if given path begins with '\\\\'                                                                                                                                                                        |
| Write-Log                       | Allows writing to screen and log, defaults to [INFO] but can be any.                                                                                                                                                   |