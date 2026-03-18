#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3b - Polish + Fidelity Pass
#
# Save as UTF-8 before running.
# Run from the project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3b-polish-fidelity-pass.ps1
#
# Files changed (12):
#   src\modules\submissions\mockData.ts                        ENCODING FIX
#   src\shared\layout\Footer\index.tsx                         ENCODING FIX
#   src\shared\ui\ActivityLog\index.tsx                        ENCODING FIX
#   src\shared\ui\StatusBadge\styles.module.css                DARK-BG BADGE SYSTEM
#   src\modules\submissions\components\Table\styles.module.css SELECTED ROW
#   src\modules\submissions\components\Inspector\styles.module.css  VISUAL POLISH
#   src\modules\submissions\components\Inspector\InfoColumn.tsx     HORIZONTAL LAYOUT
#   src\modules\submissions\components\Inspector\ContactColumn.tsx  LABELS + ACCENTS
#   src\modules\submissions\components\Inspector\StatusColumn.tsx   LABELS + BADGES
#   src\modules\submissions\components\Inspector\LinksRow.tsx       LABELS
#   src\modules\submissions\Submissions.module.css             KPI STRIP STYLES
#   src\modules\submissions\index.tsx                          KPI STRIP RESTORED
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
Write-Host "LAUS OPS CONSOLE - patch v0.4.3b" -ForegroundColor Cyan
Write-Host "Polish + Fidelity Pass" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  src\modules\submissions\mockData.ts  -  ENCODING FIX (main fix)
# =============================================================================
Write-File 'src\modules\submissions\mockData.ts' @'
// src/modules/submissions/mockData.ts - v0.4.3b
// All text in correct UTF-8. Mojibake removed from all strings.

export interface MockSubmission {
  id: string
  code: string
  title: string
  category: string
  payment: 'ok' | 'pending' | 'issue'
  material: 'ok' | 'warning' | 'issue'
  selected?: boolean
  firstName: string
  lastName: string
  email: string
  studio: string
  phone?: string
  website?: string
  fadMember: boolean
  associationMember: boolean
  otherSubmissions: string[]
  internalNotes?: string
  projectUrl?: string
  dropboxUrl?: string
}

