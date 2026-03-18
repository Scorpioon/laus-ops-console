#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3c-rev1 - Language + C5 Corrections
#
# Apply AFTER v0.4.3c.
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3c-rev1-language-c5-corrections.ps1
#
# Files changed (3):
#   src\shared\layout\TopBar\index.tsx           English tabs (language consistency)
#   src\modules\submissions\components\Inspector\styles.module.css
#                                                C5 fixed narrow rail (not flex:1)
#   src\modules\submissions\Submissions.module.css
#                                                KPI strip minor tightening
# =============================================================================

Set-StrictMode -Off
$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path

if (!(Test-Path (Join-Path $root 'package.json'))) {
    Write-Host ""
    Write-Host "ERROR: package.json not found in: $root" -ForegroundColor Red
    Write-Host "Navigate to the project root first." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

function Write-File {
    param([string]$Rel, [string]$Content)
    $full = Join-Path $root $Rel
    $dir  = Split-Path $full -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($full, $Content, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  OK  $Rel" -ForegroundColor Green
}

Write-Host ""
Write-Host "LAUS OPS CONSOLE - patch v0.4.3c-rev1" -ForegroundColor Cyan
Write-Host "Language + C5 Corrections" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  src\shared\layout\TopBar\index.tsx
#     Tab labels in English - consistent with inspector and KPI language.
# =============================================================================
Write-File 'src\shared\layout\TopBar\index.tsx' @'
// TopBar/index.tsx - v0.4.3c-rev1
// English tabs - consistent with inspector and KPI language.
import { useState, useEffect } from 'react'
import { useUIStore } from '../../../core/store/uiStore'
import styles from './styles.module.css'

const TABS = [
  { id: 'submissions', label: 'SUBMISSIONS' },
  { id: 'jury',        label: 'JURY'        },
  { id: 'templates',   label: 'TEMPLATES'   },
  { id: 'insights',    label: 'INSIGHTS'    },
  { id: 'helpdesk',    label: 'HELP'        },
  { id: 'laurel',      label: 'AWARDED'     },
  { id: 'settings',    label: 'CONFIG'      },
]

function LiveClock() {
  const [ts, setTs] = useState(() => new Date())
  useEffect(() => {
    const id = setInterval(() => setTs(new Date()), 1000)
    return () => clearInterval(id)
  }, [])
  const p = (n: number) => String(n).padStart(2, '0')
  return (
    <span className={styles.clock}>
      {p(ts.getDate())}/{p(ts.getMonth() + 1)}/{ts.getFullYear()}
      &nbsp;|&nbsp;
      {p(ts.getHours())}:{p(ts.getMinutes())}:{p(ts.getSeconds())}
    </span>
  )
}

export function TopBar() {
  const { activeModule, setActiveModule, language, setLanguage, theme, toggleTheme } = useUIStore()

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  return (
    <header className={styles.topbar}>

      {/* Left: logo + tabs */}
      <div className={styles.left}>
        <div className={styles.logo}>
          <span className={styles.logoPrimary}>LAUS OPS</span>
          <span className={styles.logoSecondary}>console</span>
        </div>
        <nav className={styles.tabs} aria-label="Modules">
          {TABS.map(tab => (
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

      {/* Right: operator + clock + lang + theme */}
      <div className={styles.right}>
        <i className="bi bi-person-circle" aria-hidden="true"></i>
        <span className={styles.operator}>OPERATOR ADG</span>
        <LiveClock />
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
        <button className={styles.themeBtn} onClick={toggleTheme} aria-label="Toggle theme">
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
# 02  Inspector\styles.module.css
#     C5 (actionStack): fixed narrow rail - 108px, not flex:1.
#     C4 (linksRow): flex:1 - takes all remaining space, clearly dominates.
#     Proportions: C4 clearly wider, C5 is a narrow action rail.
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3c-rev1 */

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
  padding: 0 12px;
  min-height: 32px;
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
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: none;
  color: var(--text2);
  cursor: pointer;
  font-size: 12px;
  transition: all 0.1s;
}
.closeBtn:hover { border-color: var(--border); color: var(--text); background: var(--bg3); }

.panelBody {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

/* Row 1: 3 equal columns --------------------------------------------------- */
.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 190px;
}

/* Row 2: C4 dominates (flex:1), C5 is a fixed narrow rail (108px) ---------- */
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
  margin-bottom: 8px;
  flex-shrink: 0;
  display: block;
}

/* C1 — InfoColumn ---------------------------------------------------------- */
.infoCol {
  padding: 12px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.infoRow {
  display: flex;
  align-items: center;
  gap: 6px;
  min-height: 28px;
  padding: 2px 0;
  border-bottom: 1px solid var(--border3);
}
.infoRow:last-child { border-bottom: none; }

.infoKey {
  width: 64px;
  flex-shrink: 0;
  font-size: 7px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text3);
}

/* Form box: value + inline pencil */
.infoVal {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 4px;
  min-height: 26px;
  padding: 4px 7px;
  background: var(--bg2);
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  transition: border-color 0.1s;
}

.infoValText {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.3;
}

.inlineEdit {
  flex-shrink: 0;
  width: 14px;
  height: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: none;
  color: var(--text3);
  cursor: pointer;
  font-size: 9px;
  padding: 0;
  transition: color 0.1s;
}
.inlineEdit:hover { color: var(--text); }

.infoValStatic {
  flex: 1;
  font-size: 10.5px;
  color: var(--text2);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* C2 — ContactColumn ------------------------------------------------------- */
.contactCol {
  padding: 12px;
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
.contactBlock:last-of-type { border-bottom: none; margin-bottom: 0; }

.contactField {
  display: flex;
  align-items: center;
  gap: 5px;
  min-height: 24px;
  border-bottom: 1px solid var(--border3);
}
.contactField:last-child { border-bottom: none; }

.cfLabel {
  font-size: 7px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text3);
  width: 64px;
  flex-shrink: 0;
}

.cfVal {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Neutral links — never browser blue */
.cfVal a {
  color: var(--text2);
  text-decoration: none;
  border-bottom: 1px solid var(--border2);
}
.cfVal a:hover { color: var(--text); border-bottom-color: var(--text); }

.editBtn {
  width: 16px; height: 16px;
  display: flex; align-items: center; justify-content: center;
  border: none; background: none;
  color: var(--text3); cursor: pointer; font-size: 10px;
  flex-shrink: 0; transition: color 0.1s; padding: 0;
}
.editBtn:hover { color: var(--text); }

/* Other entries compact chip grid */
.altresSection { margin-top: 6px; }

.altresLabel {
  font-size: 7px; letter-spacing: 0.14em; text-transform: uppercase;
  color: var(--text3); margin-bottom: 4px; display: block;
}

.altresGrid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2px;
}

.codeBadge {
  display: inline-flex; align-items: center; justify-content: center;
  gap: 2px; font-size: 7.5px; padding: 2px 4px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text3); cursor: pointer;
  transition: all 0.08s; font-family: monospace; white-space: nowrap;
}
.codeBadge:hover { border-color: var(--border); background: var(--bg3); color: var(--text); }

/* C3 — StatusColumn -------------------------------------------------------- */
.statusCol {
  padding: 12px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 9px;
}

.statusRow { display: flex; flex-direction: column; gap: 3px; }

.statusRowLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3);
}

.statusSmallNote {
  font-size: 8.5px; color: var(--text3);
  margin-top: 1px; font-style: italic;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}

.statusDivider { border: none; border-top: 1px solid var(--border2); margin: 3px 0; }

.statusBadgeWrap { position: relative; display: inline-block; }

.statusClickBadge {
  display: inline-flex; align-items: center; gap: 4px;
  font-size: 8px; font-weight: 700; letter-spacing: 0.08em;
  text-transform: uppercase; padding: 3px 8px;
  border: 1px solid; border-radius: var(--radius);
  cursor: pointer; background: none; transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }

.statusClickBadge.ok    { background: #003400; color: #39F669; border-color: #39F669; }
.statusClickBadge.warn  { background: #2B0502; color: #FB9D04; border-color: #FB9D04; }
.statusClickBadge.issue { background: #43091F; color: #E9486E; border-color: #E9486E; }

[data-theme="dark"] .statusClickBadge.ok    { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .statusClickBadge.warn  { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .statusClickBadge.issue { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }

.statusDropdown {
  position: absolute; top: calc(100% + 2px); left: 0; z-index: 50;
  background: var(--bg); border: 1px solid var(--border);
  border-radius: var(--radius); box-shadow: 0 2px 10px rgba(0,0,0,.15);
  min-width: 110px; overflow: hidden;
}

.statusDropdownItem {
  display: block; width: 100%; padding: 6px 10px;
  text-align: left; font-size: 8px; font-weight: 700;
  letter-spacing: 0.1em; text-transform: uppercase;
  background: none; border: none; border-bottom: 1px solid var(--border3);
  color: var(--text2); cursor: pointer; transition: background 0.08s;
}
.statusDropdownItem:last-child { border-bottom: none; }
.statusDropdownItem:hover { background: var(--hover); color: var(--text); }

.toggleRow { display: flex; align-items: center; gap: 5px; }

.toggleBtn {
  display: inline-flex; align-items: center; justify-content: center;
  font-size: 8px; font-weight: 700; letter-spacing: 0.08em;
  text-transform: uppercase; padding: 3px 10px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: none; color: var(--text3); cursor: pointer;
  transition: all 0.1s; min-width: 36px;
}
.toggleBtn.toggled { background: #003400; color: #39F669; border-color: #39F669; }
[data-theme="dark"] .toggleBtn.toggled { background: var(--s-ok-bg); color: var(--s-ok); border-color: var(--s-ok); }

.premioSelect {
  width: 100%; padding: 4px 24px 4px 7px;
  font-size: 9px; border: 1px solid var(--border2);
  border-radius: var(--radius); background: var(--bg2); color: var(--text2);
  cursor: pointer; appearance: none; outline: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='4'%3E%3Cpath d='M0 0l4 4 4-4z' fill='%23999'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 6px center;
}
.premioSelect:focus { border-color: var(--border); color: var(--text); }

/* C4 — LinksRow (Row 2 wide block) ---------------------------------------- */
/* flex:1 — takes all space not claimed by C5 */
.linksRow {
  flex: 1;
  padding: 12px;
  border-right: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  gap: 8px;
  overflow-y: auto;
}

.linksSection { display: flex; flex-direction: column; gap: 3px; }

.linkItem {
  display: flex; align-items: center; gap: 7px;
  padding: 5px 8px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2);
}

.linkIcon { font-size: 12px; color: var(--text3); flex-shrink: 0; }

/* Neutral link anchors */
.linkAnchor {
  flex: 1; font-size: 10px; color: var(--text2);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  text-decoration: none; border-bottom: 1px solid var(--border2);
}
.linkAnchor:hover { color: var(--text); border-bottom-color: var(--text); }

.notesSection { display: flex; flex-direction: column; gap: 5px; flex: 1; }

.notesLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3);
}

.notesTextarea {
  flex: 1; min-height: 64px;
  padding: 7px 8px; font-size: 10px; line-height: 1.55;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text2);
  resize: none; outline: none; font-family: inherit;
  transition: border-color 0.1s;
}
.notesTextarea:focus { border-color: var(--border); color: var(--text); background: var(--bg); }

/* C5 — ActionStack (Row 2 narrow action rail) ------------------------------ */
/* Fixed width: narrow rail, C4 clearly dominates */
.actionStack {
  flex: 0 0 108px;
  width: 108px;
  padding: 10px 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: var(--bg2);
  flex-shrink: 0;
}

.actionBtn {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; width: 100%; height: 28px;
  font-size: 8px; font-weight: 700; letter-spacing: 0.09em;
  text-transform: uppercase; border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s; white-space: nowrap;
}
.actionBtn:hover:not(:disabled) { opacity: 0.82; }
.actionBtn:disabled { opacity: 0.35; cursor: default; }

.actionDesa      { background: #003400; color: #39F669; border-color: #39F669; }
.actionDescartar { background: #2B0502; color: #FB9D04; border-color: #FB9D04; }

.actionNeutral {
  background: transparent; color: var(--text2); border-color: var(--border2);
}
.actionNeutral:hover:not(:disabled) {
  background: var(--bg3); color: var(--text); border-color: var(--border);
}

.actionSpacer { flex: 1; }

.actionEliminar  { background: #43091F; color: #E9486E; border-color: #E9486E; }

[data-theme="dark"] .actionDesa      { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .actionDescartar { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .actionEliminar  { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }
'@


# =============================================================================
# 03  src\modules\submissions\Submissions.module.css
#     KPI strip: slightly more padding for readability without bulk.
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* Submissions.module.css - v0.4.3c-rev1 */

.submissions {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--bg);
  overflow: hidden;
}

/* KPI strip ---------------------------------------------------------------- */
.kpiStrip {
  display: flex;
  align-items: stretch;
  background: var(--bg2);
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  overflow-x: auto;
  scrollbar-width: none;
  min-height: 38px;
}
.kpiStrip::-webkit-scrollbar { display: none; }

.kpi {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 18px;
  border-right: 1px solid var(--border2);
  flex-shrink: 0;
}
.kpi:last-child { border-right: none; margin-left: auto; }

.kpiVal {
  font-size: 17px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1;
  color: var(--text);
}

.kpiLbl {
  font-size: 7px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text3);
  margin-top: 2px;
  white-space: nowrap;
}

.kpiWarn { color: var(--s-warn); }
.kpiOk   { color: var(--s-ok); }
.kpiDes  { color: var(--s-des); }

/* Main layout -------------------------------------------------------------- */
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
}

.tableContainerWithDetail {
  flex: 0 0 50%;
  border-right: 1px solid var(--border2);
}

.activeToggle {
  color: var(--s-ok) !important;
  border-color: var(--s-ok) !important;
}
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3c-rev1 complete - 3 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  TopBar           Tab labels now English (SUBMISSIONS, JURY, TEMPLATES, etc.)" -ForegroundColor DarkGray
Write-Host "  Inspector styles C5 fixed: flex:0 0 108px (narrow action rail)" -ForegroundColor DarkGray
Write-Host "                   C4 flex:1 (dominates, clearly wide operational block)" -ForegroundColor DarkGray
Write-Host "  Submissions.css  KPI strip: min-height 38px, padding 18px, labels nowrap" -ForegroundColor DarkGray
Write-Host ""
