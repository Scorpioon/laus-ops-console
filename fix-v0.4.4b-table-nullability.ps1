$ErrorActionPreference = 'Stop'

$path = 'src/modules/submissions/components/Table/index.tsx'

if (!(Test-Path $path)) {
  Write-Host "ERROR: file not found: $path" -ForegroundColor Red
  exit 1
}

$content = Get-Content $path -Raw -Encoding UTF8
$original = $content

$pattern = 'useEffect\(\(\) => \{[\s\S]*?\n\s*\}, \[\]\)'

$replacement = @'
  useEffect(() => {
    const rootEl = wrapRef.current
    if (!rootEl) return

    let active = false
    let startX = 0
    let scrollLeft = 0

    function onDown(e: MouseEvent) {
      const currentEl = wrapRef.current
      if (!currentEl) return
      const target = e.target as HTMLElement | null
      if (target?.closest('button, input, a, label, select, textarea')) return
      active = true
      startX = e.pageX
      scrollLeft = currentEl.scrollLeft
      currentEl.classList.add(styles.grabbing)
    }

    function onMove(e: MouseEvent) {
      if (!active) return
      const currentEl = wrapRef.current
      if (!currentEl) return
      currentEl.scrollLeft = scrollLeft - (e.pageX - startX) * 1.2
    }

    function endDrag() {
      if (!active) return
      active = false
      const currentEl = wrapRef.current
      if (!currentEl) return
      currentEl.classList.remove(styles.grabbing)
    }

    rootEl.addEventListener('mousedown', onDown)
    window.addEventListener('mousemove', onMove)
    window.addEventListener('mouseup', endDrag)
    rootEl.addEventListener('mouseleave', endDrag)

    return () => {
      rootEl.removeEventListener('mousedown', onDown)
      window.removeEventListener('mousemove', onMove)
      window.removeEventListener('mouseup', endDrag)
      rootEl.removeEventListener('mouseleave', endDrag)
    }
  }, [])
'@

$newContent = [regex]::Replace($content, $pattern, $replacement, 1)

if ($newContent -eq $original) {
  Write-Host 'ERROR: useEffect block not replaced.' -ForegroundColor Red
  exit 1
}

Copy-Item $path "$path.bak_v044b_nullability" -Force
Set-Content $path $newContent -Encoding UTF8

Write-Host 'OK: v0.4.4b Table nullability fix applied.' -ForegroundColor Green
Write-Host "Backup: $path.bak_v044b_nullability" -ForegroundColor DarkGray
Write-Host ''
Write-Host 'Next:' -ForegroundColor Yellow
Write-Host '  npm run build' -ForegroundColor Yellow
