<#
.DESCRIPTION 
Telemetry Removal commands
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


Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Disabled DiagTrack, dmwappushservice" -ForegroundColor Green
Write-Host "Removed C:\ProgramData\Microsoft\Windows\WER" -ForegroundColor Green

    
Get-ScheduledTask | Where-Object {$_.TaskName -match "CEIP|Customer|Telemetry|Diag|Feedback"} |
ForEach-Object{
    try{
        $_ | Disable-ScheduledTask -ErrorAction SilentlyContinue
        Write-Host "Disabled $($_.TaskName) Successfuly" -ForegroundColor Green
    }
    catch{
        Write-Error "Error disabling $($_.TaskName): $($_.Exception.Message)" -ForegroundColor Red
    }
}


#diagnosis data 
Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Removed C:\ProgramData\Microsoft\Diagnosis" -ForegroundColor Green



# registry hive policy 
$hive = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path -Path $hive)){
    New-Item -Path $hive -Force | Out-Null
}
Set-ItemProperty -Path $hive -Name "AllowTelemetry" -Value 0 -PropertyType DWORD

Write-Host "Blocked Telemetry flag in windows registry" -ForegroundColor Green



}
 

 