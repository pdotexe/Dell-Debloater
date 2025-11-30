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



. "$PSScriptRoot\telemetry.ps1"



function ScheduledTasks() {
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
}

function Stop-Waves(){
    try{
        Stop-Service -Name WavesSysSvc -Force
        Set-Service -Name WavesSysSvc -StartupType Disabled
    }
    catch{
        try{
            Stop-Service -Name WavesAudioEngineService -ErrorAction SilentlyContinue
            Set-Service -Name WavesAudioEngineService -StartupType Disabled
        }
        catch{
            Write-Host "no waves service found" -ForeGroundColor DarkGray
        }
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
        [switch]$RemoveDellware,
        [switch]$RemoveTelemetry,
        [switch]$BasicRemoval
    )
    
    if($RemoveDellware){
        Stop-Waves
            $msApps = @(
            "Clipchamp.Clipchamp_*_x64__yxz26nhyzhsrt",
            "Microsoft.PowerAutomateDesktop_*_x64__8wekyb3d8bbwe",
            "Microsoft.Windows.DevHome_*_x64__8wekyb3d8bbwe",
            "Microsoft.GetHelp_*_x64__8wekyb3d8bbwe",
            "Microsoft.OutlookForWindows_*_x64__8wekyb3d8bbwe",
            "Microsoft.M365Companions_*_x64__8wekyb3d8bbwe",
            "Microsoft.ScreenSketch_*_x64__8wekyb3d8bbwe",
            "aimgr_*_x64__8wekyb3d8bbwe",
            "Microsoft.RawImageExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.HEIFImageExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.WebpImageExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.WebMediaExtensions_*_x64__8wekyb3d8bbwe",
            "Microsoft.VP9VideoExtensions_*_x64__8wekyb3d8bbwe",
            "Microsoft.AV1VideoExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.MPEG2VideoExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.HEVCVideoExtension_*_x64__8wekyb3d8bbwe",
            "Microsoft.AVCEncoderVideoExtension_*_x64__8wekyb3d8bbwe",
            "DellInc.DellPowerManager_*_x64__htrsf667h5kn2",
            "Dell.SupportAssistforPCs_*_x64__18ctm2993j0dg",
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
            "AppUp.IntelArcSoftware_*_x64__8j3eq9eme6ctt",
            "AppUp.IntelManagementandSecurityStatus_*_x64__8j3eq9eme6ctt",
            "AppUp.ThunderboltControlCenter_*_x64__8j3eq9eme6ctt",
            "29645FreeConnectedLimited.X-VPN-FreeUnlimitedVPNPr_*_x64__qjvpctbgym0d0",
            "5319275A.WhatsAppDesktop_*_x64__cv1g1gvanyjgm",
            "microsoft.windowscommunicationsapps_*_x64__8wekyb3d8bbwe",
            "Microsoft.People_*_x64__8wekyb3d8bbwe"
        )
        
        # Get all packages once for performance
        $allPackages = @(Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue)
        $allProvisionedPackages = @(Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue)
        
        foreach ( $app in $msApps){
            $found = $false
            if ($app -like "*_*_*" -or $app -like "*_*" -or $app -like "*" -or $app -like "_*"){
                $packages = $allPackages | Where-Object { $_.Name -like $app}
                if ($packages) {
                    Write-Host "Removing $app..."
                    $found = $true
                    $packages | ForEach-Object{
                        Write-Host "Removing Package $($_.Name)"
                        Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue
                    }
                }
                $provisionedPackages = $allProvisionedPackages | Where-Object { $_.DisplayName -like $app }
                if ($provisionedPackages) {
                    if (-not $found) { Write-Host "Removing $app..." }
                    $found = $true
                    $provisionedPackages | ForEach-Object {
                        Write-Host "Removing Provisioned Package $($_.DisplayName)"
                        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
                    }
                }
            }
            else{
                $packages = $allPackages | Where-Object { $_.Name -eq $app }
                if ($packages) {
                    Write-Host "Removing $app..."
                    $found = $true
                    $packages | ForEach-Object {
                        Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue
                    }
                }
                $provisionedPackages = $allProvisionedPackages | Where-Object {$_.DisplayName -eq $app}
                if ($provisionedPackages) {
                    if (-not $found) { Write-Host "Removing $app..." }
                    $found = $true
                    $provisionedPackages | ForEach-Object {
                        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
                    }
                }
            }
        }
        
        $dellRegistry = @(
            "MsiExec.exe /X{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9} /quiet /norestart",
            "MsiExec.exe /X{6EBF5DC4-FA0B-4692-A954-E7470146943D} /quiet /norestart",
            "MsiExec.exe /X{E630454C-DAC8-4BA5-9D65-65D09722CCF0} /quiet /norestart",
            '"C:\ProgramData\Package Cache\{d0ab664c-e704-4396-b9bc-ad1a7327731f}\DellUpdateSupportAssistPlugin.exe" /uninstall /quiet /norestart'
        )
        
        
        $registryPaths = @(
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9}",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{6EBF5DC4-FA0B-4692-A954-E7470146943D}",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{E630454C-DAC8-4BA5-9D65-65D09722CCF0}"
        )
        
        foreach ($path in $registryPaths) {
            if (Test-Path $path) {
                $guid = $path -replace '.*\\', ''
                Write-Host "Removing MSI package: $guid"
                Start-Process msiexec.exe -ArgumentList "/X$guid /quiet /norestart" -NoNewWindow
            }
        }
        
        # Check for DellUpdateSupportAssistPlugin
        $pluginPath = "C:\ProgramData\Package Cache\{d0ab664c-e704-4396-b9bc-ad1a7327731f}\DellUpdateSupportAssistPlugin.exe"
        if (Test-Path $pluginPath) {
            Write-Host "Removing DellUpdateSupportAssistPlugin"
            Start-Process cmd.exe -ArgumentList "/c `"$pluginPath`" /uninstall /quiet /norestart" -Wait -NoNewWindow
        }
        $additionalDellItems = @(
            

        )
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
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
            if ($svc) {
                Write-Host "Removing $service"
                Stop-Service $service -ErrorAction SilentlyContinue -Force
                Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }
    }
    ElseIf($RemoveTelemetry){
        try{
            Telemetry-Data
        }
        catch{}
        Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force -ErrorAction SilentlyContinue
        ScheduledTasks
    }
    ElseIf($BasicRemoval){
        Write-Information "This function makes a web request. Make sure you are connected to the internet. Credit to this repository goes to https://github.com/Raphire/Win11Debloat"
        $tempFolder = Join-Path $env:TEMP "Win11Debloat" 
        if (Test-Path $tempFolder) {
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
        $psScript = Join-Path $repoFolder "Win11Debloat.ps1"
        Try{
            if (Test-Path $psScript) {
                Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$psScript`"" -Verb RunAs -Wait
            }
            else {
                Write-Host "Win11Debloat.ps1 not found at $psScript" -ForegroundColor Red
            }
        }
        Finally {
            Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}






Write-Host "[1] Use Dell Debloat (Quick Cleanup)" -ForeGroundColor Blue
Write-Host "-----------------------------------"
Write-Host "[2] Use Win11-Debloat" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[3] Remove Telemetry" -ForeGroundColor Blue
Write-Host "-----------------------------------" -ForeGroundColor Black
Write-Host "[4] Exit" -ForeGroundColor Yellow


Write-Host "CHANGES CAN NOT BE REVERSED. REVIEW WHAT WILL BE REMOVED WITH: Get-Item removeditems.txt" -ForegroundColor Cyan


while($true){
    $choice = Read-Host "Enter your choice (1-4)"
    
    if ($choice -eq "1") {
        Remove-Packages -RemoveDellware -ErrorAction SilentlyContinue
    }
    elseif ($choice -eq "2") {
        Remove-Packages -BasicRemoval -ErrorAction SilentlyContinue
    }
    elseif ($choice -eq "3") {
        Remove-Packages -RemoveTelemetry -ErrorAction SilentlyContinue
    }
    elseif ($choice -eq "4") {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    else{
        Invoke-Expression $choice
    }
}


