export const mockSubmissions: MockSubmission[] = [
  {
    id: '1', code: '17/64795', title: 'Disseny exposició', category: 'Branding',
    payment: 'ok', material: 'warning',
    firstName: 'Anna', lastName: 'Puig', email: 'anna@estudi.com',
    studio: 'Estudi Anna Puig', phone: '934567890', website: 'https://annapuig.cat',
    fadMember: true, associationMember: false, otherSubmissions: ['18/02341', '20/33456'],
    internalNotes: "Pendent d'aprovació final",
    projectUrl: 'https://projecte1.com', dropboxUrl: 'https://dropbox.com/1',
  },
  {
    id: '2', code: '18/02341', title: 'Campanya gràfica', category: 'Publicitat',
    payment: 'pending', material: 'ok',
    firstName: 'Joan', lastName: 'Vidal', email: 'joan@agencia.cat',
    studio: 'Agencia Vidal', phone: '934567891', website: 'https://vidal.cat',
    fadMember: false, associationMember: true, otherSubmissions: ['17/64795'],
    internalNotes: 'Revisió de proofs',
    projectUrl: 'https://campanya2.com', dropboxUrl: 'https://dropbox.com/2',
  },
  {
    id: '3', code: '19/11223', title: 'Web corporativa', category: 'Digital',
    payment: 'ok', material: 'issue',
    firstName: 'Marta', lastName: 'Soler', email: 'marta@web.cat',
    studio: 'Web Soler', phone: '934567892', website: 'https://marta.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Falten continguts',
    projectUrl: 'https://web3.com', dropboxUrl: 'https://dropbox.com/3',
  },
  {
    id: '4', code: '20/33456', title: 'Identitat visual', category: 'Branding',
    payment: 'ok', material: 'ok',
    firstName: 'Pau', lastName: 'Roca', email: 'pau@estudi.com',
    studio: 'Estudi Roca', phone: '934567893', website: 'https://pauroca.com',
    fadMember: false, associationMember: false, otherSubmissions: ['17/64795'],
    internalNotes: 'Lliurat',
    projectUrl: 'https://identitat4.com', dropboxUrl: 'https://dropbox.com/4',
  },
  {
    id: '5', code: '21/44567', title: 'Anunci televisiu', category: 'Audiovisual',
    payment: 'pending', material: 'warning',
    firstName: 'Laia', lastName: 'Font', email: 'laia@tv.cat',
    studio: 'TV Font', phone: '934567894', website: 'https://laiafont.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Pendent de pagament',
    projectUrl: 'https://spot5.com', dropboxUrl: 'https://dropbox.com/5',
  },
  {
    id: '6', code: '22/55678', title: 'Packaging producte', category: 'Packaging',
    payment: 'ok', material: 'ok',
    firstName: 'Carles', lastName: 'Mas', email: 'carles@pack.cat',
    studio: 'Pack Mas', phone: '934567895', website: 'https://carlesmas.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'A punt per enviar',
    projectUrl: 'https://pack6.com', dropboxUrl: 'https://dropbox.com/6',
  },
  {
    id: '7', code: '23/66789', title: 'Il·lustració editorial', category: 'Editorial',
    payment: 'issue', material: 'ok',
    firstName: 'Laura', lastName: 'Estrany', email: 'laura@illustra.cat',
    studio: "Il·lustra Laura", phone: '934567896', website: 'https://laura.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'Reclamació pendent',
    projectUrl: 'https://illustra7.com', dropboxUrl: 'https://dropbox.com/7',
  },
  {
    id: '8', code: '24/77890', title: 'Tipografia custom', category: 'Digital',
    payment: 'ok', material: 'warning',
    firstName: 'Gerard', lastName: 'Font', email: 'gerard@tipografia.com',
    studio: 'Tipografia Font', phone: '934567897', website: 'https://gerardfont.com',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Llicència per revisar',
    projectUrl: 'https://font8.com', dropboxUrl: 'https://dropbox.com/8',
  },
  {
    id: '9', code: '25/88901', title: 'Senyalització', category: 'Espai',
    payment: 'pending', material: 'issue',
    firstName: 'Cristina', lastName: 'Pla', email: 'cristina@senyal.cat',
    studio: 'Senyal Pla', phone: '934567898', website: 'https://cristinapla.cat',
    fadMember: false, associationMember: true, otherSubmissions: [],
    internalNotes: 'Material no rebut',
    projectUrl: 'https://senyal9.com', dropboxUrl: 'https://dropbox.com/9',
  },
  {
    id: '10', code: '26/99012', title: 'Aplicació mòbil', category: 'Digital',
    payment: 'ok', material: 'ok',
    firstName: 'Albert', lastName: 'Rius', email: 'albert@app.cat',
    studio: 'App Rius', phone: '934567899', website: 'https://albertrius.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Publicada',
    projectUrl: 'https://app10.com', dropboxUrl: 'https://dropbox.com/10',
  },
  {
    id: '11', code: '27/10123', title: 'Catàleg exposició', category: 'Editorial',
    payment: 'ok', material: 'ok',
    firstName: 'Núria', lastName: 'Valls', email: 'nuria@cataleg.cat',
    studio: 'Catàleg Valls', phone: '934567800', website: 'https://nuriavalls.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Enviat a impremta',
    projectUrl: 'https://cataleg11.com', dropboxUrl: 'https://dropbox.com/11',
  },
  {
    id: '12', code: '28/21234', title: 'Fotografia campanya', category: 'Fotografia',
    payment: 'pending', material: 'warning',
    firstName: 'Toni', lastName: 'Mir', email: 'toni@foto.cat',
    studio: 'Foto Mir', phone: '934567801', website: 'https://tonimir.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'Esperant selecció',
    projectUrl: 'https://foto12.com', dropboxUrl: 'https://dropbox.com/12',
  },
  {
    id: '13', code: '29/32345', title: 'Vídeo corporatiu', category: 'Audiovisual',
    payment: 'ok', material: 'issue',
    firstName: 'Sílvia', lastName: 'Grau', email: 'silvia@video.cat',
    studio: 'Video Grau', phone: '934567802', website: 'https://silviagrau.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Falta llicència música',
    projectUrl: 'https://video13.com', dropboxUrl: 'https://dropbox.com/13',
  },
  {
    id: '14', code: '30/43456', title: 'Eines de comunicació', category: 'Gràfic',
    payment: 'ok', material: 'ok',
    firstName: 'Oriol', lastName: 'Cases', email: 'oriol@eines.cat',
    studio: 'Eines Cases', phone: '934567803', website: 'https://oriolcases.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Material complet',
    projectUrl: 'https://eines14.com', dropboxUrl: 'https://dropbox.com/14',
  },
  {
    id: '15', code: '31/54567', title: "Instal·lació artística", category: 'Espai',
    payment: 'issue', material: 'ok',
    firstName: 'Mònica', lastName: 'Serra', email: 'monica@installacio.cat',
    studio: "Instal·lació Serra", phone: '934567804', website: 'https://monicaserra.cat',
    fadMember: false, associationMember: true, otherSubmissions: [],
    internalNotes: 'Esperant confirmació',
    projectUrl: 'https://installacio15.com', dropboxUrl: 'https://dropbox.com/15',
  },
  {
    id: '16', code: '32/65678', title: 'Disseny de producte', category: 'Producte',
    payment: 'pending', material: 'warning',
    firstName: 'Ramon', lastName: 'Coll', email: 'ramon@producte.cat',
    studio: 'Producte Coll', phone: '934567805', website: 'https://ramoncoll.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Prototip en revisió',
    projectUrl: 'https://producte16.com', dropboxUrl: 'https://dropbox.com/16',
  },
  {
    id: '17', code: '33/76789', title: "Interfície d'usuari", category: 'Digital',
    payment: 'ok', material: 'ok',
    firstName: 'Helena', lastName: 'Bosch', email: 'helena@ui.cat',
    studio: 'UI Bosch', phone: '934567806', website: 'https://helenabosch.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Entregat',
    projectUrl: 'https://ui17.com', dropboxUrl: 'https://dropbox.com/17',
  },
  {
    id: '18', code: '34/87890', title: 'Animació 2D', category: 'Audiovisual',
    payment: 'ok', material: 'issue',
    firstName: 'David', lastName: 'Parra', email: 'david@animacio.cat',
    studio: 'Animació Parra', phone: '934567807', website: 'https://davidparra.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'Revisar format',
    projectUrl: 'https://animacio18.com', dropboxUrl: 'https://dropbox.com/18',
  },
  {
    id: '19', code: '35/98901', title: "Llibre d'artista", category: 'Editorial',
    payment: 'pending', material: 'ok',
    firstName: 'Carme', lastName: 'Roca', email: 'carme@llibre.cat',
    studio: "Llibre Roca", phone: '934567808', website: 'https://carmeroca.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Pendent de distribució',
    projectUrl: 'https://llibre19.com', dropboxUrl: 'https://dropbox.com/19',
  },
  {
    id: '20', code: '36/09012', title: "Estratègia de marca", category: 'Branding',
    payment: 'ok', material: 'ok',
    firstName: 'Jordi', lastName: 'Solà', email: 'jordi@marca.cat',
    studio: 'Marca Solà', phone: '934567809', website: 'https://jordisola.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Complet',
    projectUrl: 'https://marca20.com', dropboxUrl: 'https://dropbox.com/20',
  },
]
'@


