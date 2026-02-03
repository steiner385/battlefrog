# Generate WAV sound files for BattleFrog

function Create-WavFile {
    param(
        [string]$FilePath,
        [int]$Frequency,
        [double]$Duration
    )
    
    $SampleRate = 44100
    $NumSamples = [int]($SampleRate * $Duration)
    $DataSize = $NumSamples * 2  # 16-bit = 2 bytes per sample
    
    # Create byte array for entire WAV file
    $WavData = New-Object byte[] (44 + $DataSize)
    
    # RIFF header
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes("RIFF"), 0, $WavData, 0, 4)
    [Array]::Copy([BitConverter]::GetBytes([int32](36 + $DataSize)), 0, $WavData, 4, 4)
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes("WAVE"), 0, $WavData, 8, 4)
    
    # fmt subchunk
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes("fmt "), 0, $WavData, 12, 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]16), 0, $WavData, 16, 4)  # Subchunk size
    [Array]::Copy([BitConverter]::GetBytes([int16]1), 0, $WavData, 20, 2)   # Audio format (PCM)
    [Array]::Copy([BitConverter]::GetBytes([int16]1), 0, $WavData, 22, 2)   # Num channels (mono)
    [Array]::Copy([BitConverter]::GetBytes([int32]$SampleRate), 0, $WavData, 24, 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]($SampleRate * 2)), 0, $WavData, 28, 4)  # Byte rate
    [Array]::Copy([BitConverter]::GetBytes([int16]2), 0, $WavData, 32, 2)   # Block align
    [Array]::Copy([BitConverter]::GetBytes([int16]16), 0, $WavData, 34, 2)  # Bits per sample
    
    # data subchunk
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes("data"), 0, $WavData, 36, 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]$DataSize), 0, $WavData, 40, 4)
    
    # Generate sine wave samples with envelope
    for ($i = 0; $i -lt $NumSamples; $i++) {
        $time = $i / $SampleRate
        
        # Fade in/out envelope
        $fadeIn = [Math]::Min(1.0, $i / 1000.0)
        $fadeOut = [Math]::Min(1.0, ($NumSamples - $i) / 1000.0)
        $envelope = $fadeIn * $fadeOut
        
        # Generate sine wave
        $sample = [Math]::Sin(2 * [Math]::PI * $Frequency * $time)
        $value = [int16]($sample * 16000 * $envelope)
        
        # Write sample to byte array
        $sampleBytes = [BitConverter]::GetBytes($value)
        [Array]::Copy($sampleBytes, 0, $WavData, 44 + ($i * 2), 2)
    }
    
    # Write to file
    [System.IO.File]::WriteAllBytes($FilePath, $WavData)
    $sizeKB = [math]::Round((44 + $DataSize)/1024, 1)
    Write-Host "Created: $FilePath ($sizeKB KB)"
}

# Generate sound effects
$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $basePath) { $basePath = $PSScriptRoot }
if (-not $basePath) { $basePath = "." }

Write-Host ""
Write-Host "Generating sound effects for BattleFrog..."
Write-Host "Output directory: $basePath"
Write-Host ""

Create-WavFile -FilePath (Join-Path $basePath "jump.wav") -Frequency 440 -Duration 0.1
Create-WavFile -FilePath (Join-Path $basePath "catch.wav") -Frequency 800 -Duration 0.12
Create-WavFile -FilePath (Join-Path $basePath "stun.wav") -Frequency 150 -Duration 0.2
Create-WavFile -FilePath (Join-Path $basePath "menu_select.wav") -Frequency 600 -Duration 0.06

Write-Host ""
Write-Host "All sound effects generated successfully!"
