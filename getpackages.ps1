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

foreach ($path in $registryPaths) {
    Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
    Where-Object{$uninstallList -contains $_.DisplayName -or ($_.Publisher -match 'Dell') -or ($_.DisplayName -match 'Dell')}|
    Select-Object DisplayName, Publisher, DisplayVersion, UninstallString | Format-List
    ForEach-Object {
        
        Write-Host "$($_.DisplayName) [$($_.DisplayVersion)] [$($_.UninstallString)]"
    }
}

#Microsoft app store AppxPackages
Write-Host " Microsoft store dell apps:"
Get-AppxPackages -Name "Dell" | Select-Object -Property PackageFullName, UninstallString
