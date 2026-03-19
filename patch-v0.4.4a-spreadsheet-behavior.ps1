#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.4a - Spreadsheet Behavior
#
# Apply AFTER v0.4.3f.
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.4a-spreadsheet-behavior.ps1
#
# Files changed (4):
#   src\modules\submissions\components\Table\index.tsx
#       Sticky cols 1+2, remove # col, ALL 14 cols sortable, drag-to-scroll
#   src\modules\submissions\components\Table\styles.module.css
#       Sticky CSS, custom scrollbar, grab cursor, tableWrap
#   src\modules\submissions\Submissions.module.css
#       KPI flow fix (no detached last item), tableContainer overflow fix
#   src\modules\submissions\index.tsx
#       No structural change - just explicit overflow:hidden on tableContainer
#       so the inner tableWrap controls all scrolling
#
# SCOPE: zero data-model changes. mockData.ts untouched.
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
Write-Host "LAUS OPS CONSOLE - patch v0.4.4a" -ForegroundColor Cyan
Write-Host "Spreadsheet Behavior" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  Table/index.tsx
#
# Changes:
#   - inner tableWrap div owns the overflow / scroll
#   - drag-to-scroll: useRef + useEffect with proper return-cleanup
#   - sticky col 1 (checkbox, left:0)
#   - sticky col 2 (code, left:30px)
#   - # column removed (ordre still used for default sort, not displayed)
#   - ALL 14 visible data columns are now sortable:
#     code, title, category, platform, payment,
#     material (Phys.Mat), digitalMat (Dig.Mat),
#     returnMaterial, projectSelected, award,
#     price, firstName (Name), fadMember (FAD), year
#   - sort arrows present on every sortable column header
#   - up/down unicode arrows (no ASCII hacks)
#   - YN uses JS \u2014 escape (safe in PS heredoc)
# =============================================================================
Write-File 'src\modules\submissions\components\Table\index.tsx' @'
// Table/index.tsx - v0.4.4a
// Sticky checkbox + code. # column removed. All 14 data cols sortable.
// Drag-to-scroll with proper useEffect cleanup.
import { useState, useRef, useEffect } from 'react'
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

// All 14 visible data columns are sortable
const SORTABLE = [
  'code', 'title', 'category', 'platform',
  'payment', 'material', 'digitalMat',
  'returnMaterial', 'projectSelected', 'award',
  'price', 'firstName', 'fadMember', 'year',
]

function sortData(data: MockSubmission[], sort: Sort): MockSubmission[] {
  if (!sort.dir) return [...data].sort((a, b) => a.ordre - b.ordre)
  const m = sort.dir === 'asc' ? 1 : -1
  return [...data].sort((a, b) => {
    switch (sort.col) {
      case 'code':           return a.code.localeCompare(b.code) * m
      case 'title':          return a.title.localeCompare(b.title) * m
      case 'category':       return a.category.localeCompare(b.category) * m
      case 'platform':       return (a.platform ?? '').localeCompare(b.platform ?? '') * m
      case 'payment':        return a.payment.localeCompare(b.payment) * m
      case 'material':       return a.material.localeCompare(b.material) * m
      case 'digitalMat':     return (a.digitalMat ?? 'ok').localeCompare(b.digitalMat ?? 'ok') * m
      case 'returnMaterial': return ((a.returnMaterial ? 1 : 0) - (b.returnMaterial ? 1 : 0)) * m
      case 'projectSelected':return ((a.projectSelected ? 1 : 0) - (b.projectSelected ? 1 : 0)) * m
      case 'award':          return (a.award ?? '').localeCompare(b.award ?? '') * m
      case 'price':          return (Number(a.price ?? 0) - Number(b.price ?? 0)) * m
      case 'firstName':      return `${a.firstName} ${a.lastName}`.localeCompare(`${b.firstName} ${b.lastName}`) * m
      case 'fadMember':      return ((a.fadMember ? 1 : 0) - (b.fadMember ? 1 : 0)) * m
      case 'year':           return (a.year - b.year) * m
      default:               return 0
    }
  })
}

function SortArrow({ col, sort }: { col: string; sort: Sort }) {
  if (sort.col !== col || !sort.dir)
    return <span className={styles.sortNull}>{'\u2195'}</span>
  return <span className={styles.sortArrow}>{sort.dir === 'asc' ? '\u2191' : '\u2193'}</span>
}

function YN({ val }: { val?: boolean }) {
  if (val === undefined || val === null)
    return <span className={styles.cellDim}>{'\u2014'}</span>
  return val
    ? <span className={styles.ynYes}>Yes</span>
    : <span className={styles.ynNo}>No</span>
}

