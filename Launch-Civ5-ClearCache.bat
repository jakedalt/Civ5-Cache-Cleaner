@echo off
setlocal
cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "ClearCacheAndLaunch.ps1" %*

endlocal
