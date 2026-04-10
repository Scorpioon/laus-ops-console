$ErrorActionPreference = 'Stop'

$path = "src/modules/submissions/components/Table/styles.module.css"

if (!(Test-Path $path)) {
  Write-Host "ERROR: file not found: $path" -ForegroundColor Red
  exit 1
}

$content = Get-Content $path -Raw -Encoding UTF8
$original = $content
$trimmed = $content.TrimEnd()

if ($trimmed.EndsWith("}")) {
  Write-Host "NO CHANGES: file already ends with a closing brace." -ForegroundColor Yellow
  exit 1
}

Copy-Item $path "$path.bak_v044b_missing_brace" -Force

$newContent = $trimmed + "`r`n}" + "`r`n"
Set-Content $path $newContent -Encoding UTF8

Write-Host "OK: missing closing brace appended." -ForegroundColor Green
Write-Host "Backup: $path.bak_v044b_missing_brace" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  npm run build" -ForegroundColor Yellow
