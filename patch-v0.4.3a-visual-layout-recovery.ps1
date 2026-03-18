#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3a - Visual Layout Recovery
#
# IMPORTANT: Save this file as UTF-8 before running.
#   VS Code:  File > Save with Encoding > UTF-8
#   Notepad:  Save As > Encoding: UTF-8
#
# Run from the project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3a-visual-layout-recovery.ps1
#
# Writes 17 files (10 modified, 7 new).
# Does NOT touch: workspaceStore, indexeddb, parser, submission.ts,
# jury, laurel, helpdesk, templates, settings, Footer, ActivityLog,
# Modal, ChipInput, app.tsx, uiStore.ts.
# =============================================================================

Set-StrictMode -Off
$ErrorActionPreference = 'Stop'

# Always use current working directory - never PSScriptRoot.
# Run from the project root.
$root = (Get-Location).Path

# Safety guard: confirm we are in the correct project root
$pkgJson = Join-Path $root 'package.json'
if (!(Test-Path $pkgJson)) {
    Write-Host ""
    Write-Host "ERROR: package.json not found in:" -ForegroundColor Red
    Write-Host "  $root" -ForegroundColor Red
    Write-Host ""
    Write-Host "Navigate to the project root first, e.g.:" -ForegroundColor Yellow
    Write-Host "  cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console" -ForegroundColor Yellow
    Write-Host "  .\patch-v0.4.3a-visual-layout-recovery.ps1" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

function Write-File {
    param([string]$Rel, [string]$Content)
    $full = Join-Path $root $Rel
    $dir  = Split-Path $full -Parent
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    # Write as UTF-8 without BOM
    [System.IO.File]::WriteAllText($full, $Content, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  OK  $Rel" -ForegroundColor Green
}

Write-Host ""
Write-Host "LAUS OPS CONSOLE - patch v0.4.3a" -ForegroundColor Cyan
Write-Host "Visual Layout Recovery" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  src\app.css
# =============================================================================
Write-File 'src\app.css' @'
/* src/app.css - v0.4.3a */

/* --- TOKENS ---------------------------------------------------------------- */
:root {
  --bg:       #ffffff;
  --bg2:      #f5f5f5;
  --bg3:      #ebebeb;
  --border:   #000000;
  --border2:  #d4d4d4;
  --border3:  #ebebeb;
  --text:     #000000;
  --text2:    #555555;
  --text3:    #999999;
  --hover:    #f5f5f5;
  --sel-bg:   #000000;
  --sel-fg:   #ffffff;
  --chip-bg:  #000000;
  --chip-fg:  #ffffff;
  /* Semaphore */
  --s-ok:      #16A34A;
  --s-ok-bg:   #DCFCE7;
  --s-warn:    #D97706;
  --s-warn-bg: #FFFBEB;
  --s-adj:     #6B7280;
  --s-adj-bg:  #F3F4F6;
  --s-des:     #DC2626;
  --s-des-bg:  #FEF2F2;
  /* Premio levels from ADG site CSS */
  --color-bronze: #a05400;
  --color-silver: #a3aaad;
  --color-gold:   #ae9a64;
  /* Info accent */
  --color-info: #2563EB;
  /* System */
  --radius:      2px;
  --font-family: 'NeueHaasUnica', 'NeueHaasUnicaPro', 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

[data-theme="dark"] {
  --bg:       #0b0b0b;
  --bg2:      #161616;
  --bg3:      #222222;
  --border:   #e0e0e0;
  --border2:  #2a2a2a;
  --border3:  #1e1e1e;
  --text:     #efefef;
  --text2:    #aaaaaa;
  --text3:    #555555;
  --hover:    #1a1a1a;
  --sel-bg:   #efefef;
  --sel-fg:   #000000;
  --chip-bg:  #efefef;
  --chip-fg:  #000000;
  --s-ok:      #4ADE80;
  --s-ok-bg:   #052E16;
  --s-warn:    #FCD34D;
  --s-warn-bg: #1C1400;
  --s-adj:     #9CA3AF;
  --s-adj-bg:  #111827;
  --s-des:     #F87171;
  --s-des-bg:  #1A0000;
}

/* --- RESET ----------------------------------------------------------------- */
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
  scrollbar-width: none;
}
*::-webkit-scrollbar { display: none; }

html, body { height: 100%; }

body {
  font-family: var(--font-family);
  font-size: 13px;
  background: var(--bg);
  color: var(--text);
  line-height: 1;
  -webkit-font-smoothing: antialiased;
}

a { color: inherit; text-decoration: none; }

button, select, input {
  font-family: inherit;
  font-size: inherit;
}

/* --- LAYOUT ---------------------------------------------------------------- */
.app {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
}

.main-content {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  background: var(--bg2);
  padding: 0;
}

/* --- TOOLBAR (shared) ------------------------------------------------------ */
.toolbar {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 12px;
  background: var(--bg);
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 34px;
  flex-wrap: wrap;
}

.toolbar-group {
  display: flex;
  align-items: center;
  gap: 2px;
  margin-right: 4px;
  padding-right: 4px;
  border-right: 1px solid var(--border3);
}

.toolbar-group:last-child {
  border-right: none;
  margin-right: 0;
  padding-right: 0;
}

/* --- UTILITY --------------------------------------------------------------- */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
'@


# =============================================================================
# 02  src\shared\ui\Button\index.tsx
# =============================================================================
Write-File 'src\shared\ui\Button\index.tsx' @'
// src/shared/ui/Button/index.tsx - v0.4.3a
import { type ButtonHTMLAttributes, type ReactNode } from 'react'
import styles from './styles.module.css'

// Semantic variants. Legacy primary/secondary/icon kept for backward compat.
type ButtonVariant =
  | 'primary'    // black fill (legacy)
  | 'secondary'  // border only (legacy)
  | 'icon'       // icon-only square (legacy)
  | 'save'       // green fill  - DESA
  | 'discard'    // amber fill  - DESCARTAR
  | 'delete'     // red fill    - ELIMINAR
  | 'neutral'    // border only - CONTACTE / DUPLICAR
  | 'ghost'      // no border, text only

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode
  variant?: ButtonVariant
}

export const Button = ({
  children,
  variant = 'secondary',
  className = '',
  ...props
}: ButtonProps) => {
  const variantClass = styles[variant] ?? styles.secondary
  return (
    <button
      className={`${styles.button} ${variantClass} ${className}`.trim()}
      {...props}
    >
      {children}
    </button>
  )
}
'@


# =============================================================================
# 03  src\shared\ui\Button\styles.module.css
# =============================================================================
Write-File 'src\shared\ui\Button\styles.module.css' @'
/* src/shared/ui/Button/styles.module.css - v0.4.3a */
.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 0 10px;
  height: 26px;
  font-size: 8.5px;
  font-weight: 400;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  border: 1px solid transparent;
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.1s;
  white-space: nowrap;
  flex-shrink: 0;
}

