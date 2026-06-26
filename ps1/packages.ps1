    <#
    .DESCRIPTION
    removal functions.
    #>
    



    
function Microsoft-Apps{
    [CmdletBinding()]
    param()
    $msApps = @(
    "*Clipchamp*",
    "*PowerAutomateDesktop*",
    "*DevHome*",
    "*GetHelp*",
    "*OutlookForWindows*",
    "*M365Companions*",
    "*DellPowerManager*",
    "*SupportAssist*",
    "*DellDigitalDelivery*",
    "*DellCustomerConnect*",
    "*DellMobileConnect*",
    "*Alienware*",
    "*CinemaColor*",
    "*DellDisplayManager*",
    "*DellPeripheralManager*",
    "*DellCommandUpdate*",
    "*DellOptimizer*",
    "*IntelArcSoftware*",
    "*IntelManagementandSecurityStatus*",
    "*ThunderboltControlCenter*",
    "*windowscommunicationsapps*",
    "*People*"
 )
        
  Write-Host "Scanning for installed applications..." -ForegroundColor Yellow
            

    foreach ($app in $msApps){
        
        Write-Host "Removing $($app)..."
       $installed =  Get-AppxPackage -AllUsers |  Where-Object { $_.Name -like $app }

    if ($installed){
    foreach($package in $installed){
        Remove-AppxPackage -AllUsers -Package $package.PackageFullName -ErrorAction SilentlyContinue
        Write-Host "Removed package $($package.Name)" -ForegroundColor Green
    }
    }
    $provisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app }


    if($provisionedPackages){
    foreach($provPack in $provisionedPackages){
    Remove-AppxProvisionedPackage -Online -PackageName $provPack.PackageName -ErrorAction SilentlyContinue
        
    Write-Host "Removed provisioned package $($provPack.DisplayName)" -ForegroundColor Green
    }
    }
    }


    }
        

function Remediation-Path{
    [CmdLetBinding()]
    param()
    $remPath = "C:\ProgramData\Dell\SARemediation"
    $exists = $false
    if (Test-Path $remPath){
        $exists = $true
        Remove-Item -Path $remPath -Recurse -ErrorAction SilentlyContinue
    }
    if ($exists -eq $true){
        Write-Host "Found and removed Remediation backup folder" -ForegroundColor Green
    }
}   

function Service-Targets{
    [CmdLetBinding()]
    param()
     $serviceTargets = @(
        "dcpm-notify",
        "DellPowerManagerService",
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
    [CmdletBinding()]
    param()
     $dellTargets= @(
            "C:\Program Files\Dell\TechHub\*",
            "C:\Program Files\Dell\SupportAssist*",
            "C:\Program Files\Dell\Update*",
            "C:\Program Files\Dell\DellDataVault*",
            "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\AppVShNotify.exe"
        )
        foreach($i in $dellTargets){
            Remove-Item $i -Recurse -Force -ErrorAction SilentlyContinue
            
        }

        # supportassist is especially persistent
        Invoke-CimMethod -Query "SELECT * FROM Win32_Product WHERE Name LIKE 'Dell SupportAssist%'" -MethodName Uninstall
        $appCache = "C:\ProgramData\Package Cache\{d0ab664c-e704-4396-b9bc-ad1a7327731f}\DellUpdateSupportAssistPlugin.exe"
        Remove-Item -Path $appCache -Recurse -Force -ErrorAction SilentlyContinue



        $regPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )

    $keys = Get-ItemProperty $regPaths | Where-Object { $_.DisplayName -like "*SupportAssist*" } 

    if ($keys){
        foreach ($key in $keys){
        Remove-Item -Path $key.PSPath -Force -Recurse -ErrorAction SilentlyContinue
        Write-Host "Removed Ghost Registry Entry at $($key.PSPath)" -ForegroundColor Green
        }
    }


        
}



function Stop-Waves{
    [CmdLetBinding()]
    param()


    $sv = "WavesSysSvc", "WavesAudioEngineService", "XblAuthManager", "XblGameSave", "XblAuthManager", "XblGameSave", "XboxNetApiSvc"
    foreach ($i in $sv){
        Stop-Service -Name $i -Force -ErrorAction SilentlyContinue
        Set-Service -Name $i -StartupType Disabled -ErrorAction SilentlyContinue
    }
    
    
    Write-Host "Stopped/Removed WavesSysSvc`nWavesAudioEngineService`nPrintNotify`nMapsBroker`nXblAuthManager`nXblGameSave`nXboxNetApiSvc" -ForeGroundColor Green

}








function Registry-Paths{
    [CmdletBinding()]
    param()
    $registryPaths = @(
        "{0307D6D7-56E0-408C-B8D9-D3C6AFEBDDB9}",
        "{6EBF5DC4-FA0B-4692-A954-E7470146943D}",
        "{E630454C-DAC8-4BA5-9D65-65D09722CCF0}"
    )
    
    foreach ($path in $registryPaths) {
       
            Write-Host "Removing MSI package: $path" -ForeGroundColor Green
            Start-Process msiexec.exe -ArgumentList "/X $path /qn /norestart" -Wait -NoNewWindow
        
        }
}



