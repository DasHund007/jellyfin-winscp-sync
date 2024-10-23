@echo off
:: made by dashund007
set /p confirm_shutdown="Do you want to shut down the PC after synchronization? (y/n): "
if /i "%confirm_shutdown%" neq "y" (
    echo Synchronization will proceed without shutting down the PC.
)

echo Synchronizing Anime...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="E:\Jellyfin\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://[USERNAME]:[PASSWORD]@[DOMAIN]/ -hostkey=""ssh-ed25519 255 [HOSTKEY]""" ^
    "synchronize local -neweronly E:\Jellyfin\Anime ""/home9/[USERNAME]/media/Anime""" ^
    "exit"

echo Synchronizing TV Shows...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="E:\Jellyfin\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://[USERNAME]:[PASSWORD]@[DOMAIN]/ -hostkey=""ssh-ed25519 255 [HOSTKEY]""" ^
    "synchronize local -neweronly E:\Jellyfin\Shows ""/home9/[USERNAME]/media/Shows""" ^
    "exit"

echo Synchronizing Movies...
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="E:\Jellyfin\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://[USERNAME]:[PASSWORD]@[DOMAIN]/ -hostkey=""ssh-ed25519 255 [HOSTKEY]""" ^
    "synchronize local -neweronly E:\Jellyfin\Movies /home9/[USERNAME]/media/Movies" ^
    "exit"

set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
    echo Success
) else (
    echo Error
)

pause

if /i "%confirm_shutdown%"=="y" (
    shutdown /s /t 0
) else (
    echo Shutdown canceled.
)

exit /b %WINSCP_RESULT%
