@echo off
title Ad Dream - Log Cleanup
color 0B

set SERVER_DIR=%~dp0
set LOG_DIR=%SERVER_DIR%logs

echo ================================================
echo   Ad Dream - Log Cleanup
echo ================================================
echo.

REM Delete logs older than 3 days
echo [INFO] Cleaning logs older than 3 days...
forfiles /p "%LOG_DIR%" /s /m *.log /d -3 /c "cmd /c del @path" 2>nul
forfiles /p "%LOG_DIR%" /s /m *.log.gz /d -7 /c "cmd /c del @path" 2>nul

REM Compress old logs
echo [INFO] Compressing logs older than 1 day...
forfiles /p "%LOG_DIR%" /s /m *.log /d -1 /c "cmd /c gzip @path" 2>nul

REM Delete compressed logs older than 7 days
echo [INFO] Deleting compressed logs older than 7 days...
forfiles /p "%LOG_DIR%" /s /m *.log.gz /d -7 /c "cmd /c del @path" 2>nul

echo.
echo [INFO] Log cleanup completed!
echo.
pause
