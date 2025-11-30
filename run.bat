@echo off
SET PowerShellScriptPath=%~dp0ps1\debloat.ps1
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges
) else (
    echo Not running as Administrator. Please run this file as admin.
    pause
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {. '%PowerShellScriptPath%'; $host.UI.RawUI.WindowTitle = 'Dell Debloater'}"
pause