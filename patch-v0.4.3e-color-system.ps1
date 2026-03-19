#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3e - Definitive Color System
#
# Apply AFTER v0.4.3c + v0.4.3c-rev1 + v0.4.3d.
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3e-color-system.ps1
#
# COLOR SYSTEM (sign-off to change):
#   ok/save/received  : #15803D / #15803D33 / #DCFCE7
#   warn/pending/disc : #B45309 / #B4530933 / #FFFBEB
#   issue/error/del   : #C4294A / #C4294A33 / #FFF0F6
#   refresh/cyan      : #0885A8 / #0885A833 / #E0F9FF
#   award/purple      : #7C3AED / #7C3AED33 / #F5F3FF
#   neutral           : #374151 / #37415133 / #F9FAFB
#
# Files changed (6):
#   src\shared\ui\StatusBadge\styles.module.css
#   src\modules\submissions\components\Inspector\styles.module.css
#   src\modules\submissions\Submissions.module.css
#   src\modules\submissions\index.tsx
#   src\modules\submissions\components\Table\styles.module.css
#   src\modules\submissions\components\Table\index.tsx   (fix YN mojibake)
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
Write-Host "LAUS OPS CONSOLE - patch v0.4.3e" -ForegroundColor Cyan
Write-Host "Definitive Color System" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  StatusBadge\styles.module.css - ADG pastel chip system
# =============================================================================
Write-File 'src\shared\ui\StatusBadge\styles.module.css' @'
/* StatusBadge/styles.module.css - v0.4.3e
   ADG pastel chip system (same rule as licitaciones active-filter chips):
     text = accent / border = accent+#33 / background = paired pastel */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 2px 6px;
  font-size: 8px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  border-radius: var(--radius);
  border: 1px solid;
  line-height: 1.35;
  white-space: nowrap;
}

