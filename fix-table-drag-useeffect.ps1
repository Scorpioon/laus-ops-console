#Requires -Version 5.1
# LAUS OPS CONSOLE - fix Table drag useEffect nullability
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\fix-table-drag-useeffect.ps1

Set-StrictMode -Off
$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path
$target = Join-Path $root 'src\modules\submissions\components\Table\index.tsx'

if (!(Test-Path (Join-Path $root 'package.json'))) {
    Write-Host ''
    Write-Host 'ERROR: package.json not found in current folder.' -ForegroundColor Red
    Write-Host 'Go to the repo root first.' -ForegroundColor Yellow
    Write-Host 'Example:' -ForegroundColor Yellow
    Write-Host '  cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console' -ForegroundColor Yellow
    Write-Host '  .\fix-table-drag-useeffect.ps1' -ForegroundColor Yellow
    Write-Host ''
    exit 1
}

if (!(Test-Path $target)) {
    Write-Host ''
    Write-Host 'ERROR: target file not found:' -ForegroundColor Red
    Write-Host "  $target" -ForegroundColor Red
    Write-Host ''
    exit 1
}

$content = [System.IO.File]::ReadAllText($target)

$pattern = 'useEffect\(\(\) => \{\s*const el = wrapRef\.current[\s\S]*?\}, \[\]\)'
$replacement = @'
useEffect(() => {
  const el = wrapRef.current
  if (!el) return

  let isDown = false
  let startX = 0
  let scrollLeft = 0

  const onDown = (e: MouseEvent) => {
    const target = e.target as HTMLElement | null
    if (target?.closest(''button, input, a, label, select, textarea'')) return

    isDown = true
    startX = e.pageX
    scrollLeft = el.scrollLeft
    el.classList.add(styles.grabbing)
  }

  const onMove = (e: MouseEvent) => {
    if (!isDown) return
    e.preventDefault()
    const dx = e.pageX - startX
    el.scrollLeft = scrollLeft - dx
  }

  const onUp = () => {
    isDown = false
    el.classList.remove(styles.grabbing)
  }

  const onLeave = () => {
    isDown = false
    el.classList.remove(styles.grabbing)
  }

  el.addEventListener(''mousedown'', onDown)
  window.addEventListener(''mousemove'', onMove)
  window.addEventListener(''mouseup'', onUp)
  el.addEventListener(''mouseleave'', onLeave)

  return () => {
    el.removeEventListener(''mousedown'', onDown)
    window.removeEventListener(''mousemove'', onMove)
    window.removeEventListener(''mouseup'', onUp)
    el.removeEventListener(''mouseleave'', onLeave)
  }
}, [])
'@

$newContent = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $replacement, 1)

if ($newContent -eq $content) {
    Write-Host ''
    Write-Host 'ERROR: matching useEffect block not found. No changes were made.' -ForegroundColor Red
    Write-Host 'Open src\modules\submissions\components\Table\index.tsx and check whether the drag useEffect changed shape.' -ForegroundColor Yellow
    Write-Host ''
    exit 1
}

$backup = "$target.bak"
[System.IO.File]::WriteAllText($backup, $content, (New-Object System.Text.UTF8Encoding $false))
[System.IO.File]::WriteAllText($target, $newContent, (New-Object System.Text.UTF8Encoding $false))

Write-Host ''
Write-Host 'OK: useEffect patched successfully.' -ForegroundColor Green
Write-Host "File:   $target" -ForegroundColor Cyan
Write-Host "Backup: $backup" -ForegroundColor DarkGray
Write-Host ''
Write-Host 'Now run:' -ForegroundColor Yellow
Write-Host '  npm run build' -ForegroundColor Yellow
Write-Host ''
