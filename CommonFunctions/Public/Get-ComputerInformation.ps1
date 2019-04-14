function Get-ComputerInformation {
    [CmdletBinding()]
    param (
        $ComputerName
    )
    
    process {
        #Computer System
        $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName
        # Operating System
        $OperatingSystem = Get-WmiObject -Class Win332_OperatingSystem -ComputerName $ComputerName
        #BIOS
        $Bios = Get-WmiObject -Class Win32_BIOS -ComputerName $ComputerName

        ##Prepare some output
        $Properties = @{
            ComputerName          = $ComputerName
            Manufacturer          = $ComputerSystem.Manufacturer
            Model                 = $ComputerSystem.Model
            OperatingSystem       = $OperatingSystem.Caption
            OpertingSystemVersion = $OperatingSystem.Version
            SerialNumber          = $Bios.SerialNumber
        }

        ##Output results
        New-Object -typename PSobject -property $Propertiess
    }
}