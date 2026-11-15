<#
.SYNOPSIS
    Civilization V Cache Cleaner & Launcher
.DESCRIPTION
    Safely clears the Civ V cache directory before game startup and launches the game.
    Supports standalone execution, -NoLaunch flag (clear only), or Steam Launch Options (%command%).
#>

param(
    [switch]$NoLaunch,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$SteamArgs
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Sid Meier's Civilization V Cache Cleaner" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

$settingsFile = Join-Path $PSScriptRoot "settings.txt"
$customCachePath = $null

# 1. Read custom path from settings.txt if defined
if (Test-Path $settingsFile) {
    Get-Content $settingsFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -match "^CustomCachePath\s*=\s*(.+)$") {
            $val = $matches[1].Trim(' "''')
            if ($val -ne "") {
                $customCachePath = $val
            }
        }
    }
}

$cachePath = $null
$pathFound = $false

if ($customCachePath) {
    Write-Host "`nUsing custom cache path from settings.txt:" -ForegroundColor Gray
    Write-Host "  $customCachePath" -ForegroundColor White
    if (Test-Path $customCachePath) {
        $cachePath = $customCachePath
        $pathFound = $true
    } else {
        Write-Host "  [!] Custom path does not exist on disk." -ForegroundColor Red
        $summaryMsg = "Did not clear cache: The custom path in settings.txt does not exist:`n$customCachePath`n`nLaunching Civilization V..."
    }
} else {
    # 2. Auto-detect cache directory (Works for 99% of players)
    $docCandidates = @(
        [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments), "My Games", "Sid Meier's Civilization 5", "cache"),
        [System.IO.Path]::Combine($env:USERPROFILE, "Documents", "My Games", "Sid Meier's Civilization 5", "cache")
    )
    if ($env:OneDrive) {
        $docCandidates += [System.IO.Path]::Combine($env:OneDrive, "Documents", "My Games", "Sid Meier's Civilization 5", "cache")
    }

    $existingCandidate = $docCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($existingCandidate) {
        $cachePath = $existingCandidate
        $pathFound = $true
    } else {
        # 3. Not found: Offer interactive folder selection
        Add-Type -AssemblyName System.Windows.Forms
        $promptResult = [System.Windows.Forms.MessageBox]::Show(
            "Civilization V cache folder was not detected at standard locations.`n`nWould you like to browse and select your 'cache' folder now?",
            "Civ V Cache Cleaner",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($promptResult -eq [System.Windows.Forms.DialogResult]::Yes) {
            $browser = New-Object System.Windows.Forms.FolderBrowserDialog
            $browser.Description = "Select your Civilization V 'cache' folder:"
            $browser.ShowNewFolderButton = $false
            if ($browser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $cachePath = $browser.SelectedPath
                $pathFound = $true
                # Save to settings.txt for future launches
                $newSettings = @"
# ==============================================================
# Civilization V Cache Cleaner - Configuration
# ==============================================================
# Leave CustomCachePath blank to use automatic detection.
# If your Civ V cache is in a custom location, paste the full path below.
CustomCachePath = $cachePath
"@
                Set-Content -Path $settingsFile -Value $newSettings -Encoding UTF8
                Write-Host "`nSaved custom cache location to settings.txt for future launches." -ForegroundColor Green
            }
        }

        if (-not $pathFound) {
            Write-Host "`n[INFO] Cache folder was not found at standard locations." -ForegroundColor Yellow
            $summaryMsg = "Did not clear cache: Civilization V cache folder was not found at the expected location."
            if (-not $NoLaunch) {
                $summaryMsg += "`n`nLaunching Civilization V..."
            }
        }
    }
}

# 4. Check if Civ V is currently running
$runningProcesses = Get-Process -Name "CivilizationV", "CivilizationV_DX11", "CivilizationV_Tablet" -ErrorAction SilentlyContinue
if ($runningProcesses) {
    Write-Host "`n[WARNING] Civilization V is currently running!" -ForegroundColor Red
    Write-Host "The game holds active file locks on database cache files." -ForegroundColor Yellow
    Write-Host "Please close Civilization V first, then run this cleaner again.`n" -ForegroundColor Yellow
    
    $wshell = New-Object -ComObject WScript.Shell
    $wshell.Popup("Civilization V is currently running!`nPlease close the game first so the cache database can be unlocked and cleared.", 5, "Civ V Cache Cleaner", 48)
    exit 1
}

