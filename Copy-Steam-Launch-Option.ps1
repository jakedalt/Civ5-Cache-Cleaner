Add-Type -AssemblyName System.Windows.Forms

$batPath = Join-Path $PSScriptRoot "Launch-Civ5-ClearCache.bat"
$launchCommand = "`"$batPath`" %command%"

try {
    Set-Clipboard -Value $launchCommand
} catch {
    # Fallback to clip.exe
    $launchCommand | clip.exe
}

[System.Windows.Forms.MessageBox]::Show(
    "Copied to your clipboard!`n`n$launchCommand`n`nHow to use in Steam:`n1. In Steam, right-click 'Sid Meier's Civilization V' -> Properties`n2. In the General tab, paste (Ctrl+V) into 'Launch Options'`n3. Close Properties window and click PLAY!",
    "Steam Launch Option Ready",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
