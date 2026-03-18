#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3d - Ficha + Compact Row2 + Spreadsheet Cols
#
# Apply AFTER v0.4.3c + v0.4.3c-rev1.
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3d-ficha-spreadsheet-columns.ps1
#
# Files changed (5):
#   Inspector\index.tsx       "Ficha de proyecto" panel title
#   Inspector\LinksRow.tsx    Compact 2-col sub-layout + small notes
#   Inspector\styles.module.css  Remove blue bar, compact Row2, new link classes
#   Table\index.tsx           Fix \u2014 literal bug + 14 canonical columns
#   Table\styles.module.css   Smart column widths for spreadsheet feel
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
Write-Host "LAUS OPS CONSOLE - patch v0.4.3d" -ForegroundColor Cyan
Write-Host "Ficha + Compact Row2 + Spreadsheet Columns" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  Inspector\index.tsx
#     Panel title: "Ficha de proyecto" (not the code).
#     Code stays as a field inside C1 (General Info).
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\index.tsx' @'
// Inspector/index.tsx - v0.4.3d
// Panel title: "Ficha de proyecto". Code is a field inside C1.
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
        <span className={styles.panelTitle}>Ficha de proyecto</span>
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

        {/* Row 2: wide links+notes (C4) + narrow action rail (C5) */}
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
# 02  Inspector\LinksRow.tsx
#     Two compact sub-columns side by side (Dropbox | Project URL).
#     Internal notes: compact, below the sub-cols.
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\LinksRow.tsx' @'
// LinksRow.tsx - v0.4.3d
// C4: two compact sub-cols (Dropbox | Project URL) + compact notes below.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  const shortUrl = (url: string) => {
    try { return new URL(url).hostname } catch { return url }
  }

  return (
    <div className={styles.linksRow}>

      {/* Top: Dropbox | Project URL as two compact sub-cols */}
      <div className={styles.linksCols}>

        <div className={styles.linkSubCol}>
          <span className={styles.subColLabel}>Dropbox</span>
          <div className={styles.linkSubVal}>
            <i className="bi bi-dropbox" style={{ fontSize:'11px', color:'var(--text3)', flexShrink: 0 }} aria-hidden="true"></i>
            {submission.dropboxUrl
              ? <a href={submission.dropboxUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>{shortUrl(submission.dropboxUrl)}</a>
              : <span className={styles.linkEmpty}>{'—'}</span>
            }
            <button className={styles.editBtn} aria-label="Edit Dropbox">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        </div>

        <div className={styles.linkSubColDiv}></div>

        <div className={styles.linkSubCol}>
          <span className={styles.subColLabel}>Project URL</span>
          <div className={styles.linkSubVal}>
            <i className="bi bi-box-arrow-up-right" style={{ fontSize:'11px', color:'var(--text3)', flexShrink: 0 }} aria-hidden="true"></i>
            {submission.projectUrl
              ? <a href={submission.projectUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>{shortUrl(submission.projectUrl)}</a>
              : <span className={styles.linkEmpty}>{'—'}</span>
            }
            <button className={styles.editBtn} aria-label="Edit Project URL">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        </div>

      </div>

      {/* Bottom: compact internal notes */}
      <div className={styles.notesCompact}>
        <span className={styles.notesLabel}>Internal notes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={e => setNotes(e.target.value)}
          placeholder="Notes..."
        />
      </div>

    </div>
  )
}
'@


# =============================================================================
# 03  Inspector\styles.module.css
#     - Remove blue ::before bar from infoCol (wireframe annotation, not a bar)
#     - Row 2 compact: max-height 130px
#     - New classes: linksCols, linkSubCol, linkSubVal, linkSubColDiv, notesCompact
#     - notesTextarea: much smaller (min-height: 36px)
#     - C5 actionSpacer: flex:0 0 6px (small gap, Delete always visible)
#     - panelTitle class for "Ficha de proyecto"
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3d */

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

/* "Ficha de proyecto" - panel title */
.panelTitle {
  font-size: 8.5px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text2);
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

/* Row 2: C4 (wide) + C5 (fixed narrow rail) -------------------------------- */
/* Compact: max-height keeps Row 2 from dominating */
.lowerRow {
  display: flex;
  flex: 0 0 auto;
  min-height: 0;
  max-height: 130px;
  border-top: 0;
  overflow: hidden;
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

/* C1 - InfoColumn ---------------------------------------------------------- */
/* No blue ::before bar - that was a wireframe annotation */
.infoCol {
  padding: 10px 10px 10px 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.infoRow {
  display: flex;
  align-items: center;
  gap: 6px;
  min-height: 26px;
  padding: 2px 0;
  border-bottom: 1px solid var(--border3);
}
.infoRow:last-child { border-bottom: none; }

.infoKey {
  width: 58px;
  flex-shrink: 0;
  font-size: 7px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text3);
}

.infoVal {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 4px;
  min-height: 24px;
  padding: 3px 7px;
  background: var(--bg2);
  border: 1px solid var(--border2);
  border-radius: var(--radius);
}

.infoValText {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
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

/* C2 - ContactColumn ------------------------------------------------------- */
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
  margin-bottom: 7px;
  padding-bottom: 7px;
  border-bottom: 1px solid var(--border3);
}
.contactBlock:last-of-type { border-bottom: none; margin-bottom: 0; }

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
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text3);
  width: 60px;
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

/* Neutral links */
.cfVal a {
  color: var(--text2);
  text-decoration: none;
  border-bottom: 1px solid var(--border2);
}
.cfVal a:hover { color: var(--text); border-bottom-color: var(--text); }

.editBtn {
  width: 16px; height: 16px;
  display: flex; align-items: center; justify-content: center;
  border: none; background: none; color: var(--text3);
  cursor: pointer; font-size: 10px; flex-shrink: 0;
  padding: 0; transition: color 0.1s;
}
.editBtn:hover { color: var(--text); }

/* Other entries compact chips */
.altresSection { margin-top: 5px; }

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
  background: var(--bg2); color: var(--text3);
  cursor: pointer; transition: all 0.08s; font-family: monospace;
}
.codeBadge:hover { border-color: var(--border); background: var(--bg3); color: var(--text); }

