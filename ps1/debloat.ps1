<#
.NOTES 
Github : https://github.com/pdotexe
Version: 1
#>


.SYNOPSIS 

<# A PowerShell script to remove unwanted Dell bloatware from Windows systems.
includes common applications pre-installed in Dell computers which use up extensive memory and CPU resources
#>





.DESCRIPTION
<# identifies and uninstalls pre-installed Dell + Windows applications that are often considered bloatware.
 targets specific Dell applications and removes them to improve system performance and user experience.
 #>

#Requires -RunAsAdministrator

Import-Module telemetry
Import-Module getpackages





Write-Host "[1] Use Dell Debloat (Quick Cleanup)" -ForeGroundColor Blue
Write-Host "-----------------------------------"
Write-Host"[2] Use Win11-Debloat" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host"[3] Remove Telemetry" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[4] Exit" -ForeGroundColor Yellow

Write-Host " For information , run ./debloat.ps1 -Info"


$choice = Read-Host "Please enter your choice (1-4)"

if ($choice -eq 4){ 
    exit
} ElseIf ($choice -eq 2){

    Remove-Packages -BasicRemoval -ErrorAction SilentlyContinue
} 
    ElseIf($choice -ne 1 -or $choice -ne 2 -or $choice -ne 3 -or $choice -ne 4){
    throw "Invalid Choice option." -ForegroundColor Red
}
ElseIf ( $choice -eq 3){
    Write-Host "Note: This will not remove 100% of Telemetry, as some is baked into the Kernel" -ForeGroundColor Red
    Write-Host "Working..." -ForeGroundColor Green
    continue
}
ElseIf ($choice -eq 1){
    Remove-Packages -RemoveDellware -ErrorAction SilentlyContinue
}









function Info{
    Clear-Host
    Write-Host @"
    Usage:

There are three options to choose from. 

If choose Dell Debloat, you may customize the packages or installations that will you wish to remove. Not everything is included for safety reasons. 

There is also a telemetry disabler, and a link to a seperate open-source script to combine power.



"@
}






function Remove-Packages() { 
    [CmdletBinding()]
    param(
    [switch]$RemoveDellWare
    [switch]$RemoveTelemetry
    [switch]$BasicRemoval
) 
    if($RemoveDellWare){
function stopWaves(){
try{
Stop-Service -Name WavesSysSvc -Force
Set-Service -Name WavesSysSvc -StartupType Disabled

}
catch{
try{
Stop-Service -Name WavesAudioEngineService -ErrorAction SilentlyContinue
Set-Service -Name WavesAudioEngineService -StartupType Disabled\}
catch{Write-Output "no service found" -ForeGroundColor Black}
}
Set-Service PrintNotify -StartupType Disabled
Set-Service MapsBroker -StartupType Disabled

Set-Service XblAuthManager -StartupType Disabled
Set-Service XblGameSave -StartupType Disabled
Set-Service XboxNetApiSvc -StartupType Disabled
}
stopWaves
    }
    ElseIf($RemoveTelemetry){
        Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force

    function ScheduledTasks() {
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
    }

    ScheduledTasks


 
    ElseIf($BasicRemoval){
        Write-Information "This function makes a web request. Make sure you are connected to the internet. Credit to this repository goes to https://github.com/Raphire/Win11Debloat "
        $tempFolder = Join-Path $env:TEMP "Win11Debloat" 
        if (Test-Path $tempFolder) 
        {
            Remove-Item $tempFolder -Recurse -Force
        }
        New-Item -ItemType Directory -Path $tempFolder | Out-Null


    $zipUrl = "https://github.com/Raphire/Win11Debloat/archive/refs/heads/master.zip"
    $zipFile = Join-Path $tempFolder "Win11Debloat.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile


    #Extract ZIP
    Expand-Archive -path $zipFile -DestinationPath $tempFolder

    #run
    $repoFolder = Join-Path $tempFolder "Win11Debloat-master"
   Try{
    cmd.exe /c (Join-Path $repoFolder "Run.bat")
   }

    Finally {
    Remove-Item $tempFolder -Recurse -Force }
    }

}












# get dell packages
# get other packages
# get telemetry details
# call seperate script for the "basic removal"