# 5. Clear cache contents if path was found
$deletedCount = 0
if ($pathFound) {
    Write-Host "`nScanning cache directory: $cachePath" -ForegroundColor Gray
    $items = Get-ChildItem -Path $cachePath -Force -ErrorAction SilentlyContinue
    
    if ($items -and $items.Count -gt 0) {
        foreach ($item in $items) {
            try {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop
                $deletedCount++
                Write-Host "  [-] Removed: $($item.Name)" -ForegroundColor DarkGray
            } catch {
                Write-Host "  [!] Could not delete $($item.Name): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        $summaryMsg = "Civilization V cache cleared successfully!`nRemoved $deletedCount cached file(s) and folder(s)."
        if (-not $NoLaunch) {
            $summaryMsg += "`n`nLaunching Civilization V..."
        }
        Write-Host "`n[SUCCESS] Cache cleared ($deletedCount items removed)." -ForegroundColor Green
    } else {
        $summaryMsg = "Did not clear cache: Nothing was found inside the cache folder."
        if (-not $NoLaunch) {
            $summaryMsg += "`n`nLaunching Civilization V..."
        }
        Write-Host "`n[INFO] Cache was not cleared because nothing was found inside." -ForegroundColor Green
    }
}

# 6. Non-blocking Notification (auto-closes in 3 seconds or on click)
try {
    $wshell = New-Object -ComObject WScript.Shell
    # 64 = Information Icon; 3 = auto-close after 3 seconds
    $wshell.Popup($summaryMsg, 3, "Civ V Cache Cleaner", 64) | Out-Null
} catch {
    # Fallback silently if COM is restricted
}

# 7. Launch Civilization V (skipped if -NoLaunch is specified)
if ($NoLaunch) {
    Write-Host "`nDone (launch skipped).`n" -ForegroundColor Green
    return
}

Write-Host "Launching Civilization V..." -ForegroundColor Cyan

if ($SteamArgs -and $SteamArgs.Length -gt 0) {
    # Launched via Steam Launch Options (%command%)
    $exe = $SteamArgs[0].Trim(' "''')
    $extraArgs = @()
    if ($SteamArgs.Length -gt 1) {
        $extraArgs = $SteamArgs[1..($SteamArgs.Length - 1)]
    }
    Write-Host "Launching via Steam intercept: $exe" -ForegroundColor Cyan
    try {
        if ($extraArgs -and $extraArgs.Count -gt 0) {
            Start-Process -FilePath $exe -ArgumentList $extraArgs
        } else {
            Start-Process -FilePath $exe
        }
    } catch {
        Write-Host "`n[ERROR] Failed to start game executable: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
} else {
    # Launched standalone (Desktop shortcut or double-clicking the .bat)
    $gameLaunched = $false
    try {
        Start-Process "steam://rungameid/8930"
        $gameLaunched = $true
    } catch {
        Write-Host "Could not launch via Steam protocol, looking up direct executable..." -ForegroundColor Yellow
    }

    if (-not $gameLaunched) {
        $exeCandidates = @(
            "C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization V\CivilizationV_DX11.exe",
            "C:\Program Files\Steam\steamapps\common\Sid Meier's Civilization V\CivilizationV_DX11.exe"
        )

        $steamReg = Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue
        if ($steamReg -and $steamReg.SteamPath) {
            $steamPath = $steamReg.SteamPath -replace "/", "\"
            $exeCandidates += "$steamPath\steamapps\common\Sid Meier's Civilization V\CivilizationV_DX11.exe"
        }

        $foundExe = $exeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($foundExe) {
            Start-Process -FilePath $foundExe
        } else {
            Write-Host "Could not locate CivilizationV_DX11.exe automatically. Please launch the game through Steam." -ForegroundColor Red
        }
    }
}

Write-Host "Done!`n" -ForegroundColor Green
