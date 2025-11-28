    
    <#
    .SYNOPSIS
    
    This file is solely for getting package names of embedded software within the operating system. Feel free to alter it.
    #>
    



    $registryPaths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    $uninstallList = @(
        # Core Telemetry & Support Tools
        "Dell SupportAssist",
        "Dell SupportAssistAgent",
        "Dell SupportAssist OS Recovery Plugin for Dell Update",
        "Dell SupportAssist Remediation",
        "Dell SupportAssist OS Recovery Plugin for Dell Update",
        "Dell SupportAssist Recovery",
        "Dell SupportAssist Recovery Plugin",
        "Dell SupportAssist for PCs",
        "Dell SupportAssistAgent",
        "Dell Customer Connect",

        # Data Vault Services (Telemetry)
        "Dell Data Vault",
        "Dell Data Vault Wizard",
        "Dell Data Vault Collector",

        # Update Tools 
        "Dell Update",
        "Dell Update - SupportAssist Update Plugin",
        "Dell Update for Windows 10",
        "Dell Update - Windows Universal",
        "Dell Command | Update for Windows 10",
        "Dell Command Update for Windows 10",

        # Dell Analytics / Optimization
        "Dell Optimizer",
        "Dell Optimizer Service",
        "Dell Optimizer Core",
        "Dell Optimizer Service UI",
        "Dell Optimizer Service Installer",

        # Digital Delivery (OEM App Store)
        "Dell Digital Delivery",
        "Dell Digital Delivery Services",

        # Foundation / Assist Infrastructure
        "Dell Foundation Services",
        "Dell Inc. SupportAssist",
        "Dell TechHub",
        "Dell Tech Hub",
        "Dell Trusted Device Agent",
        "Dell Trusted Device",
        "Dell Update - SupportAssist Remediation",
        "Dell Trusted Device Setup",
        "Dell SafeBIOS",
        "Dell SafeBIOS Utility",

        # Audio bloat
        "Waves MaxxAudio",
        "Waves Audio Services",
        "WavesSvc64",
        "Waves MaxxAudio Pro Application for Dell Audio",
        "Waves MaxxAudio Pro for Dell",

        # Misc OEM fluff
        "Dell Digital Delivery Services",
        "Dell Digital Delivery Application",
        "Dell My Dell",
        "My Dell",
        "Dell Mobile Connect Drivers",
        "Dell Mobile Connect",
        "Dell Optimizer Service",
        "Dell Optimizer UI"
    )




    Write-Host "DELLWARE IN WINDOWS REGISTRY" -ForeGroundColor Cyan
    foreach ($path in $registryPaths) {
        Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
        Where-Object{$_.DisplayName -and ($uninstallList -contains $_.DisplayName -or ($_.Publisher -like '*Dell*') -or ($_.DisplayName -like '*Dell*'))}|
        Select-Object DisplayName, Publisher, DisplayVersion, UninstallString |
        
        ForEach-Object {    
            
            Write-Host "[$($_.DisplayName)] [$($_.DisplayVersion)] [$($_.UninstallString)]" 
        }
    }

    #Microsoft app store AppxPackages
    Write-Host " Microsoft store dell apps:"
    Get-AppXPackage -Name  "*Dell*" | Select-Object -Property PackageFullName, UninstallString |
    ForEach-Object{
        Write-Host "[$($_.Name)] [$($_.PackageFullName)]" 
    }


    #Other
    Write-Host "OTHER PROCESSES FOUND IN TASK MANAGER" -ForeGroundColor Cyan
    $processes = Get-Process
    foreach ($item in $processes) {
        $path = $null
        $start = $null
        Try{
            $path = $item.Path
            
        }
        Catch{
            Write-Warning "Error: $($_.Exception.Message)"
        }
        Write-Host "$($item.ProcessName) [$($item.Id)] [$path] " 
    }
    Write-Host "WAVES WINDOWS SERVICES" -ForeGroundColor Cyan
    Get-Service|
    Where-Object {
        $_.DisplayName -match "Dell|Waves" -or $_.Name -match "Dell|Waves"

    } |
    ForEach-Object{
        Write-Host "[$($_.Name )] [$($_.DisplayName)] [$($_.Status)]"
    }