# =============================================================================
# 02  src\shared\layout\Footer\index.tsx  -  ENCODING FIX
# =============================================================================
Write-File 'src\shared\layout\Footer\index.tsx' @'
// src/shared/layout/Footer/index.tsx - v0.4.3b
import styles from './styles.module.css'

export function Footer() {
  return (
    <footer className={styles.footer}>
      made with <span style={{ color: '#e44' }}>&#9829;</span> by{' '}
      <a href="https://collapsecreative.com" target="_blank" rel="noopener noreferrer">
        collapsecreative
      </a>{' '}
      per Aina, Pao, Mireia, Eva i el GOAT.
    </footer>
  )
}
'@


# =============================================================================
# 03  src\shared\ui\ActivityLog\index.tsx  -  ENCODING FIX
# =============================================================================
Write-File 'src\shared\ui\ActivityLog\index.tsx' @'
// src/shared/ui/ActivityLog/index.tsx - v0.4.3b
import styles from './styles.module.css'

export const ActivityLog = () => {
  const entries = [
    { time: '10:32', user: 'Aina',   action: 'edici\u00f3 de camp "Pagament confirmat" a LAUS-0123' },
    { time: '10:15', user: 'Pao',    action: 'resoluci\u00f3 de discrepàn\u00e0cia, mantingut valor A' },
    { time: '09:47', user: 'Mireia', action: 'creaci\u00f3 de nova fila' },
  ]

  return (
    <div className={styles.log}>
      <h4 className={styles.title}>Activitat recent</h4>
      <ul className={styles.list}>
        {entries.map((e, i) => (
          <li key={i} className={styles.entry}>
            <span className={styles.time}>{e.time}</span>
            <span className={styles.user}>{e.user}</span>
            <span className={styles.action}>{e.action}</span>
          </li>
        ))}
      </ul>
    </div>
  )
}
'@


