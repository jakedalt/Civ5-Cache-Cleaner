Add-Type -AssemblyName System.Windows.Forms

$settingsFile = Join-Path $PSScriptRoot "settings.txt"
$currentPath = ""

if (Test-Path $settingsFile) {
    Get-Content $settingsFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -match "^CustomCachePath\s*=\s*(.+)$") {
            $currentPath = $matches[1].Trim(' "''')
        }
    }
}

$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select your Civilization V 'cache' folder:"
$browser.ShowNewFolderButton = $false
if ($currentPath -and (Test-Path $currentPath)) {
    $browser.SelectedPath = $currentPath
}

$result = $browser.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $selected = $browser.SelectedPath
    $content = @"
# ==============================================================
# Civilization V Cache Cleaner - Configuration
# ==============================================================
# Leave CustomCachePath blank to use automatic detection.
# If your Civ V cache is in a custom location, paste the full path below.
CustomCachePath = $selected
"@
    Set-Content -Path $settingsFile -Value $content -Encoding UTF8
    [System.Windows.Forms.MessageBox]::Show("Custom cache path saved successfully:`n`n$selected", "Civ V Cache Cleaner", 0, 64)
}
