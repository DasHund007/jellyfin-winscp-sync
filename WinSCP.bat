@echo off

:: The creator
echo Made by DasHund007. Thanks for using it! Any support is available here: https://discord.gg/ZyRe42SR4C
echo.
:: Just a quick reminder
echo Automatic WinSCP Files Syncing. 
echo (It will compare files to the selected drive and download the ones that aren't locally installed.)
echo.
echo.

:: Define the SFTP command details
:: Example: sftp://[USERNAME]:[PASSWORD].@[HOSTNAME]/ -hostkey="[HOSTKEY]"
set SFTP_COMMAND=sftp://dashund007:12345678.@dashund007.com/ -hostkey="ssh-ed24239 123 weirdStringIGuess/Blah"

:: Prompt the user for the drive letter
set /p drive_letter="Please specify the drive letter (A-Z) for synchronization: "
set drive_letter=%drive_letter:~0,1%

:: Set paths on the selected drive based on the input drive letter
set AnimePath=%drive_letter%:\Jellyfin\Anime
set ShowsPath=%drive_letter%:\Jellyfin\Shows
set MoviesPath=%drive_letter%:\Jellyfin\Movies

:: Log file remains on E:
set LogPath=E:\Jellyfin\WinSCP.log
echo Using log path: %LogPath%
echo Synchronizing to drive: %drive_letter%:\Jellyfin\

:: Ask for shutdown option
set /p confirm_shutdown="Do you want to shut down the PC after synchronization? (y/n): "
if /i "%confirm_shutdown%" neq "y" (
    echo Synchronization will proceed without shutting down the PC.
)

:: Synchronize Anime
echo Synchronizing Anime to %AnimePath%...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="%LogPath%" /ini=nul ^
  /command ^
    "open %SFTP_COMMAND%" ^
    "synchronize local -neweronly %AnimePath% ""/home9/thecat007/media/Anime""" ^
    "exit"

call :checkForNewCandidates "Anime"
echo No more Anime to sync...

:: Synchronize TV Shows
echo Synchronizing TV Shows to %ShowsPath%...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="%LogPath%" /ini=nul ^
  /command ^
    "open %SFTP_COMMAND%" ^
    "synchronize local -neweronly %ShowsPath% ""/home9/thecat007/media/Shows""" ^
    "exit"

call :checkForNewCandidates "Shows"
echo No more TV Shows to sync...

:: Synchronize Movies
echo Synchronizing Movies to %MoviesPath%...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="%LogPath%" /ini=nul ^
  /command ^
    "open %SFTP_COMMAND%" ^
    "synchronize local -neweronly %MoviesPath% ""/home9/thecat007/media/Movies""" ^
    "exit"

call :checkForNewCandidates "Movies"
echo No more Movies to sync...

:: Check the result
set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
    echo Success
) else (
    echo Error
)

:: Shutdown the PC if requested
if /i "%confirm_shutdown%"=="y" (
    shutdown /s /t 60
) else (
    echo Shutdown canceled.
)

exit /b %WINSCP_RESULT%

:checkForNewCandidates
set mediaType=%1
echo Checking for new candidates in %mediaType%...

"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /command ^
    "open %SFTP_COMMAND%" ^
    "ls ""/home9/thecat007/media/%mediaType%""" ^
    "exit"

echo New candidates check completed for %mediaType%.
exit /b
