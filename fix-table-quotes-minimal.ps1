$ErrorActionPreference = 'Stop'

$path = "src\modules\submissions\components\Table\index.tsx"

if (!(Test-Path $path)) {
  Write-Host "ERROR: file not found: $path" -ForegroundColor Red
  exit 1
}

$content = Get-Content $path -Raw -Encoding UTF8
$original = $content

$content = $content.Replace("''button, input, a, label, select, textarea''", "'button, input, a, label, select, textarea'")
$content = $content.Replace("''mousedown''", "'mousedown'")
$content = $content.Replace("''mousemove''", "'mousemove'")
$content = $content.Replace("''mouseup''", "'mouseup'")
$content = $content.Replace("''mouseleave''", "'mouseleave'")

if ($content -eq $original) {
  Write-Host "NO CHANGES: expected broken quote tokens not found." -ForegroundColor Yellow
  exit 1
}

Copy-Item $path "$path.bak2" -Force
Set-Content $path $content -Encoding UTF8

Write-Host "OK: minimal quote fix applied." -ForegroundColor Green
Write-Host "Backup: $path.bak2" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  npm run build" -ForegroundColor Yellow