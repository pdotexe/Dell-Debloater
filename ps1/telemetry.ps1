<#
.SYNOPSIS 

Removal of telemetry through various locations in the OS including diagtrack, scheduled tasks, disabled registry paths, and more
#>




function Telemetry-Data(){
[CmdLetBinding()]
param()





#diagtrack
Stop-Service DiagTrack -Force
Set-Service DiagTrack -StartupType Disabled



# dmwappushservice
Stop-Service dmwappushservice -Force
Set-Service dmwappushservice -StartupType Disabled
#ConnectedUserExperiences
Stop-Service ConnectedUserExperiences -Force
Set-Service ConnectedUserExperiences -StartupType Disabled

Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER" -Recurse -Force -ErrorAction SilentlyContinue

# Change telemetry schedule (compatibility)
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable


Get-ScheduledTask | Where-Object {$_.TaskName -match "CEIP|Customer|Telemetry|Diag|Feedback"} |
ForEach-Object{
    try{
        Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue
    }
    catch{}
}






    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
}
    
 