.button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* Legacy variants ---------------------------------------------------------- */
.primary {
  background: var(--text);
  color: var(--bg);
  border-color: var(--text);
}
.primary:hover:not(:disabled) { opacity: .82; }

.secondary {
  background: transparent;
  color: var(--text2);
  border-color: var(--border2);
}
.secondary:hover:not(:disabled) {
  background: var(--bg2);
  color: var(--text);
  border-color: var(--border);
}

.icon {
  padding: 0;
  width: 26px;
  height: 26px;
  background: transparent;
  border: 1px solid var(--border2);
  color: var(--text2);
  font-size: 13px;
}
.icon:hover:not(:disabled) {
  color: var(--text);
  border-color: var(--border);
  background: var(--bg2);
}

/* Semantic variants -------------------------------------------------------- */

/* DESA - green */
.save {
  background: var(--s-ok);
  color: #ffffff;
  border-color: var(--s-ok);
  font-weight: 700;
}
.save:hover:not(:disabled) { opacity: .85; }

/* DESCARTAR - amber */
.discard {
  background: var(--s-warn);
  color: #ffffff;
  border-color: var(--s-warn);
  font-weight: 700;
}
.discard:hover:not(:disabled) { opacity: .85; }

/* ELIMINAR - red */
.delete {
  background: var(--s-des);
  color: #ffffff;
  border-color: var(--s-des);
  font-weight: 700;
}
.delete:hover:not(:disabled) { opacity: .85; }

/* CONTACTE / DUPLICAR - neutral border */
.neutral {
  background: transparent;
  color: var(--text2);
  border-color: var(--border2);
}
.neutral:hover:not(:disabled) {
  background: var(--bg2);
  color: var(--text);
  border-color: var(--border);
}

/* Ghost - no border */
.ghost {
  background: transparent;
  color: var(--text3);
  border-color: transparent;
  padding: 0 4px;
}
.ghost:hover:not(:disabled) { color: var(--text); }
'@


# =============================================================================
# 04  src\shared\ui\StatusBadge\styles.module.css
# =============================================================================
Write-File 'src\shared\ui\StatusBadge\styles.module.css' @'
/* src/shared/ui/StatusBadge/styles.module.css - v0.4.3a */
/* Uses CSS tokens - correct in both light and dark mode. */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 2px 5px;
  font-size: 8px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  border-radius: var(--radius);
  border: 1px solid;
  line-height: 1.2;
  white-space: nowrap;
}

.ok {
  background: var(--s-ok-bg);
  color: var(--s-ok);
  border-color: var(--s-ok);
}

.warning {
  background: var(--s-warn-bg);
  color: var(--s-warn);
  border-color: var(--s-warn);
}

.issue {
  background: var(--s-des-bg);
  color: var(--s-des);
  border-color: var(--s-des);
}

.info {
  background: var(--s-adj-bg);
  color: var(--s-adj);
  border-color: var(--s-adj);
}

.neutral {
  background: var(--bg2);
  color: var(--text3);
  border-color: var(--border2);
}
'@


# =============================================================================
# 05  src\shared\layout\TopBar\index.tsx
# =============================================================================
Write-File 'src\shared\layout\TopBar\index.tsx' @'
// src/shared/layout/TopBar/index.tsx - v0.4.3a
// Single dense row: LOGO | TABS || KPI placeholder || OPERATOR CLOCK CA/ES THEME
import { useState, useEffect } from 'react'
import { useUIStore } from '../../../core/store/uiStore'
import styles from './styles.module.css'

const TABS = [
  { id: 'submissions', label: 'INSCRIPCIONS' },
  { id: 'jury',        label: 'JURATS'       },
  { id: 'templates',   label: 'PLANTILLES'   },
  { id: 'insights',    label: 'INSIGHTS'     },
  { id: 'helpdesk',    label: 'AJUDA'        },
  { id: 'laurel',      label: 'PREMIATS'     },
  { id: 'settings',    label: 'CONFIG'       },
]

