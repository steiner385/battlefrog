# BattleFrog Development Helper
# Usage: .\dev.ps1 <command>
#
# Commands:
#   play     - Run the game normally
#   editor   - Open in Godot editor
#   debug    - Run with debug console visible
#   test     - Run specific scene for testing
#   log      - Show recent game logs
#   check    - Validate project files
#   help     - Show this help

param(
    [Parameter(Position=0)]
    [string]$Command = "help",

    [Parameter(Position=1)]
    [string]$Scene = ""
)

$GodotPath = "..\godot\Godot_v4.6-stable_win64.exe"
$GodotConsole = "..\godot\Godot_v4.6-stable_win64_console.exe"
$ProjectPath = $PSScriptRoot

function Show-Help {
    Write-Host @"

  BattleFrog Development Helper
  =============================

  COMMANDS:

    .\dev.ps1 play          Run the game (starts at menu)
    .\dev.ps1 editor        Open project in Godot editor
    .\dev.ps1 debug         Run with console for error output
    .\dev.ps1 test <scene>  Run a specific scene directly
    .\dev.ps1 log           Show recent Godot logs
    .\dev.ps1 check         Validate all GDScript files
    .\dev.ps1 help          Show this help

  TEST SCENES:

    .\dev.ps1 test frog     Test frog movement only
    .\dev.ps1 test fly      Test fly behavior only
    .\dev.ps1 test menu     Start at menu screen
    .\dev.ps1 test main     Start gameplay directly

  QUICK DEBUGGING:

    .\dev.ps1 debug         Shows errors in console window

  EXAMPLES:

    .\dev.ps1 play          # Normal gameplay
    .\dev.ps1 test frog     # Test just the frog
    .\dev.ps1 debug         # Run with error console

"@
}

function Start-Game {
    Write-Host "Starting BattleFrog..." -ForegroundColor Green
    & $GodotPath --path $ProjectPath
}

function Start-Editor {
    Write-Host "Opening Godot Editor..." -ForegroundColor Cyan
    & $GodotPath --path $ProjectPath --editor
}

function Start-Debug {
    Write-Host "Starting BattleFrog (Debug Mode)..." -ForegroundColor Yellow
    Write-Host "Errors will appear in this console window." -ForegroundColor Yellow
    Write-Host "Press Ctrl+C to stop." -ForegroundColor Gray
    Write-Host ""
    & $GodotConsole --path $ProjectPath --verbose
}

function Start-TestScene {
    param([string]$SceneName)

    $sceneMap = @{
        "frog"   = "game/frog/frog.tscn"
        "fly"    = "game/fly/fly.tscn"
        "tongue" = "game/tongue/tongue.tscn"
        "menu"   = "game/ui/menu.tscn"
        "main"   = "game/main.tscn"
        "hud"    = "game/ui/hud.tscn"
        "gameover" = "game/ui/game_over.tscn"
    }

    if ($sceneMap.ContainsKey($SceneName.ToLower())) {
        $scenePath = $sceneMap[$SceneName.ToLower()]
        Write-Host "Testing scene: $scenePath" -ForegroundColor Magenta
        & $GodotConsole --path $ProjectPath $scenePath
    } else {
        Write-Host "Unknown scene: $SceneName" -ForegroundColor Red
        Write-Host "Available scenes: $($sceneMap.Keys -join ', ')" -ForegroundColor Yellow
    }
}

function Show-Logs {
    $logPath = "$env:APPDATA\Godot\app_userdata\BattleFrog\logs"

    if (Test-Path $logPath) {
        $latestLog = Get-ChildItem $logPath -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestLog) {
            Write-Host "Latest log: $($latestLog.FullName)" -ForegroundColor Cyan
            Write-Host "---" -ForegroundColor Gray
            Get-Content $latestLog.FullName -Tail 50
        }
    } else {
        # Fallback to default Godot log location
        $defaultLog = "$env:APPDATA\Godot\godot.log"
        if (Test-Path $defaultLog) {
            Write-Host "Godot log:" -ForegroundColor Cyan
            Get-Content $defaultLog -Tail 50
        } else {
            Write-Host "No logs found. Run the game first to generate logs." -ForegroundColor Yellow
        }
    }
}

function Test-Project {
    Write-Host "Validating BattleFrog project..." -ForegroundColor Cyan
    Write-Host ""

    # Check required files
    $requiredFiles = @(
        "project.godot",
        "game/main.tscn",
        "game/main.gd",
        "game/autoload/game_state.gd",
        "game/frog/frog.tscn",
        "game/frog/frog.gd",
        "game/fly/fly.tscn",
        "game/fly/fly.gd",
        "game/tongue/tongue.tscn",
        "game/tongue/tongue.gd",
        "game/ui/menu.tscn",
        "game/ui/menu.gd",
        "game/ui/hud.tscn",
        "game/ui/hud.gd"
    )

    $missing = @()
    $found = 0

    foreach ($file in $requiredFiles) {
        $fullPath = Join-Path $ProjectPath $file
        if (Test-Path $fullPath) {
            Write-Host "  [OK] $file" -ForegroundColor Green
            $found++
        } else {
            Write-Host "  [MISSING] $file" -ForegroundColor Red
            $missing += $file
        }
    }

    Write-Host ""
    Write-Host "Found: $found / $($requiredFiles.Count) required files" -ForegroundColor $(if ($missing.Count -eq 0) { "Green" } else { "Yellow" })

    # Check GDScript line counts (constitution: <100 lines)
    Write-Host ""
    Write-Host "Checking GDScript file sizes (max 100 lines)..." -ForegroundColor Cyan

    $gdFiles = Get-ChildItem -Path $ProjectPath -Filter "*.gd" -Recurse
    foreach ($file in $gdFiles) {
        $lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines
        $status = if ($lineCount -le 100) { "[OK]" } else { "[WARN]" }
        $color = if ($lineCount -le 100) { "Green" } else { "Yellow" }
        $relativePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        Write-Host "  $status $relativePath : $lineCount lines" -ForegroundColor $color
    }

    if ($missing.Count -eq 0) {
        Write-Host ""
        Write-Host "Project validation passed!" -ForegroundColor Green
    }
}

# Main command dispatcher
switch ($Command.ToLower()) {
    "play"   { Start-Game }
    "editor" { Start-Editor }
    "debug"  { Start-Debug }
    "test"   { Start-TestScene -SceneName $Scene }
    "log"    { Show-Logs }
    "check"  { Test-Project }
    "help"   { Show-Help }
    default  { Show-Help }
}
