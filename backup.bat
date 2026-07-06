@echo off
title Ad Dream - Backup Server
color 0A

set SERVER_DIR=%~dp0
set SAVE_DIR=%SERVER_DIR%save
set LOG_DIR=%SERVER_DIR%logs

REM Create save directory if not exists
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%"

REM Get current date in format YYYY-MM-DD
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set YEAR=%datetime:~0,4%
set MONTH=%datetime:~4,2%
set DAY=%datetime:~6,2%
set HOUR=%datetime:~8,2%
set MIN=%datetime:~10,2%
set BACKUP_NAME=%YEAR%-%MONTH%-%DAY%_%HOUR%-%MIN%

echo ================================================
echo   Ad Dream - Backup
echo   %BACKUP_NAME%
echo ================================================
echo.

echo [INFO] Creating backup: %BACKUP_NAME%
echo.

REM Create backup directory
set BACKUP_DIR=%SAVE_DIR%\%BACKUP_NAME%
mkdir "%BACKUP_DIR%"

REM Copy world folders
echo [INFO] Copying world...
xcopy "%SERVER_DIR%world" "%BACKUP_DIR%\world\" /E /I /H /Y /Q
echo [INFO] Copying world_nether...
xcopy "%SERVER_DIR%world_nether" "%BACKUP_DIR%\world_nether\" /E /I /H /Y /Q
echo [INFO] Copying world_the_end...
xcopy "%SERVER_DIR%world_the_end" "%BACKUP_DIR%\world_the_end\" /E /I /H /Y /Q

REM Copy server configs
echo [INFO] Copying configs...
copy "%SERVER_DIR%server.properties" "%BACKUP_DIR%" /Y
copy "%SERVER_DIR%purpur.yml" "%BACKUP_DIR%" /Y
xcopy "%SERVER_DIR%config" "%BACKUP_DIR%\config\" /E /I /H /Y /Q
xcopy "%SERVER_DIR%plugins" "%BACKUP_DIR%\plugins\" /E /I /H /Y /Q

REM Delete backups older than 7 days
echo [INFO] Cleaning old backups...
forfiles /p "%SAVE_DIR%" /d -7 /c "cmd /c if @isdir==TRUE rmdir /s /q @path" 2>nul

echo.
echo [INFO] Backup completed: %BACKUP_NAME%
echo [INFO] Location: %BACKUP_DIR%
echo.
pause
