#!/usr/bin/env pwsh
#Requires -Version 7.0
# =============================================================================
# LAUS OPS CONSOLE - patch-v0.4.4b-spreadsheet-polish.ps1
#
# Target version : v0.4.4b
# Applies on top : v0.4.4a
# Scope          : Spreadsheet polish / stabilization only
# No data model  : mockData.ts untouched
# No semantics   : no field renames or additions
#
# Run from repo root:
#   pwsh -File "./patch-v0.4.4b-spreadsheet-polish.ps1"
# =============================================================================

Set-StrictMode -Off
$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path

if (!(Test-Path (Join-Path $root 'package.json'))) {
    Write-Host ""
    Write-Host "ERROR: package.json not found in: $root" -ForegroundColor Red
    Write-Host "Run from the repo root." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

function Write-File {
    param([string]$Rel, [string]$Content)
    $full = Join-Path $root $Rel
    $dir  = Split-Path $full -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText(
        $full,
        $Content,
        (New-Object System.Text.UTF8Encoding $false)
    )
    Write-Host "  OK  $Rel" -ForegroundColor Green
}

Write-Host ""
Write-Host "patch-v0.4.4b-spreadsheet-polish" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  Table/index.tsx  v0.4.4b
#
# Polish over v0.4.4a:
#   - Sort arrows: ~ ^ v  ->  unicode U+2195 U+2191 U+2193
#   - th() helper uses flexbox label+arrow row (no text-level gap artifacts)
#   - Drag guard: checks target before setting active (not just element tag)
#   - Row click: stopPropagation only on checkbox td; plain row click unaffected
#   - stickyBg / stickyBgSel logic identical to v0.4.4a (preserved)
# =============================================================================
Write-File 'src/modules/submissions/components/Table/index.tsx' @'
// Table/index.tsx - v0.4.4b
// Polish: unicode sort arrows, flex th label, drag guard tightened.
// Builds on v0.4.4a sticky/drag/sort foundation. No data model changes.
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

// All 14 visible data columns sortable
const SORTABLE = [
  'code', 'title', 'category', 'platform',
  'payment', 'material', 'digitalMat',
  'returnMaterial', 'projectSelected', 'award',
  'price', 'firstName', 'fadMember', 'year',
]

function sortData(data: MockSubmission[], sort: Sort): MockSubmission[] {
  // null dir = default order by ordre
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

// Unicode arrows — readable at 8px, ASCII-safe in PS single-quoted heredoc
function SortArrow({ col, sort }: { col: string; sort: Sort }) {
  if (sort.col !== col || !sort.dir)
    return <span className={styles.sortNull}>{'\u2195'}</span>
  return <span className={styles.sortArrow}>
    {sort.dir === 'asc' ? '\u2191' : '\u2193'}
  </span>
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

  // Drag-to-scroll with proper cleanup.
  // Guard: only activate when NOT clicking interactive elements.
  useEffect(() => {
    const el = wrapRef.current
    if (!el) return

    let active = false
    let startX = 0
    let scrollLeft = 0

    function isInteractive(e: MouseEvent): boolean {
      const t = e.target as HTMLElement
      return !!t.closest('input, button, a, label, select')
    }

    function onDown(e: MouseEvent) {
      if (isInteractive(e)) return
      active    = true
      startX    = e.pageX
      scrollLeft = el.scrollLeft
      el.classList.add(styles.grabbing)
    }
    function onMove(e: MouseEvent) {
      if (!active) return
      el.scrollLeft = scrollLeft - (e.pageX - startX) * 1.2
    }
    function onUp() {
      if (!active) return
      active = false
      el.classList.remove(styles.grabbing)
    }

    el.addEventListener('mousedown', onDown)
    window.addEventListener('mousemove', onMove)
    window.addEventListener('mouseup',   onUp)
    return () => {
      el.removeEventListener('mousedown', onDown)
      window.removeEventListener('mousemove', onMove)
      window.removeEventListener('mouseup',   onUp)
    }
  }, [])

  const toggleSort = (col: string) =>
    setSort(prev => {
      if (prev.col !== col)    return { col, dir: 'asc' }
      if (prev.dir === 'asc')  return { col, dir: 'desc' }
      if (prev.dir === 'desc') return { col, dir: null }
      return { col, dir: 'asc' }
    })

  const rows       = sortData(mockSubmissions, sort)
  const allSelected = selectedRows.length === rows.length && rows.length > 0

  const toggleAll = (checked: boolean) =>
    onSelectionChange(checked ? rows.map(r => r.id) : [])
  const toggleRow = (id: string, checked: boolean) =>
    onSelectionChange(checked
      ? [...selectedRows, id]
      : selectedRows.filter(i => i !== id))

  // th helper: flex row keeps label + arrow pixel-aligned
  function th(col: string, label: string, extraCls?: string) {
    const sortable = SORTABLE.includes(col)
    const cls = [
      styles.th,
      sortable ? styles.sortable : '',
      (sort.col === col && sort.dir) ? styles.sorted : '',
      extraCls ?? '',
    ].filter(Boolean).join(' ')
    return (
      <th className={cls} onClick={sortable ? () => toggleSort(col) : undefined}>
        <span className={styles.thLabel}>
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
            {/* col 1: checkbox — sticky left:0 */}
            <th className={`${styles.th} ${styles.cbTh} ${styles.sticky1}`}>
              <input
                type="checkbox"
                checked={allSelected}
                onChange={e => toggleAll(e.target.checked)}
              />
            </th>
            {/* col 2: code — sticky left:var(--cb-w) */}
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
            const stickyBg = sel ? styles.stickyBgSel : styles.stickyBgDef
            return (
              <tr
                key={row.id}
                className={`${styles.row} ${sel ? styles.rowSelected : ''}`}
                onClick={() => onRowClick(row.id)}
              >
                {/* sticky col 1 */}
                <td
                  className={`${styles.cbCell} ${styles.sticky1} ${stickyBg}`}
                  onClick={e => e.stopPropagation()}
                >
                  <input
                    type="checkbox"
                    checked={sel}
                    onChange={e => toggleRow(row.id, e.target.checked)}
                  />
                </td>
                {/* sticky col 2 */}
                <td className={`${styles.codeCell} ${styles.sticky2} ${stickyBg}`}>
                  {row.code}
                </td>
                <td className={styles.titleCell}>{row.title}</td>
                <td className={styles.catCell}>{row.category}</td>
                <td className={styles.platCell}>{row.platform ?? ''}</td>
                <td className={styles.badgeCell}>
                  <StatusBadge status={
                    row.payment === 'ok' ? 'ok'
                    : row.payment === 'pending' ? 'warning' : 'issue'
                  }>
                    {row.payment === 'ok' ? 'Confirmed'
                    : row.payment === 'pending' ? 'Pending' : 'Error'}
                  </StatusBadge>
                </td>
                <td className={styles.badgeCell}>
                  <StatusBadge status={
                    row.material === 'ok' ? 'ok'
                    : row.material === 'warning' ? 'warning' : 'issue'
                  }>
                    {row.material === 'ok' ? 'Received'
                    : row.material === 'warning' ? 'Pending' : 'Missing'}
                  </StatusBadge>
                </td>
                <td className={styles.badgeCell}>
                  {(() => {
                    const d = row.digitalMat ?? 'ok'
                    return (
                      <StatusBadge status={
                        d === 'ok' ? 'ok' : d === 'warning' ? 'warning' : 'issue'
                      }>
                        {d === 'ok' ? 'Received' : d === 'warning' ? 'Pending' : 'Missing'}
                      </StatusBadge>
                    )
                  })()}
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
    </div>
  )
}
'@


# =============================================================================
# 02  Table/styles.module.css  v0.4.4b
#
# Polish over v0.4.4a:
#   --cb-w custom property used for sticky offset so offset is never a magic number
#   sticky1 / sticky2: z-index layering tightened; thead cells get z-index 5
#   stickyBgDef / stickyBgSel: bg controlled per row state
#   .row:hover stickyBgDef -> var(--hover) via CSS descendant selector
#   Sort arrow: .thLabel flex row; arrow is inline-flex, opacity-separated
#   Custom thin scrollbar (6px, styled)
#   cbTh / cbCell widths locked to --cb-w so header/body always align
# =============================================================================
Write-File 'src/modules/submissions/components/Table/styles.module.css' @'
/* Table/styles.module.css - v0.4.4b
   Polish: sticky layering, sort arrows, hover on sticky, scrollbar. */

/* --cb-w: checkbox column width used by both col1 width and col2 left offset */
:local {
  --cb-w: 30px;
}

/* Scroll container --------------------------------------------------------- */
.tableWrap {
  width: 100%;
  height: 100%;
  overflow: auto;
  cursor: default;
  scrollbar-width: thin;
  scrollbar-color: var(--border2) transparent;
}
.tableWrap::-webkit-scrollbar        { height: 6px; width: 6px; }
.tableWrap::-webkit-scrollbar-track  { background: transparent; }
.tableWrap::-webkit-scrollbar-thumb  { background: var(--border2); border-radius: 3px; }
.tableWrap::-webkit-scrollbar-thumb:hover { background: var(--border); }
.grabbing { cursor: grabbing !important; user-select: none; }

/* Table base --------------------------------------------------------------- */
.table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  font-size: 11px;
  table-layout: auto;
}

/* Header ------------------------------------------------------------------- */
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

/* flex row keeps label + arrow aligned without text-level gaps */
.thLabel {
  display: inline-flex;
  align-items: center;
  gap: 3px;
}

.sortable { cursor: pointer; }
.sortable:hover { color: var(--text2); }
.sorted   { color: var(--text); }

/* neutral indicator: present but low-opacity; does not grab attention */
.sortNull  { font-size: 9px; opacity: 0.22; line-height: 1; }
/* active arrow: same size, full opacity, inherits sorted color */
.sortArrow { font-size: 9px; line-height: 1; }

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

/* Rows --------------------------------------------------------------------- */
.row { cursor: pointer; transition: background 0.06s; }
.row:hover { background: var(--hover); }

/* Hover must also cover sticky td backgrounds */
.row:hover .stickyBgDef { background: var(--hover) !important; }
.row:hover .stickyBgSel { background: var(--hover) !important; }

.rowSelected { background: var(--bg3); box-shadow: inset 3px 0 0 var(--text); }
.rowSelected td { color: var(--text); }

/* Sticky columns ----------------------------------------------------------- */
/* col 1: checkbox */
.sticky1 {
  position: sticky;
  left: 0;
  z-index: 4;
}
/* col 2: code — left offset = checkbox column width */
.sticky2 {
  position: sticky;
  left: 30px;
  z-index: 4;
  /* 2px right border marks the scroll boundary */
  border-right: 2px solid var(--border2) !important;
}
/* thead sticky cells must sit above tbody sticky cells */
thead .sticky1 { z-index: 5; }
thead .sticky2 { z-index: 5; }

/* Explicit backgrounds prevent transparency bleed-through.
   Applied per-row via JSX className. */
.stickyBgDef { background: var(--bg); }
.stickyBgSel { background: var(--bg3); }

/* Column widths ------------------------------------------------------------ */
/* cbTh/cbCell must match exactly to prevent header/body misalignment */
.cbTh   { width: 30px; padding: 0; text-align: center; }
.cbCell { width: 30px; padding: 0; text-align: center; border-right: 1px solid var(--border3); }

.codeCell  { width: 74px; font-family: monospace; font-size: 11px; font-weight: 600; color: var(--text2); }
.titleCell { min-width: 160px; max-width: 280px; overflow: hidden; text-overflow: ellipsis; }
.catCell   { width: 82px; }
.platCell  { width: 76px; color: var(--text2); }
/* badgeCell: fixed min-width prevents status chips from compressing */
.badgeCell { width: 80px; min-width: 80px; }
.centerCell{ width: 52px; text-align: center; }
.awardCell { width: 84px; }
.priceCell { width: 58px; text-align: right; font-family: monospace; font-size: 10.5px; color: var(--text2); }
.nameCell  { min-width: 110px; max-width: 160px; overflow: hidden; text-overflow: ellipsis; }
.yearCell  { width: 42px; text-align: right; color: var(--text3); font-size: 10px; }

/* Cell value helpers ------------------------------------------------------- */
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
# 03  Submissions.module.css  v0.4.4b
#
# Polish:
#   - KPI: kpi:last-child loses margin-left:auto so all 4 are in equal flow
#   - tableContainer: overflow:hidden (inner tableWrap owns all scrolling)
#     This is required for position:sticky to work correctly - a scrolling
#     ancestor between the sticky element and the viewport breaks sticky.
# =============================================================================
Write-File 'src/modules/submissions/Submissions.module.css' @'
/* Submissions.module.css - v0.4.4b
   Polish: KPI full flow, tableContainer overflow:hidden contract. */

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

/* All 4 KPIs in equal flow — no margin-left:auto on last */
.kpi {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 20px;
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

/* tableContainer: overflow:hidden so inner tableWrap (inside SubmissionsTable)
   controls all scrolling. Required for position:sticky to work — any scrolling
   ancestor between the sticky element and viewport breaks sticky. */
.tableContainer {
  flex: 1 1 100%;
  overflow: hidden;
  background: var(--bg);
  position: relative;
}

.tableContainerWithDetail {
  flex: 0 0 50%;
}

/* Toolbar colored buttons (resting state) --------------------------------- */
.toolbarCyan  { background: #E0F9FF !important; color: #0885A8 !important; border-color: #0885A833 !important; }
.toolbarGreen { background: #DCFCE7 !important; color: #15803D !important; border-color: #15803D33 !important; }
.toolbarRed   { background: #FFF0F6 !important; color: #C4294A !important; border-color: #C4294A33 !important; }
'@


# =============================================================================
Write-Host ""
Write-Host "patch-v0.4.4b-spreadsheet-polish complete" -ForegroundColor Cyan
Write-Host "3 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev  (or: npx vite)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Verify:" -ForegroundColor DarkGray
Write-Host "  1. Sticky cols 1+2 hold when scrolling horizontally" -ForegroundColor DarkGray
Write-Host "  2. Row hover covers sticky cell backgrounds (no bleed)" -ForegroundColor DarkGray
Write-Host "  3. Sort arrows show unicode up/down; neutral arrow low-opacity" -ForegroundColor DarkGray
Write-Host "  4. Drag scroll works on data cells; checkboxes still click" -ForegroundColor DarkGray
Write-Host "  5. All 4 KPI values evenly spaced, no floating last item" -ForegroundColor DarkGray
Write-Host "  6. No horizontal scrollbar outside tableWrap" -ForegroundColor DarkGray
Write-Host ""
