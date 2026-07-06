@echo off
title Ad Dream - Scheduled Backup
color 0A

set SERVER_DIR=%~dp0
set SAVE_DIR=%SERVER_DIR%save
set LOG_DIR=%SERVER_DIR%logs\backup

REM Create directories
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM Get current date
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set YEAR=%datetime:~0,4%
set MONTH=%datetime:~4,2%
set DAY=%datetime:~6,2%
set BACKUP_NAME=%YEAR%-%MONTH%-%DAY%

REM Check if backup already exists today
if exist "%SAVE_DIR%\%BACKUP_NAME%" (
    echo [INFO] Backup already exists for today: %BACKUP_NAME%
    exit /b 0
)

echo [%date% %time%] Starting backup: %BACKUP_NAME% >> "%LOG_DIR%\backup.log"

REM Create backup directory
set BACKUP_DIR=%SAVE_DIR%\%BACKUP_NAME%
mkdir "%BACKUP_DIR%"

REM Copy world folders
xcopy "%SERVER_DIR%world" "%BACKUP_DIR%\world\" /E /I /H /Y /Q
xcopy "%SERVER_DIR%world_nether" "%BACKUP_DIR%\world_nether\" /E /I /H /Y /Q
xcopy "%SERVER_DIR%world_the_end" "%BACKUP_DIR%\world_the_end\" /E /I /H /Y /Q

REM Copy server configs
copy "%SERVER_DIR%server.properties" "%BACKUP_DIR%" /Y
copy "%SERVER_DIR%purpur.yml" "%BACKUP_DIR%" /Y
xcopy "%SERVER_DIR%config" "%BACKUP_DIR%\config\" /E /I /H /Y /Q

REM Delete backups older than 7 days
forfiles /p "%SAVE_DIR%" /d -7 /c "cmd /c if @isdir==TRUE rmdir /s /q @path" 2>nul

echo [%date% %time%] Backup completed: %BACKUP_NAME% >> "%LOG_DIR%\backup.log"
