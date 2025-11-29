@echo off
SET PowerShellScriptPath=%~dp0ps1\debloat.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%PowerShellScriptPath%"
pause
exit