# Scans assets/ for image files and generates slides.json
# Usage: .\generate-slides.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$assetsDir = Join-Path $scriptDir "assets"
$outputFile = Join-Path $scriptDir "slides.json"

$extensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg")
$exclude = @("404.png", ".gitkeep")

$files = @()
foreach ($ext in $extensions) {
    $found = Get-ChildItem -Path $assetsDir -Filter $ext -Recurse -File |
        Where-Object { $_.Name -notin $exclude }
    $files += $found
}

$slides = $files |
    ForEach-Object { $_.FullName.Substring($assetsDir.Length + 1).Replace("\", "/") } |
    Sort-Object

$json = $slides | ConvertTo-Json -Compress
if ($slides.Count -eq 1) { $json = "[$json]" }
if ($slides.Count -eq 0) { $json = "[]" }

Set-Content -Path $outputFile -Value $json -Encoding UTF8 -NoNewline
Write-Host "Generated slides.json with $($slides.Count) slides"
