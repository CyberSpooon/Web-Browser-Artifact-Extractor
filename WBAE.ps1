##################################################
# Script Title: Web Browser Artifact Extractor
# Script File Name: 
# Author: CyberSpooon 
# Version: 0.0.1 (Unfinished)
# Date Created: 09/06/2023
# Last Modified: 09/09/2023
################################################## 

<#
.DESCRIPTION
    Copies all web locally stored web browser artifacts and dumps them in the Windows ATP downloads folder.
.PARAMETER a
    ← enter inputs here (if any, otherwise state None)
.PARAMETER b
    ← enter inputs here (if any, otherwise state None)
.EXAMPLE
    PS> .\template.ps1 ← enter example here (repeat this attribute for more than one example)
.NOTES
   
#>

<#
param
(
    [Parameter(HelpMessage = 'Removes all log and report files of previous scans')]
    [ValidateNotNullOrEmpty()]
    [Alias('C')]
    [switch]$Cleanup
)
#>

# ---------------------------------------------------------------------
# Defining artifact paths and other variables -------------------------
# ---------------------------------------------------------------------
# Gethostname
$Hostname = [System.Net.Dns]::GetHostName()

# Get logged on user
$HostnameUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$username = $HostnameUsername.split('\')[1]

# date/time info
$datetime = $(Get-Date -Format 'yyyy-MM-dd_HHmm')

# declare output path
$outputdir = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($Hostname)_$($datetime)\"
# "~\OneDrive\Documents\Alden\Powershell Scripts\testFolder\$($Hostname)_$($datetime)\"

# Google Chrome browser artifact paths
$chromeArtifactPath = "C:\Users\$($username)\AppData\Local\Google\Chrome\User Data\Default"
# $macOSchromeArtifactPath = "C:\Users\<Your Username>\AppData\Local\Google\Chrome\User Data\Default"

# Mozilla Firefox browser artifact paths
# $firefoxArtifactPath = "C:\Users\$($username)\AppData\Roaming\Mozilla\Firefox\Profiles"\*.default-release

# Microsoft Edge browser artifact paths
$edgeArtifactPath = "C:\Users\$($username)\AppData\Local\Microsoft\Edge\User Data\Default"

Write-Host "                _____     __           ____                        _        _      __    __                    "
Write-Host "               / ___/_ __/ /  ___ ____/ __/__  ___  ___  ___  ___ ( )___   | | /| / /__ / /                    "
Write-Host "              / /__/ // / _ \/ -_) __/\ \/ _ \/ _ \/ _ \/ _ \/ _ \|/(_-<   | |/ |/ / -_) _ \                   "
Write-Host "              \___/\_, /_.__/\__/_/ /___/ .__/\___/\___/\___/_//_/ /___/   |__/|__/\__/_.__/                   "
Write-Host "   ___            /___/              __/_/     __  _ ___         __     ____     __               __           "
Write-Host "  / _ )_______ _    _____ ___ ____  / _ | ____/ /_(_) _/__ _____/ /_   / __/_ __/ /________ _____/ /____  ____ "
Write-Host " / _  / __/ _ \ |/|/ (_-</ -_) __/ / __ |/ __/ __/ / _/ _ \/ __/  __/ / _/ \ \ / __/ __/ _ \/ __/ __/ _ \/ __/ "
Write-Host "/____/_/  \___/__,__/___/\__/_/   /_/ |_/_/  \__/_/_/ \_,_/\__/\__/  /___//_\_\\__/_/  \_,_/\__/\__/\___/_/    "
Write-Host "                                                                                                               "
Write-Host "==============================================================================================================="
Write-Host "                                                                                                               "

# ---------------------------------------------------------------------
# Browser Functions ---------------------------------------------------
# ---------------------------------------------------------------------
# Google function
function chromeArtifacts 
{
    if (Test-Path -Path $chromeArtifactPath)
    {
        # Copy the Chrome artifacts to the destination directory
        Write-Host "Copying Chrome web artifacts..."
        Copy-Item -Path $chromeArtifactPath -Destination $outputdir -Recurse -Force
        Write-Host "Chrome web artifacts copied to" $outputdir
    } 
    else 
    {
        Write-Host "No Chrome web artifacts found"
    }
}

#Firefox function
function firefoxArtifacts 
{
    if (Test-Path -Path $firefoxArtifactPath)
    {
        # Copy the Chrome artifacts to the destination directory
        Write-Host "Copying Firefox web artifacts..."
        Copy-Item -Path $chromeArtifactPath -Destination $outputdir -Recurse -Force
        Write-Host "Firefox web artifacts copied to" $outputdir
    } 
    else 
    {
        Write-Host "No Firefox web artifacts found"
    }
}

#Edge function
function edgeArtifacts 
{
    if (Test-Path -Path $edgeArtifactPath)
    {
        # Copy the Chrome artifacts to the destination directory
        Write-Host "Copying Edge web artifacts..."
        Copy-Item -Path $edgeArtifactPath -Destination $outputdir -Recurse -Force
        Write-Host "Edge web artifacts copied to" $outputdir
    } 
    else 
    {
        Write-Host "No Edge web artifacts found"
    }
}

# ---------------------------------------------------------------------
# Main ----------------------------------------------------------------
# ---------------------------------------------------------------------
if (-not (Test-Path -Path $outputdir -Exclude $Hostname))   #$($Hostname)_$($datetime)\"
{
    chromeArtifacts
    edgeArtifacts
    firefoxArtifacts
} 
else 
{
    Write-Host "Cannot start new extraction as long as old extracted files are present"
    Write-Host "Use the following command to cleanup the output directory and remove all previous reports"
    Write-Host "run WBAE.ps1 -parameters `"-Cleanup`""
}