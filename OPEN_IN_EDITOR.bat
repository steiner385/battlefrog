@echo off
echo Opening BattleFrog in Godot Editor...
echo.
echo This will let you:
echo - See the scene tree and what's actually spawning
echo - Use the debugger to step through code
echo - Test the game with F5 (run) or F6 (run scene)
echo - Inspect node properties visually
echo.
start "" "C:\Users\tony\GitHub\Godot_v4.6-stable_win64.exe\Godot_v4.6-stable_win64.exe" --editor --path "%~dp0"