.ok      { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
.warning { background: #FFFBEB; color: #B45309; border-color: #B4530933; }
.issue   { background: #FFF0F6; color: #C4294A; border-color: #C4294A33; }
.info    { background: #E0F9FF; color: #0885A8; border-color: #0885A833; }
.neutral { background: #F9FAFB; color: #374151; border-color: #37415133; }

[data-theme="dark"] .ok      { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .warning { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .issue   { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }
[data-theme="dark"] .info    { background: var(--s-adj-bg);  color: var(--s-adj);  border-color: var(--s-adj); }
[data-theme="dark"] .neutral { background: var(--bg2); color: var(--text3); border-color: var(--border2); }
'@


# =============================================================================
# 02  Inspector\styles.module.css - full replacement, pastel color system
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3e - ADG pastel color system */

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

.panelTitle {
  font-size: 8.5px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text2);
}

.closeBtn {
  width: 22px; height: 22px;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: none; color: var(--text2); cursor: pointer;
  font-size: 12px; transition: all 0.1s;
}
.closeBtn:hover { border-color: var(--border); color: var(--text); background: var(--bg3); }

.panelBody {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 190px;
}

.lowerRow {
  display: flex;
  flex: 0 0 auto;
  min-height: 0;
  max-height: 130px;
  overflow: hidden;
}

.colLabel {
  font-size: 7px;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: var(--text3);
  margin-bottom: 6px;
  flex-shrink: 0;
  display: block;
}

/* C1 - InfoColumn */
.infoCol {
  padding: 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.infoRow {
  display: flex; align-items: center; gap: 6px;
  min-height: 26px; padding: 2px 0;
  border-bottom: 1px solid var(--border3);
}
.infoRow:last-child { border-bottom: none; }

.infoKey {
  width: 58px; flex-shrink: 0;
  font-size: 7px; letter-spacing: 0.12em;
  text-transform: uppercase; color: var(--text3);
}

.infoVal {
  flex: 1; display: flex; align-items: center; gap: 4px;
  min-height: 24px; padding: 3px 7px;
  background: var(--bg2); border: 1px solid var(--border2);
  border-radius: var(--radius);
}

.infoValText {
  flex: 1; font-size: 10.5px; color: var(--text);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}

.inlineEdit {
  flex-shrink: 0; width: 14px; height: 14px;
  display: flex; align-items: center; justify-content: center;
  border: none; background: none; color: var(--text3);
  cursor: pointer; font-size: 9px; padding: 0; transition: color 0.1s;
}
.inlineEdit:hover { color: var(--text); }

.infoValStatic {
  flex: 1; font-size: 10.5px; color: var(--text2);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}

/* C2 - ContactColumn */
.contactCol {
  padding: 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.contactBlock {
  display: flex; flex-direction: column;
  margin-bottom: 7px; padding-bottom: 7px;
  border-bottom: 1px solid var(--border3);
}
.contactBlock:last-of-type { border-bottom: none; margin-bottom: 0; }

.contactField {
  display: flex; align-items: center; gap: 5px;
  min-height: 22px; border-bottom: 1px solid var(--border3);
}
.contactField:last-child { border-bottom: none; }

.cfLabel {
  font-size: 7px; letter-spacing: 0.1em; text-transform: uppercase;
  color: var(--text3); width: 60px; flex-shrink: 0;
}

.cfVal {
  flex: 1; font-size: 10.5px; color: var(--text);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.cfVal a { color: var(--text2); text-decoration: none; border-bottom: 1px solid var(--border2); }
.cfVal a:hover { color: var(--text); border-bottom-color: var(--text); }

.editBtn {
  width: 16px; height: 16px;
  display: flex; align-items: center; justify-content: center;
  border: none; background: none; color: var(--text3);
  cursor: pointer; font-size: 10px; flex-shrink: 0; padding: 0; transition: color 0.1s;
}
.editBtn:hover { color: var(--text); }

.altresSection { margin-top: 5px; }
.altresLabel {
  font-size: 7px; letter-spacing: 0.14em; text-transform: uppercase;
  color: var(--text3); margin-bottom: 4px; display: block;
}
.altresGrid { display: grid; grid-template-columns: repeat(3,1fr); gap: 2px; }
.codeBadge {
  display: inline-flex; align-items: center; justify-content: center;
  gap: 2px; font-size: 7.5px; padding: 2px 4px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text3);
  cursor: pointer; transition: all 0.08s; font-family: monospace;
}
.codeBadge:hover { border-color: var(--border); background: var(--bg3); color: var(--text); }

/* C3 - StatusColumn */
.statusCol {
  padding: 10px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.statusRow { display: flex; flex-direction: column; gap: 3px; }
.statusRowLabel { font-size: 7px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--text3); }
.statusSmallNote { font-size: 8.5px; color: var(--text3); font-style: italic; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.statusDivider { border: none; border-top: 1px solid var(--border2); margin: 2px 0; }
.statusBadgeWrap { position: relative; display: inline-block; }

/* Status click-badges: ADG pastel */
.statusClickBadge {
  display: inline-flex; align-items: center; gap: 4px;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em;
  text-transform: uppercase; padding: 3px 8px;
  border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }
.statusClickBadge.ok    { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
.statusClickBadge.warn  { background: #FFFBEB; color: #B45309; border-color: #B4530933; }
.statusClickBadge.issue { background: #FFF0F6; color: #C4294A; border-color: #C4294A33; }
[data-theme="dark"] .statusClickBadge.ok    { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .statusClickBadge.warn  { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .statusClickBadge.issue { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }

.statusDropdown {
  position: absolute; top: calc(100% + 2px); left: 0; z-index: 50;
  background: var(--bg); border: 1px solid var(--border);
  border-radius: var(--radius); box-shadow: 0 2px 10px rgba(0,0,0,.1);
  min-width: 110px; overflow: hidden;
}
.statusDropdownItem {
  display: block; width: 100%; padding: 6px 10px;
  text-align: left; font-size: 8px; font-weight: 600;
  letter-spacing: 0.07em; text-transform: uppercase;
  background: none; border: none; border-bottom: 1px solid var(--border3);
  color: var(--text2); cursor: pointer; transition: background 0.08s;
}
.statusDropdownItem:last-child { border-bottom: none; }
.statusDropdownItem:hover { background: var(--hover); color: var(--text); }

.toggleRow { display: flex; align-items: center; gap: 5px; }

/* Toggle: neutral at rest, green pastel when active */
.toggleBtn {
  display: inline-flex; align-items: center; justify-content: center;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em; text-transform: uppercase;
  padding: 3px 10px; border: 1px solid var(--border2); border-radius: var(--radius);
  background: #F9FAFB; color: #374151; cursor: pointer; transition: all 0.1s; min-width: 36px;
}
.toggleBtn.toggled { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
[data-theme="dark"] .toggleBtn { background: var(--bg2); color: var(--text3); border-color: var(--border2); }
[data-theme="dark"] .toggleBtn.toggled { background: var(--s-ok-bg); color: var(--s-ok); border-color: var(--s-ok); }

.premioSelect {
  width: 100%; padding: 4px 24px 4px 7px; font-size: 9px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text2); cursor: pointer;
  appearance: none; outline: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='4'%3E%3Cpath d='M0 0l4 4 4-4z' fill='%23999'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 6px center;
}
.premioSelect:focus { border-color: var(--border); color: var(--text); }

/* C4 - LinksRow */
.linksRow {
  flex: 1; display: flex; flex-direction: column;
  border-right: 1px solid var(--border2); overflow: hidden;
}

.linksCols { display: flex; flex: 0 0 auto; border-bottom: 1px solid var(--border2); }

.linkSubCol {
  flex: 1; display: flex; flex-direction: column;
  gap: 2px; padding: 6px 8px; min-width: 0;
}
.linkSubColDiv { flex: 0 0 1px; background: var(--border2); align-self: stretch; }
.subColLabel { font-size: 7px; letter-spacing: 0.16em; text-transform: uppercase; color: var(--text3); }
.linkSubVal {
  display: flex; align-items: center; gap: 5px; padding: 3px 6px;
  background: var(--bg2); border: 1px solid var(--border2);
  border-radius: var(--radius); min-height: 24px; min-width: 0;
}
.linkAnchor {
  flex: 1; font-size: 9.5px; color: var(--text2);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  text-decoration: none; border-bottom: 1px solid var(--border2);
}
.linkAnchor:hover { color: var(--text); border-bottom-color: var(--text); }
.linkEmpty { font-size: 9.5px; color: var(--text3); flex: 1; }

.notesCompact {
  flex: 1; display: flex; flex-direction: column;
  padding: 5px 8px; gap: 3px; min-height: 0;
}
.notesLabel { font-size: 7px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--text3); flex-shrink: 0; }
.notesTextarea {
  flex: 1; min-height: 28px; max-height: 50px; padding: 4px 6px;
  font-size: 9.5px; line-height: 1.45; border: 1px solid var(--border2);
  border-radius: var(--radius); background: var(--bg2); color: var(--text2);
  resize: none; outline: none; font-family: inherit; transition: border-color 0.1s;
}
.notesTextarea:focus { border-color: var(--border); color: var(--text); background: var(--bg); }

/* C5 - ActionStack - fixed narrow rail */
.actionStack {
  flex: 0 0 108px; width: 108px; padding: 6px 7px;
  display: flex; flex-direction: column; gap: 4px;
  background: var(--bg2); flex-shrink: 0; overflow: hidden;
}

.actionBtn {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; width: 100%; height: 26px;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em; text-transform: uppercase;
  border: 1px solid; border-radius: var(--radius); cursor: pointer;
  transition: opacity 0.1s; white-space: nowrap; flex-shrink: 0;
}
.actionBtn:hover:not(:disabled) { opacity: 0.82; }
.actionBtn:disabled { opacity: 0.35; cursor: default; }

/* ADG pastel action buttons */
.actionDesa      { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
.actionDescartar { background: #FFFBEB; color: #B45309; border-color: #B4530933; }
.actionNeutral   { background: #F9FAFB; color: #374151; border-color: #37415133; }
.actionNeutral:hover:not(:disabled) { background: var(--bg3); color: var(--text); border-color: var(--border); }
.actionSpacer    { flex: 0 0 6px; }
.actionEliminar  { background: #FFF0F6; color: #C4294A; border-color: #C4294A33; }

[data-theme="dark"] .actionDesa      { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .actionDescartar { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .actionNeutral   { background: var(--bg3); color: var(--text2); border-color: var(--border2); }
[data-theme="dark"] .actionEliminar  { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }
'@


# =============================================================================
# 03  Submissions.module.css - ADG KPI colors + toolbar color classes
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* Submissions.module.css - v0.4.3e */

.submissions {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--bg);
  overflow: hidden;
}

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

/* KPI value colors - ADG definitive */
.kpiWarn { color: #B45309; }
.kpiOk   { color: #15803D; }
.kpiDes  { color: #C4294A; }

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
  overflow: auto;
}

/* Toolbar colored-resting classes
   Rule: text=accent / border=accent+#33 / bg=pastel */
.toolbarCyan  { background: #E0F9FF !important; color: #0885A8 !important; border-color: #0885A833 !important; }
.toolbarGreen { background: #DCFCE7 !important; color: #15803D !important; border-color: #15803D33 !important; }
.toolbarRed   { background: #FFF0F6 !important; color: #C4294A !important; border-color: #C4294A33 !important; }
'@


# =============================================================================
# 04  submissions/index.tsx - apply toolbar color classes
# =============================================================================
Write-File 'src\modules\submissions\index.tsx' @'
// submissions/index.tsx - v0.4.3e
import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { Inspector } from './components/Inspector'
import { mockSubmissions } from './mockData'
import styles from './Submissions.module.css'

const kpis = {
  total:      mockSubmissions.length,
  payPending: mockSubmissions.filter(s => s.payment !== 'ok').length,
  matPending: mockSubmissions.filter(s => s.material !== 'ok').length,
  noAward:    mockSubmissions.filter(s => !s.award).length,
}

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail,   setShowDetail]   = useState(false)
  const [detailId,     setDetailId]     = useState<string | null>(null)

  const handleRowClick = (id: string) => { setDetailId(id); setShowDetail(true) }
  const handleSelectId = (id: string) => { setDetailId(id) }
  const closeDetail    = () => { setShowDetail(false); setDetailId(null) }

  const selectedSubmission = detailId
    ? (mockSubmissions.find(s => s.id === detailId) ?? null)
    : null

  return (
    <div className={styles.submissions}>

      {/* KPI Strip */}
      <div className={styles.kpiStrip}>
        <div className={styles.kpi}>
          <span className={styles.kpiVal}>{kpis.total}</span>
          <span className={styles.kpiLbl}>Total</span>
        </div>
        <div className={styles.kpi}>
          <span className={`${styles.kpiVal} ${kpis.payPending > 0 ? styles.kpiWarn : styles.kpiOk}`}>
            {kpis.payPending}
          </span>
          <span className={styles.kpiLbl}>Payment pending</span>
        </div>
        <div className={styles.kpi}>
          <span className={`${styles.kpiVal} ${kpis.matPending > 0 ? styles.kpiWarn : styles.kpiOk}`}>
            {kpis.matPending}
          </span>
          <span className={styles.kpiLbl}>Material pending</span>
        </div>
        <div className={styles.kpi}>
          <span className={styles.kpiVal}>{kpis.noAward}</span>
          <span className={styles.kpiLbl}>No award</span>
        </div>
      </div>

      {/* Toolbar - system buttons colored in resting state */}
      <div className="toolbar">
        <div className="toolbar-group">
          <Button variant="icon" title="Refresh" className={styles.toolbarCyan}>
            <i className="bi bi-arrow-repeat"></i>
          </Button>
          <Button variant="icon" title="Import CSV" className={styles.toolbarGreen}>
            <i className="bi bi-upload"></i>
          </Button>
          <Button variant="icon" title="Save session">
            <i className="bi bi-save"></i>
          </Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Remove CSV">
            <i className="bi bi-file-earmark-x"></i>
          </Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Duplicate selected">
            <i className="bi bi-files"></i>
          </Button>
          <Button
            variant="icon"
            disabled={selectedRows.length === 0}
            title="Delete selected"
            className={selectedRows.length > 0 ? styles.toolbarRed : ''}
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
          <Button variant="icon" title="Column visibility">
            <i className="bi bi-layout-three-columns"></i>
          </Button>
        </div>
      </div>

      {/* Main area */}
      <div className={styles.mainArea}>
        <div className={`${styles.tableContainer} ${showDetail ? styles.tableContainerWithDetail : ''}`}>
          <SubmissionsTable
            selectedRows={selectedRows}
            onSelectionChange={setSelectedRows}
            onRowClick={handleRowClick}
          />
        </div>

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
# 05  Table\styles.module.css - award chip purple pastel + YN pastel
# =============================================================================
Write-File 'src\modules\submissions\components\Table\styles.module.css' @'
/* Table/styles.module.css - v0.4.3e */
.table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  font-size: 11.5px;
  table-layout: auto;
}

.th {
  position: sticky; top: 0; z-index: 2;
  text-align: left; padding: 5px 8px;
  background: var(--bg2); color: var(--text3);
  font-weight: 400; font-size: 7.5px;
  text-transform: uppercase; letter-spacing: 0.14em;
  border-bottom: 1px solid var(--border2);
  border-right: 1px solid var(--border3);
  white-space: nowrap; user-select: none;
}
.th:last-child { border-right: none; }
.thCenter { text-align: center; }

.sortable { cursor: pointer; }
.sortable:hover { color: var(--text2); }
.sorted { color: var(--text); }
.sortNull  { margin-left: 2px; opacity: 0.25; font-style: normal; font-size: 8px; }
.sortArrow { margin-left: 2px; font-style: normal; font-size: 8px; }

.table td {
  padding: 5px 8px;
  border-bottom: 1px solid var(--border3);
  border-right: 1px solid var(--border3);
  color: var(--text); vertical-align: middle; white-space: nowrap;
}
.table td:last-child { border-right: none; }

.row { cursor: pointer; transition: background 0.06s; }
.row:hover { background: var(--hover); }
.row.selected { background: var(--bg3); box-shadow: inset 3px 0 0 var(--text); }
.row.selected td { color: var(--text); }

/* Column widths */
.cbCell    { width: 28px; text-align: center; padding: 0 6px; border-right: 1px solid var(--border3); }
.ordreCell { width: 30px; text-align: right; color: var(--text3); font-size: 10px; }
.codeCell  { width: 70px; font-family: monospace; font-size: 11px; font-weight: 600; color: var(--text2); }
.titleCell { min-width: 150px; max-width: 260px; overflow: hidden; text-overflow: ellipsis; }
.catCell   { width: 80px; }
.platCell  { width: 70px; color: var(--text2); }
.badgeCell { width: 78px; }
.centerCell{ width: 50px; text-align: center; }
.awardCell { width: 80px; }
.priceCell { width: 58px; text-align: right; color: var(--text2); font-family: monospace; font-size: 10.5px; }
.yearCell  { width: 42px; text-align: right; color: var(--text3); font-size: 10px; }
.nameCell  { width: 110px; }

.cellDim { color: var(--text3); }

/* YN: green pastel accent for yes, neutral for no */
.ynYes { font-size: 8px; font-weight: 600; letter-spacing: 0.07em; text-transform: uppercase; color: #15803D; }
.ynNo  { font-size: 8px; font-weight: 400; letter-spacing: 0.04em; text-transform: uppercase; color: var(--text3); }

/* Award chip: Senaletica purple pastel */
.awardChip {
  display: inline-flex; align-items: center;
  font-size: 7.5px; font-weight: 600; letter-spacing: 0.06em;
  text-transform: uppercase; padding: 2px 6px;
  border-radius: var(--radius);
  background: #F5F3FF; color: #7C3AED; border: 1px solid #7C3AED33;
}
'@


# =============================================================================
# 06  Table\index.tsx - fix YN mojibake (use JS escape \u2014, pure ASCII)
# =============================================================================
Write-File 'src\modules\submissions\components\Table\index.tsx' @'
// Table/index.tsx - v0.4.3e
// Fixed YN mojibake: use JS escape \u2014 (ASCII-safe in PS heredoc).
import { useState } from 'react'
import { StatusBadge } from '../../../../shared/ui/StatusBadge'
import { mockSubmissions, type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props {
  selectedRows: string[]
  onSelectionChange: (ids: string[]) => void
  onRowClick: (id: string) => void
}

type Dir = 'asc' | 'desc' | null
interface Sort { col: string; dir: Dir }

const SORTABLE = ['ordre', 'code', 'title', 'category', 'platform', 'payment', 'year', 'price']

function sortData(data: MockSubmission[], sort: Sort): MockSubmission[] {
  if (!sort.dir) return data
  return [...data].sort((a, b) => {
    const m = sort.dir === 'asc' ? 1 : -1
    switch (sort.col) {
      case 'ordre':    return (a.ordre - b.ordre) * m
      case 'code':     return a.code.localeCompare(b.code) * m
      case 'title':    return a.title.localeCompare(b.title) * m
      case 'category': return a.category.localeCompare(b.category) * m
      case 'platform': return (a.platform ?? '').localeCompare(b.platform ?? '') * m
      case 'payment':  return a.payment.localeCompare(b.payment) * m
      case 'year':     return (a.year - b.year) * m
      case 'price':    return (Number(a.price ?? 0) - Number(b.price ?? 0)) * m
      default:         return 0
    }
  })
}

function SortArrow({ col, sort }: { col: string; sort: Sort }) {
  if (sort.col !== col || !sort.dir) return <span className={styles.sortNull}>~</span>
  return <span className={styles.sortArrow}>{sort.dir === 'asc' ? '^' : 'v'}</span>
}

// \u2014 as JS Unicode escape - always ASCII-safe in PowerShell heredocs
function YN({ val }: { val?: boolean }) {
  if (val === undefined || val === null)
    return <span className={styles.cellDim}>{'\u2014'}</span>
  return val
    ? <span className={styles.ynYes}>Yes</span>
    : <span className={styles.ynNo}>No</span>
}

export function SubmissionsTable({ selectedRows, onSelectionChange, onRowClick }: Props) {
  const [sort, setSort] = useState<Sort>({ col: 'ordre', dir: 'asc' })

  const toggleSort = (col: string) => {
    setSort(prev => {
      if (prev.col !== col) return { col, dir: 'asc' }
      if (prev.dir === 'asc')  return { col, dir: 'desc' }
      if (prev.dir === 'desc') return { col, dir: null }
      return { col, dir: 'asc' }
    })
  }

  const rows = sortData(mockSubmissions, sort)
  const allSelected = selectedRows.length === rows.length && rows.length > 0

  const toggleAll = (checked: boolean) =>
    onSelectionChange(checked ? rows.map(r => r.id) : [])

  const toggleRow = (id: string, checked: boolean) =>
    onSelectionChange(checked ? [...selectedRows, id] : selectedRows.filter(i => i !== id))

  function th(col: string, label: string, center?: boolean) {
    const isSortable = SORTABLE.includes(col)
    return (
      <th
        className={`${styles.th} ${isSortable ? styles.sortable : ''} ${sort.col === col ? styles.sorted : ''} ${center ? styles.thCenter : ''}`}
        onClick={isSortable ? () => toggleSort(col) : undefined}
      >
        {label}
        {isSortable && <SortArrow col={col} sort={sort} />}
      </th>
    )
  }

  return (
    <table className={styles.table}>
      <thead>
        <tr>
          <th className={styles.cbCell}>
            <input
              type="checkbox"
              checked={allSelected}
              onChange={e => toggleAll(e.target.checked)}
            />
          </th>
          {th('ordre',    '#')}
          {th('code',     'Code')}
          {th('title',    'Title')}
          {th('category', 'Category')}
          {th('platform', 'Platform')}
          {th('payment',  'Payment')}
          <th className={styles.th}>Phys. Mat</th>
          <th className={styles.th}>Dig. Mat</th>
          <th className={`${styles.th} ${styles.thCenter}`}>Return</th>
          <th className={`${styles.th} ${styles.thCenter}`}>Selected</th>
          <th className={styles.th}>Award</th>
          {th('price', 'Price')}
          <th className={styles.th}>Name</th>
          <th className={`${styles.th} ${styles.thCenter}`}>FAD</th>
          {th('year', 'Year')}
        </tr>
      </thead>
      <tbody>
        {rows.map(row => {
          const sel = selectedRows.includes(row.id)
          return (
            <tr
              key={row.id}
              className={`${styles.row} ${sel ? styles.selected : ''}`}
              onClick={() => onRowClick(row.id)}
            >
              <td className={styles.cbCell} onClick={e => e.stopPropagation()}>
                <input
                  type="checkbox"
                  checked={sel}
                  onChange={e => toggleRow(row.id, e.target.checked)}
                />
              </td>
              <td className={styles.ordreCell}>{row.ordre}</td>
              <td className={styles.codeCell}>{row.code}</td>
              <td className={styles.titleCell}>{row.title}</td>
              <td className={styles.catCell}>{row.category}</td>
              <td className={styles.platCell}>{row.platform ?? ''}</td>
              <td className={styles.badgeCell}>
                <StatusBadge status={row.payment === 'ok' ? 'ok' : row.payment === 'pending' ? 'warning' : 'issue'}>
                  {row.payment === 'ok' ? 'Confirmed' : row.payment === 'pending' ? 'Pending' : 'Error'}
                </StatusBadge>
              </td>
              <td className={styles.badgeCell}>
                <StatusBadge status={row.material === 'ok' ? 'ok' : row.material === 'warning' ? 'warning' : 'issue'}>
                  {row.material === 'ok' ? 'Received' : row.material === 'warning' ? 'Pending' : 'Missing'}
                </StatusBadge>
              </td>
              <td className={styles.badgeCell}>
                <StatusBadge status={(row.digitalMat ?? 'ok') === 'ok' ? 'ok' : (row.digitalMat ?? 'ok') === 'warning' ? 'warning' : 'issue'}>
                  {(row.digitalMat ?? 'ok') === 'ok' ? 'Received' : (row.digitalMat ?? 'ok') === 'warning' ? 'Pending' : 'Missing'}
                </StatusBadge>
              </td>
              <td className={styles.centerCell}><YN val={row.returnMaterial} /></td>
              <td className={styles.centerCell}><YN val={row.projectSelected} /></td>
              <td className={styles.awardCell}>
                {row.award
                  ? <span className={styles.awardChip}>{row.award}</span>
                  : <span className={styles.cellDim}>{'\u2014'}</span>
                }
              </td>
              <td className={styles.priceCell}>
                {row.price
                  ? `${row.price}\u00a0\u20ac`
                  : <span className={styles.cellDim}>{'\u2014'}</span>
                }
              </td>
              <td className={styles.nameCell}>{row.firstName} {row.lastName}</td>
              <td className={styles.centerCell}><YN val={row.fadMember} /></td>
              <td className={styles.yearCell}>{row.year}</td>
            </tr>
          )
        })}
      </tbody>
    </table>
  )
}
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3e complete - 6 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "Color system:" -ForegroundColor DarkGray
Write-Host "  ok/save/received  #15803D / #DCFCE7 (UX-green)" -ForegroundColor DarkGray
Write-Host "  warn/pend/discard #B45309 / #FFFBEB (amber)" -ForegroundColor DarkGray
Write-Host "  error/del/missing #C4294A / #FFF0F6 (pink-red)" -ForegroundColor DarkGray
Write-Host "  refresh / info    #0885A8 / #E0F9FF (web-cyan)" -ForegroundColor DarkGray
Write-Host "  award chip        #7C3AED / #F5F3FF (purple)" -ForegroundColor DarkGray
Write-Host "  neutral           #374151 / #F9FAFB (gray)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Toolbar resting colors: Refresh=cyan Import=green Delete(sel)=red" -ForegroundColor DarkGray
Write-Host "Bug fixed: YN u2014 mojibake now uses ASCII-safe JS escape (\u2014)" -ForegroundColor DarkGray
Write-Host ""