export function SubmissionsTable({ selectedRows, onSelectionChange, onRowClick }: Props) {
  const [sort, setSort] = useState<Sort>({ col: 'code', dir: 'asc' })
  const wrapRef = useRef<HTMLDivElement>(null)

  // Drag-to-scroll with proper cleanup
  useEffect(() => {
    const el = wrapRef.current
    if (!el) return

    let active = false
    let startX = 0
    let scrollLeft = 0

    function onDown(e: MouseEvent) {
      // Only trigger on direct clicks (not on checkboxes / buttons)
      const target = e.target as HTMLElement
      if (target.closest('button, input, a')) return
      active = true
      startX = e.pageX
      scrollLeft = el.scrollLeft
      el.classList.add(styles.grabbing)
    }
    function onMove(e: MouseEvent) {
      if (!active) return
      const dx = (e.pageX - startX) * 1.2
      el.scrollLeft = scrollLeft - dx
    }
    function onUp() {
      if (!active) return
      active = false
      el.classList.remove(styles.grabbing)
    }

    el.addEventListener('mousedown', onDown)
    window.addEventListener('mousemove', onMove)
    window.addEventListener('mouseup', onUp)

    return () => {
      el.removeEventListener('mousedown', onDown)
      window.removeEventListener('mousemove', onMove)
      window.removeEventListener('mouseup', onUp)
    }
  }, [])

  const toggleSort = (col: string) =>
    setSort(prev => {
      if (prev.col !== col) return { col, dir: 'asc' }
      if (prev.dir === 'asc')  return { col, dir: 'desc' }
      if (prev.dir === 'desc') return { col, dir: null }
      return { col, dir: 'asc' }
    })

  const rows = sortData(mockSubmissions, sort)
  const allSelected = selectedRows.length === rows.length && rows.length > 0

  const toggleAll = (checked: boolean) =>
    onSelectionChange(checked ? rows.map(r => r.id) : [])
  const toggleRow = (id: string, checked: boolean) =>
    onSelectionChange(checked ? [...selectedRows, id] : selectedRows.filter(i => i !== id))

  // th helper - all sortable cols get sort arrow
  function th(col: string, label: string, extraCls?: string) {
    const sortable = SORTABLE.includes(col)
    return (
      <th
        className={[
          styles.th,
          sortable ? styles.sortable : '',
          sort.col === col && sort.dir ? styles.sorted : '',
          extraCls ?? '',
        ].filter(Boolean).join(' ')}
        onClick={sortable ? () => toggleSort(col) : undefined}
      >
        <span className={styles.thContent}>
          {label}
          {sortable && <SortArrow col={col} sort={sort} />}
        </span>
      </th>
    )
  }

  return (
    <div className={styles.tableWrap} ref={wrapRef}>
      <table className={styles.table}>
        <thead>
          <tr>
            {/* col 1: checkbox - sticky left:0 */}
            <th className={`${styles.th} ${styles.cbTh} ${styles.sticky1}`}>
              <input
                type="checkbox"
                checked={allSelected}
                onChange={e => toggleAll(e.target.checked)}
              />
            </th>
            {/* col 2: code - sticky left:30px */}
            {th('code',            'Code',      styles.sticky2)}
            {th('title',           'Title')}
            {th('category',        'Category')}
            {th('platform',        'Platform')}
            {th('payment',         'Payment')}
            {th('material',        'Phys. Mat')}
            {th('digitalMat',      'Dig. Mat')}
            {th('returnMaterial',  'Return',    styles.thCenter)}
            {th('projectSelected', 'Selected',  styles.thCenter)}
            {th('award',           'Award')}
            {th('price',           'Price')}
            {th('firstName',       'Name')}
            {th('fadMember',       'FAD',       styles.thCenter)}
            {th('year',            'Year')}
          </tr>
        </thead>
        <tbody>
          {rows.map(row => {
            const sel = selectedRows.includes(row.id)
            return (
              <tr
                key={row.id}
                className={`${styles.row} ${sel ? styles.rowSelected : ''}`}
                onClick={() => onRowClick(row.id)}
              >
                {/* sticky col 1 */}
                <td
                  className={`${styles.cbCell} ${styles.sticky1} ${sel ? styles.stickyBgSel : styles.stickyBg}`}
                  onClick={e => e.stopPropagation()}
                >
                  <input
                    type="checkbox"
                    checked={sel}
                    onChange={e => toggleRow(row.id, e.target.checked)}
                  />
                </td>
                {/* sticky col 2 */}
                <td className={`${styles.codeCell} ${styles.sticky2} ${sel ? styles.stickyBgSel : styles.stickyBg}`}>
                  {row.code}
                </td>
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
                  {(() => {
                    const d = row.digitalMat ?? 'ok'
                    return (
                      <StatusBadge status={d === 'ok' ? 'ok' : d === 'warning' ? 'warning' : 'issue'}>
                        {d === 'ok' ? 'Received' : d === 'warning' ? 'Pending' : 'Missing'}
                      </StatusBadge>
                    )
                  })()}
                </td>
                <td className={`${styles.centerCell}`}><YN val={row.returnMaterial} /></td>
                <td className={`${styles.centerCell}`}><YN val={row.projectSelected} /></td>
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
                <td className={`${styles.centerCell}`}><YN val={row.fadMember} /></td>
                <td className={styles.yearCell}>{row.year}</td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
'@


# =============================================================================
# 02  Table/styles.module.css
#
# Key rules:
# - tableWrap: overflow:auto owns all scrolling, custom scrollbar
# - .sticky1 (col1 checkbox): left:0, z-index:4
# - .sticky2 (col2 code):     left:30px, z-index:4
# - .stickyBg / .stickyBgSel: explicit background so sticky cells don't bleed through
# - thead sticky1/sticky2 get z-index:5 so they sit above tbody sticky cells
# - grabbing class applied via JS for cursor
# =============================================================================
Write-File 'src\modules\submissions\components\Table\styles.module.css' @'
/* Table/styles.module.css - v0.4.4a */

/* Scroll container --------------------------------------------------------- */
.tableWrap {
  width: 100%;
  height: 100%;
  overflow: auto;
  cursor: default;
  /* Thin custom scrollbar */
  scrollbar-width: thin;
  scrollbar-color: var(--border2) transparent;
}
.tableWrap::-webkit-scrollbar          { height: 6px; width: 6px; }
.tableWrap::-webkit-scrollbar-track   { background: transparent; }
.tableWrap::-webkit-scrollbar-thumb   { background: var(--border2); border-radius: 3px; }
.tableWrap::-webkit-scrollbar-thumb:hover { background: var(--border); }

/* Applied by JS during drag */
.grabbing { cursor: grabbing !important; user-select: none; }

/* Table base --------------------------------------------------------------- */
.table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  font-size: 11px;
  table-layout: auto;
}

/* Header cells ------------------------------------------------------------- */
.th {
  position: sticky;
  top: 0;
  z-index: 2;
  text-align: left;
  padding: 5px 8px;
  background: var(--bg2);
  color: var(--text3);
  font-weight: 400;
  font-size: 7.5px;
  text-transform: uppercase;
  letter-spacing: 0.13em;
  border-bottom: 1px solid var(--border2);
  border-right: 1px solid var(--border3);
  white-space: nowrap;
  user-select: none;
}
.th:last-child { border-right: none; }

.thCenter { text-align: center; }

.thContent {
  display: inline-flex;
  align-items: center;
  gap: 2px;
}

/* Sort states */
.sortable { cursor: pointer; }
.sortable:hover { color: var(--text2); }
.sorted   { color: var(--text); }
.sortNull  { font-size: 8px; opacity: 0.25; font-style: normal; line-height: 1; }
.sortArrow { font-size: 8px; font-style: normal; line-height: 1; }

/* Data cells --------------------------------------------------------------- */
.table td {
  padding: 5px 8px;
  border-bottom: 1px solid var(--border3);
  border-right: 1px solid var(--border3);
  color: var(--text);
  vertical-align: middle;
  white-space: nowrap;
}
.table td:last-child { border-right: none; }

/* Rows */
.row { cursor: pointer; transition: background 0.06s; }
.row:hover { background: var(--hover); }
.rowSelected {
  background: var(--bg3);
  box-shadow: inset 3px 0 0 var(--text);
}
.rowSelected td { color: var(--text); }

/* ---- Sticky columns ------------------------------------------------------- */
/* col 1: checkbox (left: 0) */
.sticky1 {
  position: sticky;
  left: 0;
  z-index: 4;
}
/* col 2: code (left = width of col 1 = 30px) */
.sticky2 {
  position: sticky;
  left: 30px;
  z-index: 4;
  /* Subtle right-border accent to signal sticky boundary */
  border-right: 2px solid var(--border2) !important;
}

/* thead sticky cells sit above tbody sticky cells */
thead .sticky1, thead .sticky2 {
  z-index: 5;
  background: var(--bg2);
}

/* Each sticky td needs an explicit background or it shows through.         */
/* Applied via JS-driven className (stickyBg / stickyBgSel).               */
.stickyBg    { background: var(--bg); }
.stickyBgSel { background: var(--bg3); }
.row:hover .stickyBg, .row:hover .stickyBgSel { background: var(--hover); }

/* ---- Column widths -------------------------------------------------------- */
.cbTh      { width: 30px; text-align: center; padding: 0 6px; }
.cbCell    { width: 30px; text-align: center; padding: 0 6px; }
.codeCell  { width: 74px; font-family: monospace; font-size: 11px; font-weight: 600; color: var(--text2); }
.titleCell { min-width: 160px; max-width: 280px; overflow: hidden; text-overflow: ellipsis; }
.catCell   { width: 80px; }
.platCell  { width: 74px; color: var(--text2); }
.badgeCell { width: 72px; }
.centerCell{ width: 52px; text-align: center; }
.awardCell { width: 82px; }
.priceCell { width: 56px; text-align: right; font-family: monospace; font-size: 10.5px; color: var(--text2); }
.nameCell  { min-width: 110px; max-width: 160px; overflow: hidden; text-overflow: ellipsis; }
.yearCell  { width: 42px; text-align: right; color: var(--text3); font-size: 10px; }

/* ---- Cell value helpers --------------------------------------------------- */
.cellDim { color: var(--text3); }

.ynYes { font-size: 8px; font-weight: 600; letter-spacing: 0.06em; text-transform: uppercase; color: #15803D; }
.ynNo  { font-size: 8px; font-weight: 400; letter-spacing: 0.04em; text-transform: uppercase; color: var(--text3); }

.awardChip {
  display: inline-flex; align-items: center;
  font-size: 7.5px; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase;
  padding: 2px 6px; border-radius: var(--radius);
  background: #F5F3FF; color: #7C3AED; border: 1px solid #7C3AED33;
}
'@


# =============================================================================
# 03  Submissions.module.css
#
# Changes:
# - KPI: remove margin-left:auto from last item (was detaching "No award")
# - tableContainer: overflow:hidden so inner tableWrap owns all scrolling
#   (prevents double scrollbar / outer container interfering with sticky)
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* Submissions.module.css - v0.4.4a */

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

/* All KPI cells in equal flow - no detached last item */
.kpi {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 18px;
  border-right: 1px solid var(--border2);
  flex-shrink: 0;
}
.kpi:last-child { border-right: none; }

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

.kpiWarn { color: #B45309; }
.kpiOk   { color: #15803D; }
.kpiDes  { color: #C4294A; }

/* Main layout -------------------------------------------------------------- */
.mainArea {
  display: flex;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

/* tableContainer must be overflow:hidden so the inner tableWrap controls     */
/* all horizontal/vertical scroll and sticky positioning works correctly.      */
.tableContainer {
  flex: 1 1 100%;
  overflow: hidden;
  background: var(--bg);
  position: relative;
}

.tableContainerWithDetail {
  flex: 0 0 50%;
}

/* Toolbar colored buttons */
.toolbarCyan  { background: #E0F9FF !important; color: #0885A8 !important; border-color: #0885A833 !important; }
.toolbarGreen { background: #DCFCE7 !important; color: #15803D !important; border-color: #15803D33 !important; }
.toolbarRed   { background: #FFF0F6 !important; color: #C4294A !important; border-color: #C4294A33 !important; }
'@


# =============================================================================
# 04  submissions/index.tsx
#     Identical logic to v0.4.3f/e - only preserved here so it stays
#     consistent with the new tableContainer overflow:hidden rule above.
#     No other changes.
# =============================================================================
Write-File 'src\modules\submissions\index.tsx' @'
// submissions/index.tsx - v0.4.4a (no logic change)
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

      {/* Toolbar */}
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
Write-Host ""
Write-Host "patch v0.4.4a complete - 4 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  Table/index    Sticky col1 (checkbox, left:0) + col2 (code, left:30px)" -ForegroundColor DarkGray
Write-Host "                 # column removed (ordre still used for default sort)" -ForegroundColor DarkGray
Write-Host "                 ALL 14 data cols sortable (was 8 - added material, digitalMat," -ForegroundColor DarkGray
Write-Host "                   returnMaterial, projectSelected, award, firstName, fadMember)" -ForegroundColor DarkGray
Write-Host "                 Sort arrows on every sortable column (up/down unicode)" -ForegroundColor DarkGray
Write-Host "                 Drag-to-scroll: useRef+useEffect with full cleanup" -ForegroundColor DarkGray
Write-Host "                 Only fires when not clicking button/input/anchor" -ForegroundColor DarkGray
Write-Host "  Table/styles   tableWrap owns overflow (6px custom scrollbar)" -ForegroundColor DarkGray
Write-Host "                 Sticky CSS with explicit z-index layering" -ForegroundColor DarkGray
Write-Host "                 stickyBg/stickyBgSel: explicit backgrounds prevent bleed" -ForegroundColor DarkGray
Write-Host "                 Grab cursor class applied via JS" -ForegroundColor DarkGray
Write-Host "  Submissions.css KPI last item no longer detached (margin-left:auto removed)" -ForegroundColor DarkGray
Write-Host "                 tableContainer: overflow:hidden (inner tableWrap controls all)" -ForegroundColor DarkGray
Write-Host "  submissions/index No logic change - rewritten to match new CSS contract" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Zero data-model changes. mockData.ts untouched." -ForegroundColor Green
Write-Host ""
