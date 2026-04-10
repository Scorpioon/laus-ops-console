$ErrorActionPreference = 'Stop'

$path = "src/modules/submissions/components/Table/styles.module.css"

if (!(Test-Path $path)) {
  Write-Host "ERROR: file not found: $path" -ForegroundColor Red
  exit 1
}

$content = Get-Content $path -Raw -Encoding UTF8
$original = $content

# Remove the invalid/fragile :local custom-property block used only as a comment-era helper.
$pattern = "(?s)/\* --cb-w: checkbox column width used by both col1 width and col2 left offset \*/\s*:local\s*\{\s*--cb-w:\s*30px;\s*\}\s*"
$replacement = ""

$newContent = [regex]::Replace($content, $pattern, $replacement, 1)

if ($newContent -eq $original) {
  Write-Host "NO CHANGES: expected :local custom-property block not found." -ForegroundColor Yellow
  exit 1
}

Copy-Item $path "$path.bak_v044b_local_block" -Force
Set-Content $path $newContent -Encoding UTF8

Write-Host "OK: removed fragile :local custom-property block from Table/styles.module.css" -ForegroundColor Green
Write-Host "Backup: $path.bak_v044b_local_block" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  npm run build" -ForegroundColor Yellow
