@echo off
echo ========================================
echo BattleFrog - Debug Launcher
echo ========================================
echo.
echo This will help identify any launch issues.
echo.
echo Looking for Godot...
echo.

:: Use the specific Godot path provided by user
set GODOT_PATH=C:\Users\tony\GitHub\Godot_v4.6-stable_win64.exe

if not exist "%GODOT_PATH%" (
    echo ERROR: Godot not found at %GODOT_PATH%
    echo.
    pause
    exit /b 1
)

echo Found Godot at: %GODOT_PATH%
echo.
echo Starting game with console output...
echo ========================================
echo.

:: Launch with console output
"%GODOT_PATH%" --path "%~dp0" --verbose 2>&1

echo.
echo ========================================
echo Game closed. Check output above for errors.
echo ========================================
pause
