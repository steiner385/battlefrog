@echo off
REM BattleFrog Quick Launcher
REM Usage: dev <command>

powershell -ExecutionPolicy Bypass -File "%~dp0dev.ps1" %*