# =============================================================================
# 04  src\shared\ui\StatusBadge\styles.module.css  -  DARK-BG BADGE SYSTEM
# =============================================================================
Write-File 'src\shared\ui\StatusBadge\styles.module.css' @'
/* src/shared/ui/StatusBadge/styles.module.css - v0.4.3b
   Dark-background badge system. Colors from design brief.
   Light mode: dark bg + bright text for maximum visual punch.
   Dark mode: tokens (page is already dark, lighter treatment). */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 2px 6px;
  font-size: 8px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  border-radius: var(--radius);
  border: 1px solid;
  line-height: 1.3;
  white-space: nowrap;
}

/* Light mode - dark bg system */
.ok {
  background: #003400;
  color: #39F669;
  border-color: #39F669;
}
.warning {
  background: #2B0502;
  color: #FB9D04;
  border-color: #FB9D04;
}
.issue {
  background: #43091F;
  color: #E9486E;
  border-color: #E9486E;
}
.info {
  background: #001E36;
  color: #00A8EF;
  border-color: #00A8EF;
}
.neutral {
  background: var(--bg2);
  color: var(--text3);
  border-color: var(--border2);
}

/* Dark mode - use token values (page is already dark) */
[data-theme="dark"] .ok {
  background: var(--s-ok-bg);
  color: var(--s-ok);
  border-color: var(--s-ok);
}
[data-theme="dark"] .warning {
  background: var(--s-warn-bg);
  color: var(--s-warn);
  border-color: var(--s-warn);
}
[data-theme="dark"] .issue {
  background: var(--s-des-bg);
  color: var(--s-des);
  border-color: var(--s-des);
}
[data-theme="dark"] .info {
  background: var(--s-adj-bg);
  color: var(--s-adj);
  border-color: var(--s-adj);
}
'@


# =============================================================================
# 05  src\modules\submissions\components\Table\styles.module.css  -  SELECTED ROW
# =============================================================================
Write-File 'src\modules\submissions\components\Table\styles.module.css' @'
/* src/modules/submissions/components/Table/styles.module.css - v0.4.3b */
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.8rem;
}

.table th {
  text-align: left;
  padding: 0.5rem 0.75rem;
  background: var(--bg2);
  color: var(--text3);
  font-weight: 400;
  font-size: 0.65rem;
  text-transform: uppercase;
  letter-spacing: 0.14em;
  border-bottom: 1px solid var(--border2);
  white-space: nowrap;
  user-select: none;
}

.table td {
  padding: 0.45rem 0.75rem;
  border-bottom: 1px solid var(--border3);
  color: var(--text);
  white-space: nowrap;
  vertical-align: middle;
}

.table tbody tr:hover {
  background: var(--hover);
  cursor: pointer;
}

/* Selected row: system left-accent + subtle bg */
.table tbody tr.selected {
  background: var(--bg3);
  box-shadow: inset 3px 0 0 var(--text);
}

.table tbody tr.selected td {
  color: var(--text);
}

