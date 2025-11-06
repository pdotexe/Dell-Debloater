<#
.NOTES 
Github : https://github.com/pdotexe
Version: 1
#>


.SYNOPSIS 

<# A PowerShell script to remove unwanted Dell bloatware from Windows systems.
includes common applications pre-installed in Dell computers which use up extensive memory  and CPU resources
#>





.DESCRIPTION
<# identifies and uninstalls pre-installed Dell + Windows applications that are often considered bloatware.
 targets specific Dell applications and removes them to improve system performance and user experience.
 #>



Import-Module telemetry
Import-Module getpackages





Write-Host "[1] Command Line"
Write-Host "-----------------------------------"
Write-Host"[2] Use GUI"
Write-Host "-----------------------------------"
Write-Host "[3] Exit"

Write-Host "For manual: '/delldebloat.ps1 -Manual'" -ForegroundColor Green
Write-Host "To see which applications will uninstall, run: 'cat apps.txt'" -ForegroundColor Blue
Write-Host "To manually choose removal, use UI " -ForegroundColor Orange


$choice = Read-Host "Please enter your choice (1-3)"

if ($choice -eq 3){
    exit
} ElseIF ($choice -eq 2){
    Open-Application
} ElseIf($choice -ne 1 -or $choice -ne 2 -or $choice -ne 3 -or $choice -ne 4){
    throw "Invalid Choice option."
}









function Manual{
    Clear-Host
    Write-Host @"
    

"@
}






function RemovePackages param(
    [switch]$RemoveDellWare
    [switch]$RemoveTelemetry
    [switch]$BasicRemoval
) {

}











# get dell packages
# get other packages
# get telemetry details
# call seperate script for the "basic removal"
