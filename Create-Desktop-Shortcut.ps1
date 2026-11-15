$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "Civilization V (Clear Cache).lnk")
$targetPath = [System.IO.Path]::Combine($PSScriptRoot, "Launch-Civ5-ClearCache.bat")

$iconPath = "C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization V\CivilizationV_DX11.exe"
if (-not (Test-Path $iconPath)) {
    $iconPath = "C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization V\CivilizationV.exe"
}

$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $PSScriptRoot
$shortcut.Description = "Clears Civ V cache and launches Civilization V"
if (Test-Path $iconPath) {
    $shortcut.IconLocation = "$iconPath, 0"
}
$shortcut.Save()

Write-Host "Desktop shortcut created successfully at: $shortcutPath" -ForegroundColor Green
