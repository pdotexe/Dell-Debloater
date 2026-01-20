<#
.NOTES 
Author: prestigious
#>


<#
.SYNOPSIS 

A PowerShell script to remove unwanted Dell bloatware from Windows systems.
includes common applications pre-installed in Dell computers which use up extensive memory and CPU resources
#>


<#
.DESCRIPTION
 identifies and uninstalls pre-installed Dell + Windows applications, background processes, telemetry, and registry paths that are often considered bloatware.
 Targets specific Dell/Microsoft applications and removes them to improve system performance, user experience, and privacy
 #>



. "$PSScriptRoot\telemetry.ps1"
. "$PSScriptRoot\packages.ps1"


# check for administrator rights
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)
if(-not$principal.isInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Host "Run this script as administrator..."
    pause
    exit 1 
}

function Remove-Packages() { 
    [CmdletBinding()]
    param(
        [switch]$RemoveDellware,
        [switch]$RemoveTelemetry
        )
    
    
    
    
    
    if($RemoveDellware){
    try{
    Stop-Waves -ErrorAction SilentlyContinue
    Microsoft-Apps -ErrorAction SilentlyContinue
    Registry-Paths -ErrorAction SilentlyContinue
    Support-Assist -ErrorAction SilentlyContinue
    Remove-Targets -ErrorAction SilentlyContinue
    Service-Targets -ErrorAction SilentlyContinue
    }
    catch {
        Write-Error "Processes and items could not be removed $($_.Exception.Message)"
    }
    }
    ElseIf($RemoveTelemetry){
        try{
            Telemetry-Data
        }
        catch{
            Write-Error "Telemetry could not be removed: $($_.Exception.Message)"
        }
        
    }
}






Write-Host "[1] Debloat" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[2] Remove Telemetry" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[3] Review removed items" -ForeGroundColor  Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[4] Exit" -ForeGroundColor Yellow


Write-Host "CHANGES CAN NOT BE REVERSED. REVIEW WHAT WILL BE REMOVED WITH OPTION 3" -ForegroundColor Black


while($true){
    $choice = Read-Host "Enter your choice (1-3)"
    
    if ($choice -eq "1") {
        Remove-Packages -RemoveDellware -ErrorAction SilentlyContinue
    }
    
    elseif ($choice -eq "2") {
        Remove-Packages -RemoveTelemetry -ErrorAction SilentlyContinue
    }
    elseif ($choice -eq "4") {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    elseif ($choice -eq "3"){
    if(Test-Path "$PSScriptRoot\..\removeditems.txt"){
    Get-Content "$PSScriptRoot\..\removeditems.txt"
    }
    }
    else{
        Write-Host "Invalid Option" -ForeGroundColor Red
    }
}


















