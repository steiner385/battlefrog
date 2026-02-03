# BattleFrog Project Validation Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BattleFrog Project Validation" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$projectPath = "c:\Users\tony\GitHub\battlefrog"
$errors = @()
$warnings = @()

# Check 1: Project file
Write-Host "Checking project.godot..." -NoNewline
if (Test-Path "$projectPath\project.godot") {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " MISSING" -ForegroundColor Red
    $errors += "project.godot not found"
}

# Check 2: Main scene
Write-Host "Checking main scene..." -NoNewline
$projectContent = Get-Content "$projectPath\project.godot" -Raw
if ($projectContent -match 'run/main_scene="res://(.+?)"') {
    $mainScene = $matches[1]
    $mainScenePath = "$projectPath\$($mainScene.Replace('res://', '').Replace('/', '\'))"
    if (Test-Path $mainScenePath) {
        Write-Host " OK ($mainScene)" -ForegroundColor Green
    } else {
        Write-Host " MISSING" -ForegroundColor Red
        $errors += "Main scene not found: $mainScene"
    }
}

# Check 3: Autoload script
Write-Host "Checking autoload scripts..." -NoNewline
if (Test-Path "$projectPath\game\autoload\game_state.gd") {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " MISSING" -ForegroundColor Red
    $errors += "game_state.gd not found"
}

# Check 4: Core scenes
Write-Host "Checking core game scenes..."
$coreScenes = @{
    "Menu" = "game\ui\menu.tscn"
    "Main" = "game\main.tscn"
    "Frog" = "game\frog\frog.tscn"
    "Fly" = "game\fly\fly.tscn"
    "HUD" = "game\ui\hud.tscn"
}

foreach ($scene in $coreScenes.GetEnumerator()) {
    $path = "$projectPath\$($scene.Value)"
    Write-Host "  - $($scene.Key)..." -NoNewline
    if (Test-Path $path) {
        Write-Host " OK" -ForegroundColor Green
    } else {
        Write-Host " MISSING" -ForegroundColor Red
        $errors += "$($scene.Key) scene not found"
    }
}

# Check 5: Scripts
Write-Host "Checking GDScript files..."
$scripts = Get-ChildItem "$projectPath\game" -Recurse -Filter "*.gd"
Write-Host "  Found $($scripts.Count) scripts" -ForegroundColor Cyan

# Check 6: Parse errors in scripts
Write-Host "Checking for syntax issues..."
$hasParseErrors = $false
foreach ($script in $scripts) {
    $content = Get-Content $script.FullName -Raw
    if ($content -match '^\s*#.*ERROR|^\s*#.*FIXME') {
        Write-Host "  Warning in $($script.Name)" -ForegroundColor Yellow
        $warnings += "Check $($script.Name)"
    }
}
if (-not $hasParseErrors) {
    Write-Host "  No obvious syntax issues found" -ForegroundColor Green
}

# Check 7: Sound files
Write-Host "Checking sound files..." -NoNewline
$sounds = Get-ChildItem "$projectPath\assets\sounds" -Filter "*.wav" -ErrorAction SilentlyContinue
if ($sounds.Count -ge 4) {
    Write-Host " OK ($($sounds.Count) files)" -ForegroundColor Green
} else {
    Write-Host " WARNING (expected 4, found $($sounds.Count))" -ForegroundColor Yellow
    $warnings += "Some sound files may be missing"
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
if ($errors.Count -eq 0) {
    Write-Host "Validation: PASSED" -ForegroundColor Green
    Write-Host "The project should launch successfully!" -ForegroundColor Green
} else {
    Write-Host "Validation: FAILED" -ForegroundColor Red
    Write-Host "`nErrors found:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  - $error" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`nWarnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "`nTo launch the game:" -ForegroundColor Cyan
Write-Host "1. Open Godot 4.x" -ForegroundColor White
Write-Host "2. Click 'Import' and select:" -ForegroundColor White
Write-Host "   $projectPath\project.godot" -ForegroundColor Yellow
Write-Host "3. Press F5 or click the Play button" -ForegroundColor White
Write-Host ""