.checkboxCell {
  width: 2rem;
  text-align: center;
  padding-left: 0.75rem;
}

.codeCell {
  font-family: monospace;
  font-weight: 600;
  font-size: 0.75rem;
  color: var(--text2);
}
'@


# =============================================================================
# 06  Inspector\styles.module.css  -  VISUAL POLISH
#     - InfoColumn: new horizontal layout classes (infoRow/infoKey/infoVal)
#     - StatusBadges: dark-bg color system
#     - Tighter spacing throughout
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3b */

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
.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 160px;
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
  padding: 8px 8px 8px 13px;
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

/* Horizontal key-value rows (matches wireframe layout) */
.infoRow {
  display: flex;
  align-items: flex-start;
  gap: 5px;
  min-height: 26px;
  padding: 3px 0;
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
  padding-top: 4px;
}

.infoVal {
  flex: 1;
  font-size: 10px;
  color: var(--text);
  padding: 3px 6px;
  background: var(--bg2);
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  min-width: 0;
  word-break: break-word;
  line-height: 1.35;
}

/* ContactColumn ------------------------------------------------------------ */
.contactCol {
  padding: 8px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.contactBlock {
  display: flex;
  flex-direction: column;
  margin-bottom: 6px;
  padding-bottom: 6px;
  border-bottom: 1px solid var(--border3);
}
.contactBlock:last-of-type {
  border-bottom: none;
  margin-bottom: 0;
}

.contactField {
  display: flex;
  align-items: center;
  gap: 4px;
  min-height: 22px;
  border-bottom: 1px solid var(--border3);
}
.contactField:last-child { border-bottom: none; }

.cfLabel {
  font-size: 7px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text3);
  width: 62px;
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

/* All links inside inspector: neutral color, no browser blue */
.cfVal a {
  color: var(--text2);
  text-decoration: none;
  border-bottom: 1px solid var(--border2);
}
.cfVal a:hover {
  color: var(--text);
  border-bottom-color: var(--text);
}

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

/* ALTRES INSCRIPCIONS compact chip grid */
.altresSection { margin-top: 4px; }

.altresLabel {
  font-size: 7px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text3);
  margin-bottom: 4px;
  display: block;
}

.altresGrid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2px;
}

.codeBadge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 2px;
  font-size: 7.5px;
  letter-spacing: 0.02em;
  padding: 2px 3px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  color: var(--text3);
  cursor: pointer;
  transition: all 0.08s;
  font-family: monospace;
  white-space: nowrap;
}
.codeBadge:hover {
  border-color: var(--border);
  background: var(--bg3);
  color: var(--text);
}