// Isolated clock component - owns its own interval.
// Keeping it separate prevents clock ticks from re-rendering TopBar siblings.
function LiveClock() {
  const [ts, setTs] = useState(() => new Date())
  useEffect(() => {
    const id = setInterval(() => setTs(new Date()), 1000)
    return () => clearInterval(id)
  }, [])
  const pad = (n: number) => String(n).padStart(2, '0')
  return (
    <span className={styles.clock}>
      {pad(ts.getDate())}/{pad(ts.getMonth() + 1)}/{ts.getFullYear()}
      &nbsp;|&nbsp;
      {pad(ts.getHours())}:{pad(ts.getMinutes())}:{pad(ts.getSeconds())}
    </span>
  )
}

export function TopBar() {
  const { activeModule, setActiveModule, language, setLanguage, theme, toggleTheme } = useUIStore()

  // Sync theme attribute to document root
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  return (
    <header className={styles.topbar}>

      {/* LEFT: logo + separator + nav tabs */}
      <div className={styles.left}>
        <div className={styles.logo}>
          <span className={styles.logoPrimary}>LAUS OPS</span>
          <span className={styles.logoSecondary}>console</span>
        </div>
        <span className={styles.divider} aria-hidden="true">|</span>
        <nav className={styles.tabs} aria-label="Modules">
          {TABS.map((tab) => (
            <button
              key={tab.id}
              className={`${styles.tab} ${activeModule === tab.id ? styles.tabActive : ''}`}
              onClick={() => setActiveModule(tab.id)}
            >
              {tab.label}
            </button>
          ))}
        </nav>
      </div>

      {/* CENTER: KPI zone - populated in v0.4.3b */}
      <div className={styles.kpiZone}>
        <span className={styles.divider} aria-hidden="true">||</span>
        <span className={styles.kpiPlaceholder}>&mdash;</span>
        <span className={styles.divider} aria-hidden="true">||</span>
      </div>

      {/* RIGHT: operator name + live clock + language + theme */}
      <div className={styles.right}>
        <i className="bi bi-person-circle" aria-hidden="true"></i>
        <span className={styles.operator}>Operador ADG</span>
        <LiveClock />
        <span className={styles.divider} aria-hidden="true">||</span>
        <div className={styles.langWrap}>
          <button
            className={`${styles.langBtn} ${language === 'ca' ? styles.langActive : ''}`}
            onClick={() => setLanguage('ca')}
          >CA</button>
          <button
            className={`${styles.langBtn} ${language === 'es' ? styles.langActive : ''}`}
            onClick={() => setLanguage('es')}
          >ES</button>
        </div>
        <button
          className={styles.themeBtn}
          onClick={toggleTheme}
          aria-label="Toggle theme"
        >
          {theme === 'light'
            ? <i className="bi bi-sun" aria-hidden="true"></i>
            : <i className="bi bi-moon-stars" aria-hidden="true"></i>
          }
        </button>
      </div>

    </header>
  )
}
'@


# =============================================================================
# 06  src\shared\layout\TopBar\styles.module.css
# =============================================================================
Write-File 'src\shared\layout\TopBar\styles.module.css' @'
/* src/shared/layout/TopBar/styles.module.css - v0.4.3a */

.topbar {
  display: flex;
  align-items: stretch;
  height: 32px;
  background: var(--bg);
  border-bottom: 1px solid var(--border);
  overflow-x: auto;
  scrollbar-width: none;
  flex-shrink: 0;
  white-space: nowrap;
  color: var(--text);
}
.topbar::-webkit-scrollbar { display: none; }

/* Left zone ---------------------------------------------------------------- */
.left {
  display: flex;
  align-items: stretch;
  flex-shrink: 0;
}

.logo {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 0 14px 0 16px;
  border-right: 1px solid var(--border2);
  flex-shrink: 0;
}

.logoPrimary {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--text);
}

.logoSecondary {
  font-size: 8px;
  font-weight: 400;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text3);
}

.divider {
  display: flex;
  align-items: center;
  padding: 0 6px;
  font-size: 9px;
  color: var(--border2);
  flex-shrink: 0;
  user-select: none;
}

/* Tabs --------------------------------------------------------------------- */
.tabs {
  display: flex;
  align-items: stretch;
  flex-shrink: 0;
}

.tab {
  display: flex;
  align-items: center;
  padding: 0 10px;
  font-size: 8px;
  font-weight: 400;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text3);
  background: transparent;
  border: none;
  border-right: 1px solid var(--border3);
  cursor: pointer;
  transition: background 0.08s, color 0.08s;
  white-space: nowrap;
}
.tab:last-child { border-right: none; }
.tab:hover {
  color: var(--text);
  background: var(--hover);
}
.tabActive {
  background: var(--text) !important;
  color: var(--bg) !important;
  font-weight: 700;
}

/* KPI zone (center) -------------------------------------------------------- */
.kpiZone {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.kpiPlaceholder {
  font-size: 9px;
  color: var(--text3);
  padding: 0 4px;
}

/* Right zone --------------------------------------------------------------- */
.right {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 12px;
  border-left: 1px solid var(--border2);
  flex-shrink: 0;
  font-size: 11px;
  color: var(--text3);
}

.operator {
  font-size: 8.5px;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--text2);
}

.clock {
  font-size: 8.5px;
  letter-spacing: 0.04em;
  color: var(--text3);
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}

.langWrap {
  display: flex;
  height: 20px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  overflow: hidden;
}

