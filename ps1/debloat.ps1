<#
.NOTES 
Github : https://github.com/pdotexe
Version: 1
#>

<#
.SYNOPSIS 

A PowerShell script to remove unwanted Dell bloatware from Windows systems.
includes common applications pre-installed in Dell computers which use up extensive memory and CPU resources
#>




<#
.DESCRIPTION
 identifies and uninstalls pre-installed Dell + Windows applications that are often considered bloatware.
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

Write-Host " For information , run ./debloat.ps1 -Help"


$choice = Read-Host "Please enter your choice (1-4)"

if ($choice -eq 4){ 
    exit
} ElseIf ($choice -eq 2){

    Remove-Packages -BasicRemoval -ErrorAction SilentlyContinue
} 
    ElseIf($choice -ne 1 -and $choice -ne 2 -and $choice -ne 3 -and $choice -ne 4){
    throw "Invalid Choice option." -ForegroundColor Red
}
ElseIf ( $choice -eq 3){
    Write-Host "Note: This will not remove 100% of Telemetry, as some is baked into the Kernel" -ForeGroundColor Red
    Write-Host "Working..." -ForeGroundColor Green
    Remove-Packages -RemoveTelemetry -ErrorAction SilentlyContinue
}
ElseIf ($choice -eq 1){
    Remove-Packages -RemoveDellware -ErrorAction SilentlyContinue
}









function Help{
    Clear-Host
    Write-Host @"

There are three options to choose from. 

If choose Dell Debloat, you may customize the packages or installations that will you wish to remove. Not everything is included for safety reasons. 

There is also a telemetry disabler, and a link to a seperate open-source script to combine power.

If choosing to debloat, be sure to view and add "#" in front of any path or package which you wish to keep.

Manual:
Simply choose options 1-4 according to your needs. There is no need to enter any flags, as that is taken care of for you.



"@
}

function Stop-Waves(){
try{
Stop-Service -Name WavesSysSvc -Force
Set-Service -Name WavesSysSvc -StartupType Disabled

}
catch{
try{
Stop-Service -Name WavesAudioEngineService -ErrorAction SilentlyContinue
Set-Service -Name WavesAudioEngineService -StartupType Disabled}
catch{Write-Output "no service found" -ForeGroundColor Black}
}
Set-Service PrintNotify -StartupType Disabled
Set-Service MapsBroker -StartupType Disabled

Set-Service XblAuthManager -StartupType Disabled
Set-Service XblGameSave -StartupType Disabled
Set-Service XboxNetApiSvc -StartupType Disabled
}