/* StatusColumn ------------------------------------------------------------- */
.statusCol {
  padding: 8px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.statusRow {
  display: flex;
  flex-direction: column;
  gap: 3px;
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

/* Status click badges - dark bg system matching StatusBadge */
.statusClickBadge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 3px 8px;
  border: 1px solid;
  border-radius: var(--radius);
  cursor: pointer;
  background: none;
  transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }

/* Dark-bg variants - same color system as StatusBadge */
.statusClickBadge.ok {
  background: #003400;
  color: #39F669;
  border-color: #39F669;
}
.statusClickBadge.warn {
  background: #2B0502;
  color: #FB9D04;
  border-color: #FB9D04;
}
.statusClickBadge.issue {
  background: #43091F;
  color: #E9486E;
  border-color: #E9486E;
}

/* Dark mode overrides for status click badges */
[data-theme="dark"] .statusClickBadge.ok {
  background: var(--s-ok-bg);
  color: var(--s-ok);
  border-color: var(--s-ok);
}
[data-theme="dark"] .statusClickBadge.warn {
  background: var(--s-warn-bg);
  color: var(--s-warn);
  border-color: var(--s-warn);
}
[data-theme="dark"] .statusClickBadge.issue {
  background: var(--s-des-bg);
  color: var(--s-des);
  border-color: var(--s-des);
}

.statusDropdown {
  position: absolute;
  top: calc(100% + 2px);
  left: 0;
  z-index: 50;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: 0 2px 10px rgba(0,0,0,.15);
  min-width: 110px;
  overflow: hidden;
}

.statusDropdownItem {
  display: block;
  width: 100%;
  padding: 6px 10px;
  text-align: left;
  font-size: 8px;
  font-weight: 700;
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
  gap: 5px;
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
  min-width: 36px;
  justify-content: center;
}
.toggleBtn.toggled {
  background: #003400;
  color: #39F669;
  border-color: #39F669;
}
[data-theme="dark"] .toggleBtn.toggled {
  background: var(--s-ok-bg);
  color: var(--s-ok);
  border-color: var(--s-ok);
}

.premioSelect {
  width: 100%;
  padding: 4px 22px 4px 6px;
  font-size: 9px;
  letter-spacing: 0.03em;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: var(--bg2);
  color: var(--text2);
  cursor: pointer;
  appearance: none;
  outline: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='4'%3E%3Cpath d='M0 0l4 4 4-4z' fill='%23999'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 6px center;
}
.premioSelect:focus {
  border-color: var(--border);
  color: var(--text);
  background-color: var(--bg);
}

/* LinksRow (lower-left) ---------------------------------------------------- */
.linksRow {
  flex: 1;
  padding: 8px;
  border-right: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  gap: 6px;
  overflow-y: auto;
}

.linksSection {
  display: flex;
  flex-direction: column;
  gap: 3px;
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

/* Link anchors: neutral color, never browser-default blue */
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
.linkAnchor:hover {
  color: var(--text);
  border-bottom-color: var(--text);
}

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
  min-height: 56px;
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
  flex: 0 0 120px;
  padding: 8px 7px;
  display: flex;
  flex-direction: column;
  gap: 3px;
  background: var(--bg2);
  border-left: 1px solid var(--border2);
}

.actionBtn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  width: 100%;
  height: 26px;
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.1em;
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
  background: #003400;
  color: #39F669;
  border-color: #39F669;
}

.actionDescartar {
  background: #2B0502;
  color: #FB9D04;
  border-color: #FB9D04;
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
  background: #43091F;
  color: #E9486E;
  border-color: #E9486E;
}

/* Dark mode: action buttons use token values */
[data-theme="dark"] .actionDesa {
  background: var(--s-ok-bg);
  color: var(--s-ok);
  border-color: var(--s-ok);
}
[data-theme="dark"] .actionDescartar {
  background: var(--s-warn-bg);
  color: var(--s-warn);
  border-color: var(--s-warn);
}
[data-theme="dark"] .actionEliminar {
  background: var(--s-des-bg);
  color: var(--s-des);
  border-color: var(--s-des);
}
'@


# =============================================================================
# 07  Inspector\InfoColumn.tsx  -  HORIZONTAL LAYOUT (wireframe-exact)
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\InfoColumn.tsx' @'
// Inspector/InfoColumn.tsx - v0.4.3b
// Col 1: blue left-border, horizontal key|value rows, multiple CATEGORIA rows.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function InfoColumn({ submission }: Props) {
  const categories = submission.category
    .split(',')
    .map(c => c.trim())
    .filter(Boolean)

  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>Informaci\u00f3 general</span>

      <div className={styles.infoRow}>
        <div className={styles.infoKey}>Codi</div>
        <div className={styles.infoVal}>{submission.code}</div>
      </div>

      <div className={styles.infoRow}>
        <div className={styles.infoKey}>T\u00edtol</div>
        <div className={styles.infoVal}>{submission.title}</div>
      </div>

      {categories.map((cat, i) => (
        <div key={`cat-${i}`} className={styles.infoRow}>
          <div className={styles.infoKey}>Categoria</div>
          <div className={styles.infoVal}>{cat}</div>
        </div>
      ))}
    </div>
  )
}
'@


# =============================================================================
# 08  Inspector\ContactColumn.tsx  -  LABELS WITH PROPER ACCENTS
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\ContactColumn.tsx' @'
// Inspector/ContactColumn.tsx - v0.4.3b
// Col 2: two contact blocks + ALTRES INSCRIPCIONS compact chip grid.
// Clicking a badge navigates to that record in-place - no remount.
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
      <button className={styles.editBtn} aria-label="Edita">
        <i className="bi bi-pencil" aria-hidden="true"></i>
      </button>
    </div>
  )
}