.langBtn {
  font-size: 8px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 0 6px;
  height: 100%;
  background: transparent;
  border: none;
  border-right: 1px solid var(--border2);
  color: var(--text3);
  cursor: pointer;
  transition: all 0.1s;
  display: flex;
  align-items: center;
}
.langBtn:last-child { border-right: none; }

.langActive {
  background: var(--text);
  color: var(--bg);
  font-weight: 700;
}

.themeBtn {
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: transparent;
  color: var(--text2);
  cursor: pointer;
  font-size: 12px;
  transition: all 0.1s;
}
.themeBtn:hover {
  border-color: var(--border);
  color: var(--text);
  background: var(--bg2);
}
'@


# =============================================================================
# 07  src\shared\layout\ModuleTabs\index.tsx  (no-op - tabs moved to TopBar)
# =============================================================================
Write-File 'src\shared\layout\ModuleTabs\index.tsx' @'
// src/shared/layout/ModuleTabs/index.tsx - v0.4.3a
// Tabs are now rendered inside TopBar.
// Kept as a no-op so app.tsx does not need to be modified in this patch.
export function ModuleTabs() {
  return null
}
'@


# =============================================================================
# 08  src\shared\layout\ModuleTabs\styles.module.css
# =============================================================================
Write-File 'src\shared\layout\ModuleTabs\styles.module.css' @'
/* src/shared/layout/ModuleTabs/styles.module.css - v0.4.3a - no-op */
'@


# =============================================================================
# 09  src\modules\submissions\Submissions.module.css
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* src/modules/submissions/Submissions.module.css - v0.4.3a */

.submissions {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--bg);
  overflow: hidden;
}

/* Main area: table left + inspector right */
.mainArea {
  display: flex;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.tableContainer {
  flex: 1 1 100%;
  overflow: auto;
  background: var(--bg);
  position: relative;
  transition: flex-basis 0.15s;
}

/* Shrink table to 50% when inspector is open */
.tableContainerWithDetail {
  flex: 0 0 50%;
  border-right: 1px solid var(--border2);
}

/* Active state for toolbar toggle buttons */
.activeToggle {
  color: var(--s-ok) !important;
  border-color: var(--s-ok) !important;
}
'@


# =============================================================================
# 10  src\modules\submissions\index.tsx
# =============================================================================
Write-File 'src\modules\submissions\index.tsx' @'
// src/modules/submissions/index.tsx - v0.4.3a
// Old inline detailPanel block removed. Inspector component wired in its place.
import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { Inspector } from './components/Inspector'
import { mockSubmissions } from './mockData'
import styles from './Submissions.module.css'

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail,   setShowDetail]   = useState(false)
  const [detailId,     setDetailId]     = useState<string | null>(null)
  const [studentsOnly, setStudentsOnly] = useState(false)

  // Open inspector - does not remount if already open
  const handleRowClick = (id: string) => {
    setDetailId(id)
    setShowDetail(true)
  }

  // Navigate to a linked record inside the inspector (ALTRES INSCRIPCIONS).
  // Updates detailId in-place. Inspector component does NOT unmount.
  const handleSelectId = (id: string) => {
    setDetailId(id)
  }

  const closeDetail = () => {
    setShowDetail(false)
    setDetailId(null)
  }

  const selectedSubmission = detailId
    ? (mockSubmissions.find((s) => s.id === detailId) ?? null)
    : null

  return (
    <div className={styles.submissions}>

      {/* Toolbar */}
      <div className="toolbar">
        <div className="toolbar-group">
          <Button variant="icon" title="Refresh">
            <i className="bi bi-arrow-repeat"></i>
          </Button>
          <Button variant="icon" title="Upload CSV">
            <i className="bi bi-upload"></i>
          </Button>
          <Button variant="icon" title="Save session">
            <i className="bi bi-save"></i>
          </Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Delete CSV">
            <i className="bi bi-file-earmark-x"></i>
          </Button>
          <Button
            variant="icon"
            disabled={selectedRows.length === 0}
            title="Duplicate selected"
          >
            <i className="bi bi-files"></i>
          </Button>
          <Button
            variant="icon"
            disabled={selectedRows.length === 0}
            title="Delete selected"
          >
            <i className="bi bi-trash"></i>
          </Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Export">
            <i className="bi bi-download"></i>
          </Button>
          <Button variant="icon" title="Filter">
            <i className="bi bi-funnel"></i>
          </Button>
          <Button
            variant="icon"
            title={studentsOnly ? 'Show all' : 'Students only'}
            onClick={() => setStudentsOnly(!studentsOnly)}
            className={studentsOnly ? styles.activeToggle : ''}
          >
            <i className="bi bi-person-square"></i>
          </Button>
        </div>
      </div>

      {/* Main area */}
      <div className={styles.mainArea}>
        <div
          className={`${styles.tableContainer} ${showDetail ? styles.tableContainerWithDetail : ''}`}
        >
          <SubmissionsTable
            selectedRows={selectedRows}
            onSelectionChange={setSelectedRows}
            onRowClick={handleRowClick}
          />
        </div>

        {/* Inspector replaces old detailPanel */}
        {showDetail && selectedSubmission && (
          <Inspector
            submission={selectedSubmission}
            onClose={closeDetail}
            onSelectId={handleSelectId}
          />
        )}
      </div>

    </div>
  )
}
'@


