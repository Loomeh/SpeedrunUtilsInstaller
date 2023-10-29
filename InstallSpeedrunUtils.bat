@echo off

set "bepinex=https://github.com/Loomeh/SpeedrunUtilsInstaller/raw/main/BepInEx.zip"
set "livesplitserver=https://github.com/LiveSplit/LiveSplit.Server/releases/download/1.8.19/LiveSplit.Server.zip"

set /p "gamedirectory=Please enter your BRC install directory. It'll probably be something like (C:\Program Files (x86)\Steam\steamapps\common\BombRushCyberfunk): "

set /p "livesplitdirectory=Please enter your LiveSplit directory: "

powershell -command "(New-Object System.Net.WebClient).DownloadFile('%bepinex%', '%gamedirectory%\bepinex.zip')"
powershell -command "Expand-Archive -Path '%gamedirectory%\bepinex.zip' -DestinationPath '%gamedirectory%' -Force"
del /Q "%gamedirectory%\bepinex.zip"

powershell -command "(New-Object System.Net.WebClient).DownloadFile('%livesplitserver%', '%livesplitdirectory%\Components\livesplitserver.zip')"
powershell -command "Expand-Archive -Path '%livesplitdirectory%\Components\livesplitserver.zip' -DestinationPath '%livesplitdirectory%\Components\' -Force"
del /Q "%livesplitdirectory%\Components\livesplitserver.zip"

REM Define the GitHub repository and owner
set "owner=Loomeh"
set "repo=SpeedrunUtils"
set "filename=SpeedrunUtils.dll"

REM Use curl to get the latest release information
curl -s https://api.github.com/repos/%owner%/%repo%/releases/latest > latest_release.json

REM Parse JSON response to get the download URL for SpeedrunUtils.dll
for /f "tokens=3 delims=:," %%i in ('type latest_release.json ^| find "browser_download_url" ^| find "%filename%"') do (
    set "download_url=%%i"
    goto :DownloadFile
)

:DownloadFile
REM Use curl to download SpeedrunUtils.dll
curl -L -o "%gamedirectory%\BepInEx\plugins\%filename%" "%download_url:~2,-1%"

REM Clean up: delete the JSON file
del latest_release.json

REM Display success message
@echo Successfully installed. Make sure to add the LiveSplit Server to your LiveSplit layout "Edit Layout -> Add -> Control -> LiveSplit Server" and enable it "Right click window -> Control -> Start server"
pause