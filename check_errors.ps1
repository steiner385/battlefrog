# Capture Godot errors to a log file

Write-Host "Searching for Godot installation..." -ForegroundColor Cyan

$godotPaths = @(
    "$env:USERPROFILE\Downloads\Godot*.exe",
    "$env:USERPROFILE\Desktop\Godot*.exe",
    "C:\Godot\Godot*.exe",
    "$env:LOCALAPPDATA\Godot\Godot*.exe",
    "$env:ProgramFiles\Godot\Godot*.exe"
)

$godotExe = $null
foreach ($pattern in $godotPaths) {
    $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $godotExe = $found.FullName
        break
    }
}

if (-not $godotExe) {
    Write-Host "ERROR: Godot not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please tell me where your Godot executable is located, or:"
    Write-Host "1. Download Godot 4.x from https://godotengine.org/download"
    Write-Host "2. Place it in your Downloads or Desktop folder"
    Write-Host "3. Run this script again"
    Write-Host ""
    
    $manualPath = Read-Host "Enter Godot executable path (or press Enter to exit)"
    if ($manualPath -and (Test-Path $manualPath)) {
        $godotExe = $manualPath
    } else {
        exit 1
    }
}

Write-Host "Found Godot at: $godotExe" -ForegroundColor Green
Write-Host ""

$projectPath = "c:\Users\tony\GitHub\battlefrog"
$logFile = "$projectPath\godot_errors.log"

Write-Host "Launching Godot with error logging..." -ForegroundColor Cyan
Write-Host "Log file: $logFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "The game window will open. Close it when done testing." -ForegroundColor White
Write-Host "Press Ctrl+C here to stop if it hangs." -ForegroundColor White
Write-Host ""

# Launch Godot and capture output
& $godotExe --path $projectPath --headless --quit 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking for errors..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$logContent = Get-Content $logFile -Raw

# Parse errors
$errors = @()
$warnings = @()

if ($logContent -match "ERROR") {
    $errors = ($logContent -split "`n" | Where-Object { $_ -match "ERROR" })
}
if ($logContent -match "WARNING" -or $logContent -match "WARN") {
    $warnings = ($logContent -split "`n" | Where-Object { $_ -match "WARNING|WARN" })
}

if ($errors.Count -gt 0) {
    Write-Host "`nERRORS FOUND:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  $error" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`nWARNINGS:" -ForegroundColor Yellow
    foreach ($warning in $warnings | Select-Object -First 5) {
        Write-Host "  $warning" -ForegroundColor Yellow
    }
}

if ($errors.Count -eq 0) {
    Write-Host "`nNo errors found! Trying to launch game window..." -ForegroundColor Green
    Write-Host ""
    & $godotExe --path $projectPath
}

Write-Host "`nFull log saved to: $logFile" -ForegroundColor Cyan
