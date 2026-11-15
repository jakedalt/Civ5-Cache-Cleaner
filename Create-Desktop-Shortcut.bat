@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "Create-Desktop-Shortcut.ps1"
pause
