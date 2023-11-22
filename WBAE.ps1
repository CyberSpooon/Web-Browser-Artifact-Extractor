##################################################
# Script Title: Web Browser Artifact Extractor
# Script File Name: 
# Author: CyberSpooon 
# Version: 0.0.1 ***UNFINISHED***
# Date Created: 09/06/2023
# Last Modified: 11/19/2023
################################################## 

<#
.DESCRIPTION
    Copies locally stored web browser artifacts and dumps them in the Windows ATP downloads folder.
.PARAMETER Chrome
	Sets script to only collect specified artifacts from Google Chrome.
.PARAMETER Edge
	Sets script to only collect specified artifacts from Microsoft Edge.
.PARAMETER Firefox
	Sets script to only collect specified artifacts from Mozilla Firefox.
.PARAMETER History
	Collects browser history of the specified web browser
# WORK IN PROGRESS PARAMETERS
.PARAMETER Cookies
.PARAMETER Extensions
.PARAMETER AllArtifacts
	
.EXAMPLE
	Run script from Microsoft Defender for Endpoint Live Response connection:	
    	C:\> run WBAE.ps1 -parameters ""-Chrome"" -""History""
.EXAMPLE 
	Run script on local machine:	
	C:\> ./WBAE.ps1 -Chrome -History
.NOTES
	This is still a work in progress script. At the moment it only supports pulling browser history from Edge, Firefox, and Chrome but further functionality will be added
#>

param 
(
    [Parameter(HelpMessage = 'Collect browser artifacts from Google Chrome')]
    [ValidateNotNullOrEmpty()]
    [Alias('C')]
    [switch]$Chrome,
    
    [Parameter(HelpMessage = 'Collect browser artifacts from Microsoft Edge')]
    [ValidateNotNullOrEmpty()]
    [Alias('E')]
    [switch]$Edge,
    
    [Parameter(HelpMessage = 'Collect browser artifacts from Mozilla Firefox')]
    [ValidateNotNullOrEmpty()]
    [Alias('F')]
    [switch]$Firefox,
    
    [Parameter(HelpMessage = 'Collect browser history of the specified web browser')]
    [ValidateNotNullOrEmpty()]
    [Alias('H')]
    [switch]$History
)

# ---------------------------------------------------------------------
# Defining artifact paths and other variables -------------------------
# ---------------------------------------------------------------------
# Gethostname
$hostname = [System.Net.Dns]::GetHostName()

# Get logged on user
$domainUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$username = $domainUsername.split('\')[1]

# Get date/time info
$datetime = $(Get-Date -Format 'yyyy-MM-dd_HHmm')

# Declare output path to MDE downloads directory
$MDEDownloadsDir = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($hostname)_$($datetime)\"
# "C:\Users\Alden.James\ps_script_testing\$($hostname)_$($datetime)\"

Write-Host "==============================================================================================================="
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
# Google functions
function chromeHistory
{
	# Google Chrome browser artifact paths
	$defaultChromePath = "C:\Users\$($username)\AppData\Local\Google\Chrome\User Data\Default"
	$defaultChromeHistoryPath = "C:\Users\$($username)\AppData\Local\Google\Chrome\User Data\Default\History"
	# $defaultChromeHistoryPathMacOS = "C:\Users\<Your Username>\AppData\Local\Google\Chrome\User Data\Default"
	
    if (-not (Test-Path -Path $defaultChromePath))
    {
	Write-Host "ERROR: The default file path for Google Chrome cannot be found!"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Chrome history..."
        Copy-Item -Path $defaultChromeHistoryPath -Destination $MDEDownloadsDir -Recurse -Force
        Write-Host "Chrome browser history copied to:" $MDEDownloadsDir
    }
}

#Firefox functions
function firefoxHistory
{
	# Mozilla Firefox browser artifact paths
	$defaultFirefoxPath = C:\Users\$($username)\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release
	# there also might be a second 'default-release-*' dir" "~/AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release-1"
	$defaultFirefoxHistoryPath = C:\Users\$($username)\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite
	# $defaultFirefoxHistoryPathMacOS = 
	
    if (-not (Test-Path -Path $defaultFirefoxPath))
    {
	Write-Host "ERROR: The default file path for Mozilla Firefox cannot be found!"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Firefox history..."
        Copy-Item -Path $defaultFirefoxHistoryPath -Destination $MDEDownloadsDir -Recurse -Force
        Write-Host "Firefox browser history copied to:" $MDEDownloadsDir
    }
}

#Edge functions
function edgeHistory
{
	# Microsoft Edge browser artifact paths
	$defaultEdgePath = "C:\Users\$($username)\AppData\Local\Microsoft\Edge\User Data\Default"
	$defaultEdgeHistoryPath = "C:\Users\$($username)\AppData\Local\Microsoft\Edge\User Data\Default\History"

    if (-not (Test-Path -Path $defaultEdgePath))
    {
	Write-Host "ERROR: The default file path for Microsoft Edge cannot be found!"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Edge history..."
        Copy-Item -Path $defaultEdgeHistoryPath -Destination $MDEDownloadsDir -Recurse -Force
        Write-Host "Edge browser history copied to:" $MDEDownloadsDir
    }
}

# ---------------------------------------------------------------------
# Main ----------------------------------------------------------------
# ---------------------------------------------------------------------
if (($Chrome) and ($History))
{
	chromeHistory
}
elseif ((Firefox and ($History))
{
	firefoxHistory
}
elseif (($Edge) and ($History))
{
	edgeHistory
}