# =============================================================================
# 11  Inspector\index.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\index.tsx' @'
// src/modules/submissions/components/Inspector/index.tsx - v0.4.3a
// Wireframe-compliant layout: 3-col upper row + 2-zone lower row.
import { type MockSubmission } from '../../mockData'
import { InfoColumn }    from './InfoColumn'
import { ContactColumn } from './ContactColumn'
import { StatusColumn }  from './StatusColumn'
import { LinksRow }      from './LinksRow'
import { ActionStack }   from './ActionStack'
import styles from './styles.module.css'

interface InspectorProps {
  submission: MockSubmission
  onClose:    () => void
  onSelectId: (id: string) => void
}

export function Inspector({ submission, onClose, onSelectId }: InspectorProps) {
  return (
    <div className={styles.panel}>

      <div className={styles.panelHead}>
        <span className={styles.codeTag}>{submission.code}</span>
        <button className={styles.closeBtn} onClick={onClose} aria-label="Close">
          <i className="bi bi-x-lg" aria-hidden="true"></i>
        </button>
      </div>

      <div className={styles.panelBody}>

        {/* Row 1: exactly 3 equal columns */}
        <div className={styles.upperGrid}>
          <InfoColumn    submission={submission} />
          <ContactColumn submission={submission} onSelectId={onSelectId} />
          <StatusColumn  submission={submission} />
        </div>

        {/* Row 2: links+notes on left, action stack on right */}
        <div className={styles.lowerRow}>
          <LinksRow    submission={submission} />
          <ActionStack submission={submission} onClose={onClose} />
        </div>

      </div>
    </div>
  )
}
'@


# =============================================================================
# 12  Inspector\styles.module.css
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* src/modules/submissions/components/Inspector/styles.module.css - v0.4.3a */

/* Outer panel -------------------------------------------------------------- */
.panel {
  flex: 0 0 50%;
  max-width: 50%;
  background: var(--bg);
  border-left: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.panelHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 10px;
  min-height: 30px;
  border-bottom: 1px solid var(--border2);
  background: var(--bg2);
  flex-shrink: 0;
}

.codeTag {
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text3);
  font-family: monospace;
}

.closeBtn {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: none;
  color: var(--text2);
  cursor: pointer;
  font-size: 11px;
  transition: all 0.1s;
}
.closeBtn:hover {
  border-color: var(--border);
  color: var(--text);
  background: var(--bg3);
}

.panelBody {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

/* Row 1: 3-column upper grid ----------------------------------------------- */
/* Intentionally separate from lowerRow - two independent layout containers.  */
.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 180px;
}

/* Row 2: lower flex row ---------------------------------------------------- */
.lowerRow {
  display: flex;
  flex: 1;
  min-height: 0;
}

/* Shared section label ----------------------------------------------------- */
.colLabel {
  font-size: 7px;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: var(--text3);
  margin-bottom: 6px;
  flex-shrink: 0;
  display: block;
}

/* InfoColumn --------------------------------------------------------------- */
.infoCol {
  padding: 10px 10px 10px 13px;
  border-right: 1px solid var(--border2);
  position: relative;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}
/* Blue left accent bar */
.infoCol::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 3px;
  background: var(--color-info);
}

.fieldGroup {
  display: flex;
  flex-direction: column;
  gap: 2px;
  margin-bottom: 8px;
}

.fieldKey {
  font-size: 7px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--text3);
}

.fieldVal {
  font-size: 11px;
  color: var(--text);
  line-height: 1.4;
  word-break: break-word;
}

.catSection { margin-top: 2px; }

.catRow {
  display: flex;
  align-items: center;
  padding: 3px 6px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  margin-bottom: 3px;
}

.catVal {
  font-size: 10px;
  color: var(--text);
  flex: 1;
}

/* ContactColumn ------------------------------------------------------------ */
.contactCol {
  padding: 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.contactBlock {
  display: flex;
  flex-direction: column;
  margin-bottom: 8px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--border3);
}
.contactBlock:last-of-type {
  border-bottom: none;
  margin-bottom: 0;
}

.contactField {
  display: flex;
  align-items: center;
  gap: 5px;
  min-height: 22px;
  border-bottom: 1px solid var(--border3);
}
.contactField:last-child { border-bottom: none; }

.cfLabel {
  font-size: 7px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text3);
  width: 58px;
  flex-shrink: 0;
}

.cfVal {
  flex: 1;
  font-size: 10px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Links in contact fields: inherit color, no browser blue */
.cfVal a {
  color: inherit;
  text-decoration: none;
}
.cfVal a:hover { text-decoration: underline; }

.editBtn {
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: none;
  color: var(--text3);
  cursor: pointer;
  font-size: 10px;
  flex-shrink: 0;
  transition: color 0.1s;
}
.editBtn:hover { color: var(--text); }

/* ALTRES INSCRIPCIONS mini grid */
.altresSection { margin-top: 6px; }

.altresLabel {
  font-size: 7px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--text3);
  margin-bottom: 5px;
  display: block;
}

.altresGrid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 3px;
}

.codeBadge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 2px;
  font-size: 8px;
  letter-spacing: 0.03em;
  padding: 3px 4px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  color: var(--text2);
  cursor: pointer;
  transition: all 0.1s;
  font-family: monospace;
}
.codeBadge:hover {
  border-color: var(--border);
  background: var(--bg3);
  color: var(--text);
}

/* StatusColumn ------------------------------------------------------------- */
.statusCol {
  padding: 10px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.statusRow {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.statusRowLabel {
  font-size: 7px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--text3);
}

.statusBadgeWrap {
  position: relative;
  display: inline-block;
}

.statusClickBadge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 3px 7px;
  border: 1px solid;
  border-radius: var(--radius);
  cursor: pointer;
  background: none;
  transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }

.statusClickBadge.ok {
  color: var(--s-ok);
  border-color: var(--s-ok);
  background: var(--s-ok-bg);
}
.statusClickBadge.warn {
  color: var(--s-warn);
  border-color: var(--s-warn);
  background: var(--s-warn-bg);
}
.statusClickBadge.issue {
  color: var(--s-des);
  border-color: var(--s-des);
  background: var(--s-des-bg);
}

.statusDropdown {
  position: absolute;
  top: calc(100% + 2px);
  left: 0;
  z-index: 50;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: 0 2px 8px rgba(0,0,0,.12);
  min-width: 110px;
  overflow: hidden;
}

.statusDropdownItem {
  display: block;
  width: 100%;
  padding: 6px 10px;
  text-align: left;
  font-size: 9px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  background: none;
  border: none;
  border-bottom: 1px solid var(--border3);
  color: var(--text2);
  cursor: pointer;
  transition: background 0.08s;
}
.statusDropdownItem:last-child { border-bottom: none; }
.statusDropdownItem:hover { background: var(--hover); color: var(--text); }

.premiadoRow {
  display: flex;
  align-items: center;
  gap: 6px;
}

.toggleBtn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 3px 8px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: none;
  color: var(--text3);
  cursor: pointer;
  transition: all 0.1s;
}
.toggleBtn.toggled {
  border-color: var(--s-ok);
  color: var(--s-ok);
  background: var(--s-ok-bg);
}

.premioSelect {
  width: 100%;
  padding: 4px 6px;
  font-size: 9px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg);
  color: var(--text2);
  cursor: pointer;
  appearance: none;
  outline: none;
}
.premioSelect:focus {
  border-color: var(--border);
  color: var(--text);
}

/* LinksRow (lower-left) ---------------------------------------------------- */
.linksRow {
  flex: 1;
  padding: 10px;
  border-right: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  gap: 8px;
  overflow-y: auto;
}

.linksSection {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.linkItem {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 7px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
}

.linkIcon {
  font-size: 12px;
  color: var(--text3);
  flex-shrink: 0;
}

/* Link anchors: inherit color, no browser blue */
.linkAnchor {
  flex: 1;
  font-size: 9.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  text-decoration: none;
}
.linkAnchor:hover { text-decoration: underline; }

.notesSection {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.notesLabel {
  font-size: 7px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--text3);
}

.notesTextarea {
  flex: 1;
  min-height: 60px;
  padding: 6px 8px;
  font-size: 10px;
  line-height: 1.5;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  color: var(--text2);
  resize: none;
  outline: none;
  font-family: inherit;
  transition: border-color 0.1s;
}
.notesTextarea:focus {
  border-color: var(--border);
  color: var(--text);
  background: var(--bg);
}

/* ActionStack (lower-right) ------------------------------------------------ */
.actionStack {
  flex: 0 0 128px;
  padding: 10px 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: var(--bg2);
}

.actionBtn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  width: 100%;
  height: 26px;
  font-size: 8px;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  border: 1px solid;
  border-radius: var(--radius);
  cursor: pointer;
  transition: opacity 0.1s;
  white-space: nowrap;
}
.actionBtn:hover:not(:disabled) { opacity: 0.82; }
.actionBtn:disabled { opacity: 0.35; cursor: default; }

.actionDesa {
  background: var(--s-ok);
  color: #ffffff;
  border-color: var(--s-ok);
}

.actionDescartar {
  background: var(--s-warn);
  color: #ffffff;
  border-color: var(--s-warn);
}

.actionNeutral {
  background: transparent;
  color: var(--text2);
  border-color: var(--border2);
}
.actionNeutral:hover:not(:disabled) {
  background: var(--bg3);
  color: var(--text);
  border-color: var(--border);
}

.actionSpacer { flex: 1; }

.actionEliminar {
  background: var(--s-des);
  color: #ffffff;
  border-color: var(--s-des);
}
'@


# =============================================================================
# 13  Inspector\InfoColumn.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\InfoColumn.tsx' @'
// src/modules/submissions/components/Inspector/InfoColumn.tsx - v0.4.3a
// Col 1: blue left-border accent, CODI + TITOL readonly, CATEGORIA rows.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function InfoColumn({ submission }: Props) {
  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>Informacio general</span>

      <div className={styles.fieldGroup}>
        <div className={styles.fieldKey}>Codi</div>
        <div className={styles.fieldVal}>{submission.code}</div>
      </div>

      <div className={styles.fieldGroup}>
        <div className={styles.fieldKey}>Titol</div>
        <div className={styles.fieldVal}>{submission.title}</div>
      </div>

      <div className={`${styles.fieldGroup} ${styles.catSection}`}>
        <div className={styles.fieldKey}>Categoria</div>
        {submission.category.split(',').map((cat) => (
          <div key={cat.trim()} className={styles.catRow}>
            <span className={styles.catVal}>{cat.trim()}</span>
          </div>
        ))}
      </div>
    </div>
  )
}
'@