export function ContactColumn({ submission, onSelectId }: Props) {
  return (
    <div className={styles.contactCol}>
      <span className={styles.colLabel}>Contacte</span>

      {/* Primary block */}
      <div className={styles.contactBlock}>
        <CField label="Nom"       value={submission.firstName} />
        <CField label="Email"     value={submission.email} />
        <CField label="Tel\u00e8fon"  value={submission.phone ?? ''} />
        <CField label="Soci FAD"  value={submission.fadMember ? 'S\u00ed' : 'No'} />
      </div>

      {/* Secondary block */}
      <div className={styles.contactBlock}>
        <CField label="Cognom"    value={submission.lastName} />
        <CField label="Estudi"    value={submission.studio} />
        <CField label="Web"       value={submission.website ?? ''} />
        <CField label="Altres"    value={submission.associationMember ? 'S\u00ed' : 'No'} />
      </div>

      {/* ALTRES INSCRIPCIONS: compact 3-col chip grid.
          Clicking navigates in-place - inspector does not remount. */}
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
                  title={`Obre ${code}`}
                >
                  <i className="bi bi-arrow-right-short" style={{ fontSize: '9px' }} aria-hidden="true"></i>
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
# 09  Inspector\StatusColumn.tsx  -  LABELS + DARK-BG BADGE CONSISTENCY
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\StatusColumn.tsx' @'
// Inspector/StatusColumn.tsx - v0.4.3b
// Col 3: PAGAMENT/MATERIAL click-to-dropdown (dark-bg badges),
//        PREMIAT toggle, PREMIO selector.
// Workflow-only state. No write-back to RawSubmission (v0.4.3c).
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

const badgeClass = (val: PaymentVal | MaterialVal): string => {
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
            <i className="bi bi-chevron-down" style={{ fontSize: '6px' }} aria-hidden="true"></i>
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
            <i className="bi bi-chevron-down" style={{ fontSize: '6px' }} aria-hidden="true"></i>
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

      {/* PREMIAT - workflow flag */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Premiat</span>
        <div className={styles.premiadoRow}>
          <button
            className={`${styles.toggleBtn} ${premiado ? styles.toggled : ''}`}
            onClick={() => setPremiado(!premiado)}
          >
            {premiado ? 'S\u00ed' : 'No'}
          </button>
        </div>
      </div>

      {/* PREMIO - visible only when premiado */}
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
# 10  Inspector\LinksRow.tsx  -  FIXED LABELS
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\LinksRow.tsx' @'
// Inspector/LinksRow.tsx - v0.4.3b
// Lower-left: Enlla\u00e7os (Dropbox + Projecte with pencil) + Notes internes textarea.
// Links use neutral color, never browser-default blue.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  return (
    <div className={styles.linksRow}>

      <div className={styles.linksSection}>
        <span className={styles.colLabel}>Enlla\u00e7os</span>

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
            <button className={styles.editBtn} aria-label="Edita">
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
            <button className={styles.editBtn} aria-label="Edita">
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
# 11  src\modules\submissions\Submissions.module.css  -  KPI STRIP
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* src/modules/submissions/Submissions.module.css - v0.4.3b */

.submissions {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--bg);
  overflow: hidden;
}

/* KPI strip - ADG licitaciones stats-strip style */
.kpiStrip {
  display: flex;
  align-items: stretch;
  background: var(--bg2);
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  overflow-x: auto;
  scrollbar-width: none;
}
.kpiStrip::-webkit-scrollbar { display: none; }

.kpi {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 16px;
  min-height: 30px;
  border-right: 1px solid var(--border2);
  flex-shrink: 0;
}
.kpi:last-child {
  border-right: none;
  margin-left: auto;
}

.kpiVal {
  font-size: 16px;
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
  margin-top: 1px;
}

.kpiWarn { color: var(--s-warn); }
.kpiOk   { color: var(--s-ok); }
.kpiDes  { color: var(--s-des); }

/* Main split: table left + inspector right */
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
# 12  src\modules\submissions\index.tsx  -  KPI STRIP RESTORED
# =============================================================================
Write-File 'src\modules\submissions\index.tsx' @'
// src/modules/submissions/index.tsx - v0.4.3b
// KPI strip restored. Inspector wired in place of old detailPanel.
import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { Inspector } from './components/Inspector'
import { mockSubmissions } from './mockData'
import styles from './Submissions.module.css'

// Local KPI computation - static from mockData for now, no store needed
const kpis = {
  total:           mockSubmissions.length,
  pendingPayment:  mockSubmissions.filter(s => s.payment !== 'ok').length,
  pendingMaterial: mockSubmissions.filter(s => s.material !== 'ok').length,
  noAward:         7, // placeholder - wired to award tracking in v0.4.3c
}

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail,   setShowDetail]   = useState(false)
  const [detailId,     setDetailId]     = useState<string | null>(null)
  const [studentsOnly, setStudentsOnly] = useState(false)

  const handleRowClick = (id: string) => {
    setDetailId(id)
    setShowDetail(true)
  }

  // Navigate linked record in inspector without remounting it
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

      {/* KPI Strip */}
      <div className={styles.kpiStrip}>
        <div className={styles.kpi}>
          <span className={styles.kpiVal}>{kpis.total}</span>
          <span className={styles.kpiLbl}>Total</span>
        </div>
        <div className={styles.kpi}>
          <span className={`${styles.kpiVal} ${kpis.pendingPayment > 0 ? styles.kpiWarn : styles.kpiOk}`}>
            {kpis.pendingPayment}
          </span>
          <span className={styles.kpiLbl}>Pagament pendent</span>
        </div>
        <div className={styles.kpi}>
          <span className={`${styles.kpiVal} ${kpis.pendingMaterial > 0 ? styles.kpiWarn : styles.kpiOk}`}>
            {kpis.pendingMaterial}
          </span>
          <span className={styles.kpiLbl}>Material pendent</span>
        </div>
        <div className={styles.kpi}>
          <span className={styles.kpiVal}>{kpis.noAward}</span>
          <span className={styles.kpiLbl}>Sense premi</span>
        </div>
      </div>

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
          <Button variant="icon" disabled={selectedRows.length === 0} title="Duplicate selected">
            <i className="bi bi-files"></i>
          </Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Delete selected">
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
            title={studentsOnly ? 'Mostra tots' : 'Estudiants'}
            onClick={() => setStudentsOnly(!studentsOnly)}
            className={studentsOnly ? styles.activeToggle : ''}
          >
            <i className="bi bi-person-square"></i>
          </Button>
        </div>
      </div>

      {/* Main area: table + inspector */}
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
Write-Host "patch v0.4.3b complete - 12 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  mockData.ts         All 20 entries: UTF-8 encoding fixed" -ForegroundColor DarkGray
Write-Host "  Footer              Heart glyph fixed via HTML entity" -ForegroundColor DarkGray
Write-Host "  ActivityLog         Mock entries: encoding fixed" -ForegroundColor DarkGray
Write-Host "  StatusBadge         Dark-bg badge system (#003400/#39F669 etc.)" -ForegroundColor DarkGray
Write-Host "  Table/styles        Selected row: system bg3 + left accent" -ForegroundColor DarkGray
Write-Host "  Inspector/styles    InfoColumn horizontal layout, dark-bg badges," -ForegroundColor DarkGray
Write-Host "                      neutral link colors, tighter spacing" -ForegroundColor DarkGray
Write-Host "  InfoColumn          Horizontal key|value rows (wireframe-exact)" -ForegroundColor DarkGray
Write-Host "  ContactColumn       Proper accented labels, Si fix" -ForegroundColor DarkGray
Write-Host "  StatusColumn        Badge class names aligned to dark-bg CSS" -ForegroundColor DarkGray
Write-Host "  LinksRow            Enlla\u00e7os label fixed" -ForegroundColor DarkGray
Write-Host "  Submissions.css     KPI strip styles (ADG stats-strip style)" -ForegroundColor DarkGray
Write-Host "  submissions/index   KPI strip restored above toolbar" -ForegroundColor DarkGray
Write-Host ""
