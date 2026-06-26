@echo off
SET PowerShellScriptPath=%~dp0ps1\debloat.ps1
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges
) else (
    echo Not running as Administrator. Please click 'Run as Adminstrator' on run.bat.
    pause
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {. '%PowerShellScriptPath%'; $host.UI.RawUI.WindowTitle = 'Dell Debloater'}"
pause