# =============================================================================
# 14  Inspector\ContactColumn.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\ContactColumn.tsx' @'
// src/modules/submissions/components/Inspector/ContactColumn.tsx - v0.4.3a
// Col 2: two contact blocks + ALTRES INSCRIPCIONS 3-col badge grid.
// Clicking a badge calls onSelectId - inspector updates in-place, no remount.
import { mockSubmissions, type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props {
  submission: MockSubmission
  onSelectId: (id: string) => void
}

function CField({ label, value }: { label: string; value: string }) {
  return (
    <div className={styles.contactField}>
      <span className={styles.cfLabel}>{label}</span>
      <span className={styles.cfVal}>{value || '\u2014'}</span>
      <button className={styles.editBtn} aria-label="Edit">
        <i className="bi bi-pencil" aria-hidden="true"></i>
      </button>
    </div>
  )
}

export function ContactColumn({ submission, onSelectId }: Props) {
  return (
    <div className={styles.contactCol}>
      <span className={styles.colLabel}>Contacte</span>

      {/* Primary contact block */}
      <div className={styles.contactBlock}>
        <CField label="Nom"      value={submission.firstName} />
        <CField label="Email"    value={submission.email} />
        <CField label="Tel."     value={submission.phone ?? ''} />
        <CField label="Soci FAD" value={submission.fadMember ? 'Si' : 'No'} />
      </div>

      {/* Secondary contact block */}
      <div className={styles.contactBlock}>
        <CField label="Cognom" value={submission.lastName} />
        <CField label="Estudi" value={submission.studio} />
        <CField label="Web"    value={submission.website ?? ''} />
        <CField label="Altres" value={submission.associationMember ? 'Si' : 'No'} />
      </div>

      {/* ALTRES INSCRIPCIONS: 3-col badge grid.
          Clicking navigates to the linked record inside the inspector.
          Does NOT unmount the inspector - only updates selectedId. */}
      {submission.otherSubmissions.length > 0 && (
        <div className={styles.altresSection}>
          <span className={styles.altresLabel}>Altres inscripcions</span>
          <div className={styles.altresGrid}>
            {submission.otherSubmissions.map((code) => {
              const linked = mockSubmissions.find((s) => s.code === code)
              return linked ? (
                <button
                  key={code}
                  className={styles.codeBadge}
                  onClick={() => onSelectId(linked.id)}
                  title={code}
                >
                  <i className="bi bi-arrow-right-short" aria-hidden="true"></i>
                  {code}
                </button>
              ) : null
            })}
          </div>
        </div>
      )}
    </div>
  )
}
'@


# =============================================================================
# 15  Inspector\StatusColumn.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\StatusColumn.tsx' @'
// src/modules/submissions/components/Inspector/StatusColumn.tsx - v0.4.3a
// Col 3: PAGAMENT/MATERIAL click-to-dropdown, PREMIADO toggle, PREMIO selector.
// Workflow-only local state. No write-back to RawSubmission (deferred to v0.4.3b).
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

type PaymentVal  = 'ok' | 'pending' | 'issue'
type MaterialVal = 'ok' | 'warning' | 'issue'

const PAYMENT_OPTS: { value: PaymentVal;  label: string }[] = [
  { value: 'ok',      label: 'Rebut'   },
  { value: 'pending', label: 'Pendent' },
  { value: 'issue',   label: 'Error'   },
]
const MATERIAL_OPTS: { value: MaterialVal; label: string }[] = [
  { value: 'ok',      label: 'Rebut'   },
  { value: 'warning', label: 'Pendent' },
  { value: 'issue',   label: 'Falta'   },
]
const PREMIO_OPTS = [
  '',
  'inBook',
  'Bronce',
  'Plata',
  'Oro',
  'Grand Laus',
  'Grand Laus Estudiants',
  'Laus de Honor',
  'Laus Aporta',
]

function badgeClass(val: PaymentVal | MaterialVal): string {
  if (val === 'ok')      return styles.ok
  if (val === 'pending') return styles.warn
  if (val === 'warning') return styles.warn
  return styles.issue
}

const payLabel  = (v: PaymentVal):  string => v === 'ok' ? 'Rebut'  : v === 'pending' ? 'Pendent' : 'Error'
const matLabel  = (v: MaterialVal): string => v === 'ok' ? 'Rebut'  : v === 'warning' ? 'Pendent' : 'Falta'

export function StatusColumn({ submission }: Props) {
  const [payment,  setPayment]  = useState<PaymentVal>(submission.payment)
  const [material, setMaterial] = useState<MaterialVal>(submission.material)
  const [payOpen,  setPayOpen]  = useState(false)
  const [matOpen,  setMatOpen]  = useState(false)
  const [premiado, setPremiado] = useState(false)
  const [premio,   setPremio]   = useState('')

  return (
    <div className={styles.statusCol}>
      <span className={styles.colLabel}>Estat</span>

      {/* PAGAMENT */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Pagament</span>
        <div className={styles.statusBadgeWrap}>
          <button
            className={`${styles.statusClickBadge} ${badgeClass(payment)}`}
            onClick={() => { setPayOpen(!payOpen); setMatOpen(false) }}
          >
            {payLabel(payment)}
            <i className="bi bi-chevron-down" style={{ fontSize: '7px' }} aria-hidden="true"></i>
          </button>
          {payOpen && (
            <div className={styles.statusDropdown}>
              {PAYMENT_OPTS.map((o) => (
                <button
                  key={o.value}
                  className={styles.statusDropdownItem}
                  onClick={() => { setPayment(o.value); setPayOpen(false) }}
                >
                  {o.label}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* MATERIAL */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Material</span>
        <div className={styles.statusBadgeWrap}>
          <button
            className={`${styles.statusClickBadge} ${badgeClass(material)}`}
            onClick={() => { setMatOpen(!matOpen); setPayOpen(false) }}
          >
            {matLabel(material)}
            <i className="bi bi-chevron-down" style={{ fontSize: '7px' }} aria-hidden="true"></i>
          </button>
          {matOpen && (
            <div className={styles.statusDropdown}>
              {MATERIAL_OPTS.map((o) => (
                <button
                  key={o.value}
                  className={styles.statusDropdownItem}
                  onClick={() => { setMaterial(o.value); setMatOpen(false) }}
                >
                  {o.label}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* PREMIADO - workflow-only flag */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Premiat</span>
        <div className={styles.premiadoRow}>
          <button
            className={`${styles.toggleBtn} ${premiado ? styles.toggled : ''}`}
            onClick={() => setPremiado(!premiado)}
          >
            {premiado ? 'Si' : 'No'}
          </button>
        </div>
      </div>

      {/* PREMIO - visible only when premiado is true */}
      {premiado && (
        <div className={styles.statusRow}>
          <span className={styles.statusRowLabel}>Premio</span>
          <select
            className={styles.premioSelect}
            value={premio}
            onChange={(e) => setPremio(e.target.value)}
          >
            {PREMIO_OPTS.map((o) => (
              <option key={o} value={o}>{o || '-- selecciona --'}</option>
            ))}
          </select>
        </div>
      )}
    </div>
  )
}
'@


# =============================================================================
# 16  Inspector\LinksRow.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\LinksRow.tsx' @'
// src/modules/submissions/components/Inspector/LinksRow.tsx - v0.4.3a
// Lower-left: Dropbox + Projecte links with pencil edit + Notes internes textarea.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  return (
    <div className={styles.linksRow}>

      <div className={styles.linksSection}>
        <span className={styles.colLabel}>Enllacos</span>

        {submission.dropboxUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-dropbox ${styles.linkIcon}`} aria-hidden="true"></i>
            <a
              href={submission.dropboxUrl}
              target="_blank"
              rel="noopener noreferrer"
              className={styles.linkAnchor}
            >
              Dropbox
            </a>
            <button className={styles.editBtn} aria-label="Edit Dropbox link">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}

        {submission.projectUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-box-arrow-up-right ${styles.linkIcon}`} aria-hidden="true"></i>
            <a
              href={submission.projectUrl}
              target="_blank"
              rel="noopener noreferrer"
              className={styles.linkAnchor}
            >
              Projecte
            </a>
            <button className={styles.editBtn} aria-label="Edit project link">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}
      </div>

      <div className={styles.notesSection}>
        <span className={styles.notesLabel}>Notes internes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Notes internes..."
        />
      </div>

    </div>
  )
}
'@


# =============================================================================
# 17  Inspector\ActionStack.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\ActionStack.tsx' @'
// src/modules/submissions/components/Inspector/ActionStack.tsx - v0.4.3a
// Lower-right: DESA / DESCARTAR / CONTACTE / DUPLICAR / (spacer) / ELIMINAR.
// Save, duplicate, delete are stubs until data layer is wired in v0.4.3b.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props {
  submission: MockSubmission
  onClose:    () => void
}

export function ActionStack({ submission, onClose }: Props) {
  const handleDesa = () => {
    // TODO v0.4.3b: persist workflow fields to WorkspaceSubmission layer.
    // Premio/premiado must never overwrite RawSubmission canonical data.
    alert('Desa - pending implementation (v0.4.3b)')
  }

  const handleDescartar = () => {
    onClose()
  }

  const handleContacte = () => {
    window.open(`mailto:${submission.email}`, '_blank')
  }

  const handleDuplicar = () => {
    // TODO v0.4.3b
    alert('Duplicar - pending implementation (v0.4.3b)')
  }

  const handleEliminar = () => {
    if (window.confirm(`Eliminar inscripcio ${submission.code}?`)) {
      // TODO v0.4.3b: remove from store
      onClose()
    }
  }

  return (
    <div className={styles.actionStack}>

      <button className={`${styles.actionBtn} ${styles.actionDesa}`} onClick={handleDesa}>
        <i className="bi bi-floppy" aria-hidden="true"></i>
        Desa
      </button>

      <button className={`${styles.actionBtn} ${styles.actionDescartar}`} onClick={handleDescartar}>
        <i className="bi bi-x-circle" aria-hidden="true"></i>
        Descartar
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`} onClick={handleContacte}>
        <i className="bi bi-envelope" aria-hidden="true"></i>
        Contacte
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`} onClick={handleDuplicar}>
        <i className="bi bi-files" aria-hidden="true"></i>
        Duplicar
      </button>

      {/* Spacer pushes ELIMINAR to the bottom */}
      <div className={styles.actionSpacer}></div>

      <button className={`${styles.actionBtn} ${styles.actionEliminar}`} onClick={handleEliminar}>
        <i className="bi bi-trash" aria-hidden="true"></i>
        Eliminar
      </button>

    </div>
  )
}
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3a complete - 17 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "Deferred to v0.4.3b:" -ForegroundColor DarkGray
Write-Host "  TopBar KPI zone wiring" -ForegroundColor DarkGray
Write-Host "  parser.ts UTF-8 header normalization" -ForegroundColor DarkGray
Write-Host "  submission.ts canonical 23-column type" -ForegroundColor DarkGray
Write-Host "  Inspector save/duplicate/delete logic" -ForegroundColor DarkGray
Write-Host ""
