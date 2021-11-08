# program description This program will gather information about a target computers system, installed programs, user accounts, OS, Bios, and Timezone.
# It will allow you to search for specifically what the user wants and Output the results to a file of the user's choice


# Parameters and input gathering for this program to see 
$ip_input = Read-host -Prompt "Please enter the target IP address, or . to run on this computer"
$installed_programs = Read-host -Prompt "Do you want to see all installed programs? (y/n)"
$installed_accounts = Read-host -Prompt "Do you want to see all accounts on this computer? (y/n)"
$installed_OS = Read-host -Prompt "Do you want to see the installed Operating system on this computer? (y/n)"
$installed_BIOS = Read-host -Prompt "Do you want to see all the BIOS information on this computer? (y/n)"
$installed_TZ = Read-host -Prompt "Do you want to see what timezone this computer is in? (y/n)"
$OutfilePath = Read-host -Prompt "Where do you want to save the Output of this script?"

# Functions
function get_comp_info {
    param($ip, $programs,$accounts,$OS,$BIOS,$TZ)
    
    # this is checking if the ip pattern is valid
    $pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
    $ip_address_real = $ip -match $pattern
    if ( -Not $ip_address_real -And $ip -eq ".") {
        $ip = "."
    }
    else {
        throw "There was an error with one of your inputs related to the ip address, please try again"
    }
    
    # this will Output information relating to the basic computer system
    Write-Output "###############################################################################################################"
    Write-Output "COMPUTER SYSTEM Info:"
    Write-Output "###############################################################################################################"
    Get-WmiObject -Class Win32_computerSystem -ComputerName $ip
    Write-Output "###############################################################################################################"
        

    if ( $BIOS -eq "y") {
        # this will Output information relating to the BIos of this computer
        Write-Output "BIOS Info:"
        Write-Output "###############################################################################################################"
        Get-WmiObject -Class Win32_bios -ComputerName $ip
        Write-Output "###############################################################################################################"
    } 

    if ( $accounts -eq "y") {
        # this will Output information relating to the accounts on this computer
        Write-Output "ACCOUNTS ON THIS COMPUTER:"
        Write-Output "###############################################################################################################"
        Get-WmiObject -Class Win32_UserAccount -ComputerName $ip
        Write-Output "###############################################################################################################"
    }
    
    if ( $OS -eq "y") {
        # this will Output information relating to the operating system
        Write-Output "OPERATING SYSTEM:"
        Write-Output "###############################################################################################################"
        Get-WmiObject -Class Win32_operatingSystem -ComputerName $ip
        Write-Output "###############################################################################################################"
    }
    
    if ( $TZ -eq "y") {
        # this will Output information relating to the computers timezone
        Write-Output "WHAT TIMEZONE Info:"
        Write-Output "###############################################################################################################"
        Get-WmiObject -Class Win32_SystemTimeZone -ComputerName $ip
        Write-Output "###############################################################################################################"
    }

    if ( $programs -eq "y") {
        # this will Output information relating to the programs installed on this computer
        Write-Output "PROGRAMS INSTALLED ON THIS IP address: "
        Write-Output "###############################################################################################################"
        Get-WmiObject -Class win32_Product -ComputerName $ip
        Write-Output "###############################################################################################################"
    }
    
}

#This will Output the info to the command line.
get_comp_info -ip $ip_input -programs $installed_programs -accounts $installed_accounts -BIOS $installed_BIOS -TZ $installed_TZ -OS $installed_OS

#this will Output the info to a file to whatever the user named 
get_comp_info -ip $ip_input -programs $installed_programs -accounts $installed_accounts -BIOS $installed_BIOS -TZ $installed_TZ -OS $installed_OS | Out-File -FilePath $OutfilePath 