function Remove-Packages() { 
    [CmdletBinding()]
    param(
    [switch]$RemoveDellWare
    [switch]$RemoveTelemetry
    [switch]$BasicRemoval
) 
    if($RemoveDellWare){
    Stop-Waves
$msApps = @(
    "Clipchamp.Clipchamp_4.4.10420.0_x64__yxz26nhyzhsrt",
    "Microsoft.PowerAutomateDesktop_11.2511.161.0_x64__8wekyb3d8bbwe",
    "Microsoft.Windows.DevHome_0.2100.858.0_x64__8wekyb3d8bbwe",
    "Microsoft.GetHelp_10.2409.32612.0_x64__8wekyb3d8bbwe",
    "Microsoft.OutlookForWindows_1.2025.1104.200_x64__8wekyb3d8bbwe",
    "Microsoft.M365Companions_2.2510.22000.0_x64__8wekyb3d8bbwe",
    "Microsoft.ScreenSketch_11.2509.30.0_x64__8wekyb3d8bbwe",
    "aimgr_0.20.29.0_x64__8wekyb3d8bbwe",
    "Microsoft.RawImageExtension_2.5.7.0_x64__8wekyb3d8bbwe",
    "Microsoft.HEIFImageExtension_1.2.23.0_x64__8wekyb3d8bbwe",
    "Microsoft.WebpImageExtension_1.2.10.0_x64__8wekyb3d8bbwe",
    "Microsoft.WebMediaExtensions_1.2.14.0_x64__8wekyb3d8bbwe",
    "Microsoft.VP9VideoExtensions_1.2.6.0_x64__8wekyb3d8bbwe",
    "Microsoft.AV1VideoExtension_2.0.4.0_x64__8wekyb3d8bbwe",
    "Microsoft.MPEG2VideoExtension_1.2.13.0_x64__8wekyb3d8bbwe",
    "Microsoft.HEVCVideoExtension_2.4.25.0_x64__8wekyb3d8bbwe",
    "Microsoft.AVCEncoderVideoExtension_1.1.21.0_x64__8wekyb3d8bbwe",
    "DellInc.DellPowerManager_3.17.56.0_x64__htrsf667h5kn2",
    "Dell.SupportAssistforPCs_4.10.3.0_x64__18ctm2993j0dg",
    "DellInc.DellDigitalDelivery_*_x64__htrsf667h5kn2",
    "DellInc.DellCustomerConnect_*_x64__htrsf667h5kn2",
    "ScreenovateTechnologies.DellMobileConnect_*_x64__8wekyb3d8bbwe",
    "DellInc.AlienwareCommandCenter_*_x64__htrsf667h5kn2",
    "DellInc.AlienwareSoundCenter_*",
    "DellInc.CinemaColor_*",
    "DellInc.DellDisplayManager_*",
    "DellInc.DellPeripheralManager_*",
    "DellInc.DellCommandUpdate_*",
    "DellInc.DellOptimizer_*",
    "AppUp.IntelArcSoftware_25.40.1953.0_x64__8j3eq9eme6ctt",
    "AppUp.IntelManagementandSecurityStatus_2521.8.2.0_x64__8j3eq9eme6ctt",
    "AppUp.ThunderboltControlCenter_1.0.37.0_x64__8j3eq9eme6ctt",
    "29645FreeConnectedLimited.X-VPN-FreeUnlimitedVPNPr_30.2.1.0_x64__qjvpctbgym0d0",
    "5319275A.WhatsAppDesktop_2.2586.3.0_x64__cv1g1gvanyjgm",
    "microsoft.windowscommunicationsapps_16005.14326.22342.0_x64__8wekyb3d8bbwe",
    "Microsoft.People_10.2202.100.0_x64__8wekyb3d8bbwe"
)
foreach ( $app in $msApps){
    Write-Host "Removing $app..."
    if($app -like "*`**"){
        Get-AppxPackage -AllUsers | Where-Object { $_.Name -like $app}| ForEach-Object{
            Write-Host "Removing Package $($_.Name)"
            Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue

        }
          Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app } | ForEach-Object {
            Write-Host "Removing Provisioned Package $($_.DisplayName)"
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
    }
    ElseIf($app -notlike "*`**"){
    Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app}| Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
}
}


$dellRegistry = @(
    "MsiExec.exe /X{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9} /quiet /norestart",
    "MsiExec.exe /X{6EBF5DC4-FA0B-4692-A954-E7470146943D} /quiet /norestart",
    "MsiExec.exe /X{E630454C-DAC8-4BA5-9D65-65D09722CCF0} /quiet /norestart",
    '"C:\ProgramData\Package Cache\{d0ab664c-e704-4396-b9bc-ad1a7327731f}\DellUpdateSupportAssistPlugin.exe" /uninstall /quiet /norestart'
)
foreach ($cmd in $dellRegistry){
    Write-Host "Removing $cmd"
    Start-Process cmd.exe -ArgumentList "/c $cmd" -Wait -NoNewWindow
}
$memoryTargets= @(
    
    "C:\Program Files\Dell\TechHub\*",
    "C:\Program Files\Dell\SupportAssist*",
    "C:\Program Files\Dell\Update*",
    "C:\Program Files\Dell\DellDataVault*",
    "C:\Program Files\OpenVPN\bin\openvpn-gui.exe",
    "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\AppVShNotify.exe"
)
foreach($memProcess in $memoryTargets){
    if(Test-Path $memProcess){
        Remove-Item $memProcess -Recurse -Force -ErrorAction SilentlyContinue
    }
}


$serviceTargets = @(
    "dcpm-notify",                        
    "Dell.CommandPowerManager.Service",    
    "DellClientManagementService",         
    "DellTechHub",                        
    "SupportAssistAgent"                   
)
foreach($service in $serviceTargets){
    Write-Host "Removing $service"
    Stop-Service $service -ErrorAction SilentlyContinue -Force
    Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
}


    }
ElseIf($RemoveTelemetry){
    try{
    Telemetry-Data }
    catch{}
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
}

function Roll-Back(){
    [CmdLetBinding()]
    param()





}











