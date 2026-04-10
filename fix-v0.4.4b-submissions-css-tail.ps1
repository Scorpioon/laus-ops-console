$ErrorActionPreference = 'Stop'

$path = "src/modules/submissions/Submissions.module.css"

if (!(Test-Path $path)) {
  Write-Host "ERROR: file not found: $path" -ForegroundColor Red
  exit 1
}

$content = Get-Content $path -Raw -Encoding UTF8
$original = $content

$pattern = '(?s)/\* Toolbar colored buttons \(resting state\) --------------------------------- \*/.*$'
$replacement = @'
/* Toolbar colored buttons (resting state) --------------------------------- */
.toolbarCyan  { background: #E0F9FF !important; color: #0885A8 !important; border-color: #0885A833 !important; }
.toolbarGreen { background: #DCFCE7 !important; color: #15803D !important; border-color: #15803D33 !important; }
.toolbarRed   { background: #FFF0F6 !important; color: #C4294A !important; border-color: #C4294A33 !important; }
.toolbarAmber { background: #FFF7ED !important; color: #B45309 !important; border-color: #B4530933 !important; }
'@

$newContent = [regex]::Replace($content, $pattern, $replacement, 1)

if ($newContent -eq $original) {
  Write-Host "ERROR: toolbar CSS tail block not replaced." -ForegroundColor Red
  exit 1
}

Copy-Item $path "$path.bak_v044b_css_tail" -Force
Set-Content $path $newContent -Encoding UTF8

Write-Host "OK: v0.4.4b Submissions CSS tail fix applied." -ForegroundColor Green
Write-Host "Backup: $path.bak_v044b_css_tail" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  npm run build" -ForegroundColor Yellow
