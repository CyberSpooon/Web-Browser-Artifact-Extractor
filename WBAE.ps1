##################################################
# Script Title: Web Browser Artifact Extractor
# Author: CyberSpooon 
# Version: 1.0
# Date Created: 09/06/2023
# Last Modified: 11/26/2023
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
# $domainUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
# $username = $domainUsername.split('\')[1]

# Get date/time info
$datetime = $(Get-Date -Format 'yyyy-MM-dd_HHmm')

# Declare output path to MDE downloads directory and create it
$MDEDownloadsDir = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($hostname)_$($datetime)"

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
	$defaultChromePath = Resolve-Path -Path "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default"
	$defaultChromeHistoryPath = Resolve-Path -Path "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\History"
	# $defaultChromeHistoryPathMacOS = "C:\Users\<Your Username>\AppData\Local\Google\Chrome\User Data\Default"
	
    if (-not (Test-Path -Path $defaultChromePath))
    {
	Write-Host "ERROR: The default file path for Google Chrome cannot be found!"
 	Write-Host "The specified path was: $($defaultChromePath)"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Chrome history from $($defaultChromePath)..."
        Start-Sleep -Seconds 1.5
        [void] (New-Item -Path "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($hostname)_$($datetime)" -Name "Chrome" -ItemType "directory")
        Copy-Item $defaultChromeHistoryPath -Destination "$($MDEDownloadsDir)\Chrome"
        Write-Host "Chrome browser history copied to:" $MDEDownloadsDir
        Write-Host ""
    }
}

#Firefox functions
function firefoxHistory
{
	# Mozilla Firefox browser artifact paths
  	$defaultFirefoxPath = Get-ChildItem C:\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\* | sort LastWriteTime | select -last 1
   	$newestFirefoxPath = ($defaultFirefoxPath.FullName)
    	$defaultFirefoxHistoryPath = Resolve-Path -Path "$($newestFirefoxPath)\places.sqlite"
	# $defaultFirefoxHistoryPathMacOS = 
	
    if (-not (Test-Path -Path $defaultFirefoxPath))
    {
	Write-Host "ERROR: The default file path for Mozilla Firefox cannot be found!"
 	Write-Host "The specified path was: $($defaultFirefoxPath)"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Firefox history from $($defaultFirefoxPath)..."
        Start-Sleep -Seconds 1.5
        [void] (New-Item -Path "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($hostname)_$($datetime)" -Name "Firefox" -ItemType "directory")
        Copy-Item -Path $defaultFirefoxHistoryPath -Destination "$($MDEDownloadsDir)\Firefox"
        Write-Host "Firefox browser history copied to:" $MDEDownloadsDir
        Write-Host ""
    }
}

#Edge functions
function edgeHistory
{
	# Microsoft Edge browser artifact paths
	$defaultEdgePath = Resolve-Path -Path "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\Default"
	$defaultEdgeHistoryPath = Resolve-Path -Path "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\Default\History"

    if (-not (Test-Path -Path $defaultEdgePath))
    {
	Write-Host "ERROR: The default file path for Microsoft Edge cannot be found!"
 	Write-Host "The specified path was: $($defaultEdgePath)"
	Write-Host "Canceling execution..."
	return
    } 
    else 
    {
        Write-Host "Copying Edge history from $($defaultEdgePath)..."
        Start-Sleep -Seconds 1.5
        [void] (New-Item -Path "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\$($hostname)_$($datetime)" -Name "Edge" -ItemType "directory")
        Copy-Item $defaultEdgeHistoryPath -Destination "$($MDEDownloadsDir)\Edge"
        Write-Host "Edge browser history copied to:" $MDEDownloadsDir
        Write-Host ""
    }
}

# ---------------------------------------------------------------------
# Main ----------------------------------------------------------------
# ---------------------------------------------------------------------
if (($Chrome) -and ($History))
{
	chromeHistory
}

if (($Firefox) -and ($History))
{
	firefoxHistory
}

if (($Edge) -and ($History))
{
	edgeHistory
}
