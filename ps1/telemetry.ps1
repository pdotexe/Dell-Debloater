<#
.DESCRIPTION 
Telemetry Removal commands
#>




function Telemetry-Data(){
[CmdLetBinding()]
param()
#diagnosis data 
Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Removed C:\ProgramData\Microsoft\Diagnosis" -ForeGroundColor Green
# block outbound network traffic to endpoints
$endpoints = @(
"v10.events.data.microsoft.com",
  "v10.vortex-win.data.microsoft.com",
  "v10c.events.data.microsoft.com",
  "self.events.data.microsoft.com",
  "watson.telemetry.microsoft.com",
  "telecommand.telemetry.microsoft.com",
  "oca.telemetry.microsoft.com",
  "settings-win.data.microsoft.com"
)
foreach ($domain in $endpoints){
    $ip = (Resolve-DnsName -Name $domain -ErrorAction SilentlyContinue | Where-Object { $_.QueryType -eq "A"}).ipAddress
    if($ip){
    New-NetFirewallRule -DisplayName "Block Telemetry: $domain" `
    -Direction Outbound -Action Block -RemoteAddress $ip -Protocol TCP 
    }
    ElseIf(!$ip){
        Write-Error "No IP address to resolve" -ForeGroundColor Red
    }
    Write-Host "Blocked TCP connection to endpoints" -ForeGroundColor Green
}

$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsContent = Get-Content $hostsPath
$written = $false
foreach ($d in $endpoints){
    $entry = "0.0.0.0`t$d"
    if (-not (Select-String -Path $hostsPath -Pattern $d -Quiet)){
        
        $hostsContent =  $hostsContent | Where-Object { $_ -notmatch [regex]::Escape($d)}

        # new line entry
        $hostsContent += $entry

        $written = $true

        #overwrite
        Set-Content -Path $hostsPath -Value $hostsContent -Force
        if ($written -eq $true){
            Write-Host "blocked requests to endpoint" -ForeGroundColor Green
        }
    }
}

#diagtrack
Stop-Service DiagTrack -Force
Set-Service DiagTrack -StartupType Disabled



# dmwappushservice
Stop-Service dmwappushservice -Force
Set-Service dmwappushservice -StartupType Disabled


Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Disabled DiagTrack, dmwappushservice" -ForeGroundColor Green
Write-Host "Removed C:\ProgramData\Microsoft\Windows\WER" -ForeGroundColor Green


Get-ScheduledTask | Where-Object {$_.TaskName -match "CEIP|Customer|Telemetry|Diag|Feedback"} |
ForEach-Object{
    try{
        Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue
        Write-Host "Disabled $($_.TaskName) Successfuly" -ForeGroundColor Green
    }
    catch{
        Write-Error "Error: $($_.Exception.Message)"
    }
}

$logServices = @(
"C:\ProgramData\Microsoft\Diagnosis\*",
"C:\Windows\AppCompat\Programs\*",
"C:\Windows\System32\LogFiles\Sum\*",
"C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*",
"C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*"
)

foreach ($dir in $logServices){
    if(Test-Path $dir){
    Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Removed $dir Successfully" -ForeGroundColor Green
    }
}



}
 

 