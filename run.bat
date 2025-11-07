@ echo off

SET PowerShellScriptPath= %~dp0debloat.ps1
start /b "" Powershell.exe -ExecutionPolicy Bypass -File "%PowerShellScriptPath%"
exit