/* C3 - StatusColumn -------------------------------------------------------- */
.statusCol {
  padding: 10px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.statusRow { display: flex; flex-direction: column; gap: 3px; }

.statusRowLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3);
}

.statusSmallNote {
  font-size: 8.5px; color: var(--text3);
  font-style: italic; overflow: hidden;
  text-overflow: ellipsis; white-space: nowrap;
}

.statusDivider { border: none; border-top: 1px solid var(--border2); margin: 2px 0; }

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

/* C4 - LinksRow (Row 2 wide block) ---------------------------------------- */
.linksRow {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-right: 1px solid var(--border2);
  overflow: hidden;
}

/* Two compact sub-columns side by side */
.linksCols {
  display: flex;
  flex: 0 0 auto;
  border-bottom: 1px solid var(--border2);
}

.linkSubCol {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 6px 8px;
  min-width: 0;
}

/* Vertical separator between sub-cols */
.linkSubColDiv {
  flex: 0 0 1px;
  background: var(--border2);
  align-self: stretch;
}

.subColLabel {
  font-size: 7px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--text3);
}

.linkSubVal {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 3px 6px;
  background: var(--bg2);
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  min-height: 24px;
  min-width: 0;
}

/* Neutral link anchors - never browser blue */
.linkAnchor {
  flex: 1;
  font-size: 9.5px;
  color: var(--text2);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  text-decoration: none;
  border-bottom: 1px solid var(--border2);
}
.linkAnchor:hover { color: var(--text); border-bottom-color: var(--text); }

.linkEmpty { font-size: 9.5px; color: var(--text3); flex: 1; }

/* Compact internal notes - bottom of C4 */
.notesCompact {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 5px 8px;
  gap: 3px;
  min-height: 0;
}

.notesLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3);
  flex-shrink: 0;
}

.notesTextarea {
  flex: 1;
  min-height: 28px;
  max-height: 50px;
  padding: 4px 6px;
  font-size: 9.5px;
  line-height: 1.45;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  color: var(--text2);
  resize: none;
  outline: none;
  font-family: inherit;
  transition: border-color 0.1s;
}
.notesTextarea:focus { border-color: var(--border); color: var(--text); background: var(--bg); }

/* C5 - ActionStack (Row 2 narrow action rail) ------------------------------ */
.actionStack {
  flex: 0 0 108px;
  width: 108px;
  padding: 6px 7px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: var(--bg2);
  flex-shrink: 0;
  overflow: hidden;
}

