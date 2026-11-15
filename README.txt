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
Library automatically clears the cache, shows the notification, and then opens 
the Civ V DirectX options dialog!

STEP-BY-STEP SETUP (Takes 30 seconds):
--------------------------------------------------------------------------------
!!! YOU DO NEED TO EXTRACT FROM ZIP, THE BAT FILES WILL NOT WORK WHILE ZIPPED !!!
1. In this folder, double-click "Copy-Steam-Launch-Option.bat".
   (This automatically formats and copies the exact command to your clipboard!)

!!! YOU DO NEED TO EXTRACT FROM ZIP, THE BAT FILES WILL NOT WORK WHILE ZIPPED !!!

   - OR manually: Hold Shift, right-click "Clear-Cache-Only.bat", 
     select "Copy as path", and add a space and %command% at the end.

2. Open Steam and go to your LIBRARY.
3. Right-click "Sid Meier's Civilization V" and click "Properties...".
4. In the "General" tab, look for the "Launch Options" box at the very bottom.
5. Paste (Ctrl+V) the command into the box.

   Format:
   "<Path to where you extracted this>\Clear-Cache-Only.bat" %command%

6. Close the Properties window.

THAT'S IT! 
From now on, whenever you click "PLAY" in Steam:
  [1] The cache is checked & cleared automatically.
  [2] A notification pops up confirming how many temporary files were removed.
  [3] Civilization V's DirectX selection window opens cleanly as normal!
################################################################################


--------------------------------------------------------------------------------
AVAILABLE SCRIPTS & WAYS TO USE
--------------------------------------------------------------------------------
* Clear-Cache-Only.bat
  Use this for Steam Launch Options, or double-click anytime to clear the cache 
  WITHOUT launching the game.

* Launch-Civ5-ClearCache.bat
  Clears the cache AND immediately starts Civilization V. Great if you don't 
  use Steam Launch Options and want a standalone 1-click launcher.

* Create-Desktop-Shortcut.bat
  Creates a "Civilization V (Clear Cache)" desktop shortcut with the official 
  game icon that runs Launch-Civ5-ClearCache.bat.


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
