    <#
    .DESCRIPTION
    removal functions.
    #>
    



    
function Microsoft-Apps{
    [CmdletBinding()]
    param()
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
                    $found = $true
                    $packages | ForEach-Object{
                        Write-Host "Removing Package $($_.Name)" -ForeGroundColor Yellow
                        Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue
                        Write-Host "Removed package $($_.Name)" -ForeGroundColor Green
                    }
                }
                $provisionedPackages = $allProvisionedPackages | Where-Object { $_.DisplayName -like $app }
                if ($provisionedPackages) {
                    if (-not $found) { Write-Host "Removing $app..." -ForeGroundColor Yellow}
                    $found = $true
                    $provisionedPackages | ForEach-Object {
                        Write-Host "Removing Provisioned Package $($_.DisplayName)" -ForeGroundColor Yellow
                        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
                        Write-Host "Removed Provisioned Package $($_.DisplayName)"
                    }
                }
            }
            else{
                $packages = $allPackages | Where-Object { $_.Name -eq $app }
                if ($packages) {
                    Write-Host "Removing $app..." -ForeGroundColor Yellow
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
}


function Service-Targets{
    [CmdLetBinding()]
    param()
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

function Remove-Targets{
    [CmdLetBinding()]
    param()
     $memoryTargets= @(
            "C:\Program Files\Dell\TechHub\*",
            "C:\Program Files\Dell\SupportAssist*",
            "C:\Program Files\Dell\Update*",
            "C:\Program Files\Dell\DellDataVault*",
            "C:\Program Files\OpenVPN\bin\openvpn-gui.exe",
            "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\AppVShNotify.exe"
        )
        foreach($Process in $memoryTargets){
            if(Test-Path $Process){
                Remove-Item $Process -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        
}



function Stop-Waves(){
    [CmdLetBinding()]
    param()
    $done = $false
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
            Write-Host "no waves service found" -ForeGroundColor Red
        }
    }
    Set-Service PrintNotify -StartupType Disabled
    Set-Service MapsBroker -StartupType Disabled
    $Xbl = Get-Service XblAuthManager -ErrorAction SilentlyContinue
    if($Xbl){
    Set-Service $Xbl -StartupType Disabled
    }
    else{
        continue
    }
    Set-Service XblGameSave -StartupType Disabled
    Set-Service XboxNetApiSvc -StartupType Disabled
    $done = $true
    if($done -eq $true){
    Write-Host "Stopped/Removed WavesSysSvc`nWavesAudioEngineService`nPrintNotify`nMapsBroker`nXblAuthManager`nXblGameSave`nXboxNetApiSvc" -ForeGroundColor Green
}
}






function Support-Assist {
    $pluginPath = "C:\ProgramData\Package Cache\{d0ab664c-e704-4396-b9bc-ad1a7327731f}\DellUpdateSupportAssistPlugin.exe"
        if (Test-Path $pluginPath) {
            Write-Host "Removing DellUpdateSupportAssistPlugin"
            Start-Process -FilePath $pluginPath -ArgumentList "/uninstall", "/quiet", "/norestart" -Wait -NoNewWindow

        }
}

function Registry-Paths{
    [CmdletBinding()]
    param()
    $registryPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9}",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{6EBF5DC4-FA0B-4692-A954-E7470146943D}",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{E630454C-DAC8-4BA5-9D65-65D09722CCF0}", 
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9}",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall{6EBF5DC4-FA0B-4692-A954-E7470146943D}",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall{E630454C-DAC8-4BA5-9D65-65D09722CCF0}"
    )
    
    foreach ($path in $registryPaths) {
        if (Test-Path $path) {
            $guid = $path.Split('\')[-1]
            Write-Host "Removing MSI package: $guid" -ForeGroundColor Green
            Start-Process msiexec.exe -ArgumentList "/X$guid /qn /norestart" -Wait -NoNewWindow
        }
        }
}