.actionBtn {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; width: 100%; height: 26px;
  font-size: 8px; font-weight: 700; letter-spacing: 0.09em;
  text-transform: uppercase; border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s; white-space: nowrap; flex-shrink: 0;
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

/* Small fixed spacer so Delete sits at bottom without being cut off */
.actionSpacer { flex: 0 0 6px; }

.actionEliminar { background: #43091F; color: #E9486E; border-color: #E9486E; }

[data-theme="dark"] .actionDesa      { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .actionDescartar { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .actionEliminar  { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }
'@


# =============================================================================
# 04  Table\index.tsx
#     - Fix literal \u2014 bug (move into JS expression {'\u2014'})
#     - Add canonical columns: Phys.Mat | Dig.Mat | Return | Selected | Name | FAD | Price
#     - Total: 14 visible columns + checkbox -> forces horizontal scroll
# =============================================================================
Write-File 'src\modules\submissions\components\Table\index.tsx' @'
// Table/index.tsx - v0.4.3d
// 14 canonical columns. Fixed \u2014 literal bug. Real horizontal scroll.
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
  if (sort.col !== col || !sort.dir) return <span className={styles.sortNull}>{'~'}</span>
  return <span className={styles.sortArrow}>{sort.dir === 'asc' ? '^' : 'v'}</span>
}

function YN({ val }: { val?: boolean }) {
  if (val === undefined || val === null)
    return <span className={styles.cellDim}>{'—'}</span>
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
          {th('price',    'Price')}
          <th className={styles.th}>Name</th>
          <th className={`${styles.th} ${styles.thCenter}`}>FAD</th>
          {th('year',     'Year')}
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
                {row.price ? `${row.price} \u20AC` : <span className={styles.cellDim}>{'\u2014'}</span>}
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
# 05  Table\styles.module.css
#     Smart column widths. Spreadsheet cells feel.
#     Center-aligned cells for boolean/numeric short fields.
# =============================================================================
Write-File 'src\modules\submissions\components\Table\styles.module.css' @'
/* Table/styles.module.css - v0.4.3d - spreadsheet simulation */
.table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  font-size: 11.5px;
  table-layout: auto;
}

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
  letter-spacing: 0.14em;
  border-bottom: 1px solid var(--border2);
  border-right: 1px solid var(--border3);
  white-space: nowrap;
  user-select: none;
}
.th:last-child { border-right: none; }

.thCenter { text-align: center; }

.sortable { cursor: pointer; }
.sortable:hover { color: var(--text2); }
.sorted { color: var(--text); }

.sortNull { margin-left: 2px; opacity: 0.25; font-style: normal; font-size: 8px; }
.sortArrow { margin-left: 2px; font-style: normal; font-size: 8px; }

.table td {
  padding: 6px 8px;
  border-bottom: 1px solid var(--border3);
  border-right: 1px solid var(--border3);
  color: var(--text);
  vertical-align: middle;
  white-space: nowrap;
}
.table td:last-child { border-right: none; }

.row { cursor: pointer; transition: background 0.06s; }
.row:hover { background: var(--hover); }
.row.selected {
  background: var(--bg3);
  box-shadow: inset 3px 0 0 var(--text);
}
.row.selected td { color: var(--text); }

/* ---- Column widths ---- */
/* Narrow: boolean/short */
.cbCell     { width: 28px; text-align: center; padding: 0 6px; border-right: 1px solid var(--border3); }
.ordreCell  { width: 30px; text-align: right; color: var(--text3); font-size: 10px; }
.centerCell { width: 52px; text-align: center; }

/* Medium */
.codeCell   { width: 70px; font-family: monospace; font-size: 11px; font-weight: 600; color: var(--text2); }
.catCell    { width: 80px; }
.platCell   { width: 70px; color: var(--text2); }
.badgeCell  { width: 76px; }
.awardCell  { width: 78px; }
.priceCell  { width: 58px; text-align: right; color: var(--text2); font-family: monospace; }
.yearCell   { width: 44px; text-align: right; color: var(--text3); font-size: 10px; }
.nameCell   { width: 110px; }

/* Long */
.titleCell  { min-width: 150px; max-width: 260px; overflow: hidden; text-overflow: ellipsis; }

/* ---- Misc cell styles ---- */
.cellDim { color: var(--text3); font-size: 10px; }

.ynYes {
  font-size: 8px; font-weight: 700; letter-spacing: 0.08em;
  text-transform: uppercase; color: var(--s-ok);
}
.ynNo {
  font-size: 8px; font-weight: 400; letter-spacing: 0.04em;
  text-transform: uppercase; color: var(--text3);
}

.awardChip {
  display: inline-flex; align-items: center;
  font-size: 7.5px; font-weight: 700; letter-spacing: 0.06em;
  text-transform: uppercase; padding: 2px 5px;
  border-radius: var(--radius);
  background: #01005D; color: #9694F4; border: 1px solid #9694F4;
}
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3d complete - 5 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  Inspector/index    Panel title = 'Ficha de proyecto' (not the code)" -ForegroundColor DarkGray
Write-Host "  Inspector/LinksRow Dropbox + Project URL as 2 compact sub-cols side by side" -ForegroundColor DarkGray
Write-Host "                     Internal notes: compact textarea, max-height 50px" -ForegroundColor DarkGray
Write-Host "  Inspector/styles   No blue ::before bar (was wireframe annotation)" -ForegroundColor DarkGray
Write-Host "                     Row 2 max-height: 130px (compact)" -ForegroundColor DarkGray
Write-Host "                     actionSpacer: fixed 6px gap (Delete always visible)" -ForegroundColor DarkGray
Write-Host "  Table/index        Fixed literal u2014 bug: now in JS expression" -ForegroundColor DarkGray
Write-Host "                     14 canonical columns: # Code Title Category Platform" -ForegroundColor DarkGray
Write-Host "                       Payment Phys.Mat Dig.Mat Return Selected Award Price Name FAD Year" -ForegroundColor DarkGray
Write-Host "  Table/styles       Smart widths. Cells bordered like spreadsheet." -ForegroundColor DarkGray
Write-Host "                     width:max-content forces horizontal scroll." -ForegroundColor DarkGray
Write-Host "                     YN cells: 52px centered. Badge cells: 76px." -ForegroundColor DarkGray
Write-Host ""
