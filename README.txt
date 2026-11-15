================================================================================
CIVILIZATION V CACHE CLEANER & PRE-LAUNCH UTILITY
================================================================================

A lightweight utility that safely clears the Civilization V cache before game 
boot, displays a desktop notification of cleared items, and launches the game.


################################################################################
#  FEATURE SPOTLIGHT: STEAM ONE-CLICK INTEGRATION                              #
#  Make Steam's standard "PLAY" button clear your cache automatically!        #
################################################################################

You don't need a separate desktop icon or have to remember to run a script.
You can configure Steam so that simply clicking "PLAY" inside your Steam 
Library automatically clears the cache, shows the notification, and launches!

STEP-BY-STEP SETUP (Takes 30 seconds):
--------------------------------------------------------------------------------
1. Open Steam and go to your LIBRARY.
2. Right-click "Sid Meier's Civilization V" and click "Properties...".
3. In the "General" tab, look for the "Launch Options" box at the very bottom.
4. Copy & paste the following line (including quotes and %command%):

   "%USERPROFILE%\Documents\GitHub\Civ5-Cache-Cleaner\Launch-Civ5-ClearCache.bat" %command%

   (Note: %USERPROFILE% automatically resolves to your Windows user account,
   or you can paste the full path like:
   "C:\Users\YourUsername\Documents\GitHub\Civ5-Cache-Cleaner\Launch-Civ5-ClearCache.bat" %command%)

5. Close the Properties window.

THAT'S IT! 
From now on, whenever you click "PLAY" in Steam:
  [1] The cache is checked & cleared automatically.
  [2] A notification pops up confirming how many temporary files were removed.
  [3] Civilization V boots up cleanly with Steam tracking your playtime normally!
################################################################################


--------------------------------------------------------------------------------
ALTERNATIVE WAYS TO LAUNCH: SHORTCUT OR BATCH FILE
--------------------------------------------------------------------------------
If you prefer not using Steam Launch Options:

* Method A: Double-click "Launch-Civ5-ClearCache.bat" anytime to clear cache 
            and launch the game.
* Method B: Double-click "Create-Desktop-Shortcut.bat" once. This places a 
            "Civilization V (Clear Cache)" shortcut with the official game icon 
            directly on your Desktop.


--------------------------------------------------------------------------------
CUSTOM CACHE FOLDER (OPTIONAL - 99% OF USERS DO NOT NEED THIS!)
--------------------------------------------------------------------------------
The utility automatically finds your cache folder in standard Documents or 
OneDrive folders. You only need this if your game files are on a custom path:

* Easy GUI: Double-click "Configure-Cache-Path.bat" to browse for your folder.
* Text File: Open "settings.txt" in Notepad and set:
  CustomCachePath = D:\CustomDrive\Sid Meier's Civilization 5\cache


--------------------------------------------------------------------------------
NOTE: WHY NOT AN IN-GAME MOD?
--------------------------------------------------------------------------------
Civ V locks its cache files on startup and sandboxes in-game mods from deleting 
files on disk. Cache clearing must happen right before the game launches.
================================================================================
