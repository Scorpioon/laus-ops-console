#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3c - Fidelity + Spreadsheet Simulation
#
# Save as UTF-8 before running.
# Run from the project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3c-fidelity-spreadsheet-pass.ps1
#
# Files (13):
#   src\modules\submissions\mockData.ts                   CANONICAL FIELDS
#   src\modules\submissions\components\Table\index.tsx    CANONICAL COLUMNS + SORT
#   src\modules\submissions\components\Table\styles.module.css  SPREADSHEET FEEL
#   src\modules\submissions\components\Inspector\styles.module.css  BREATHING + C4/C5
#   src\modules\submissions\components\Inspector\InfoColumn.tsx    ENGLISH + INLINE EDIT
#   src\modules\submissions\components\Inspector\ContactColumn.tsx ENGLISH
#   src\modules\submissions\components\Inspector\StatusColumn.tsx  ENGLISH + DIGITAL MAT
#   src\modules\submissions\components\Inspector\LinksRow.tsx      ENGLISH
#   src\modules\submissions\components\Inspector\ActionStack.tsx   ENGLISH
#   src\modules\submissions\Submissions.module.css        BREATHING ROOM
#   src\modules\submissions\index.tsx                     ENGLISH KPIs
#   src\shared\layout\TopBar\index.tsx                    REMOVE EMPTY SEPARATORS
#   src\shared\layout\TopBar\styles.module.css            36PX + BREATHING
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
Write-Host "LAUS OPS CONSOLE - patch v0.4.3c" -ForegroundColor Cyan
Write-Host "Fidelity + Spreadsheet Simulation" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  src\modules\submissions\mockData.ts
#     All 23 canonical fields mapped, 20 complete entries, clean UTF-8.
# =============================================================================
Write-File 'src\modules\submissions\mockData.ts' @'
// src/modules/submissions/mockData.ts - v0.4.3c
// Full canonical spreadsheet simulation. 23 fields per submission.

export interface MockSubmission {
  // -- Core identity --
  id: string
  ordre: number              // Ordre inscripcio
  code: string               // Inscripcion
  title: string              // Titulo
  category: string           // Categoria
  platform?: string          // Plataforma
  // -- Materials --
  material: 'ok' | 'warning' | 'issue'  // Material fisico recibido
  physicalMatDesc?: string               // Descripcio material fisic
  digitalMat?: 'ok' | 'warning' | 'issue'  // Material digital recibido
  digitalMatDesc?: string                   // Descripcio material digital
  // -- Project --
  projectUrl?: string        // URL proyecto
  dropboxUrl?: string        // Link Dropbox
  returnMaterial?: boolean   // Retorn de material
  projectSelected?: boolean  // Proyecto seleccionado
  award?: string             // Premio (canonical)
  // -- Contact --
  firstName: string          // Nombre
  lastName: string           // Apellidos
  email: string              // Email
  phone?: string             // Telefono
  studio?: string            // studio / agency (derived context)
  website?: string           // website
  fadMember: boolean         // Miembro FAD
  associationMember: boolean // Miembro otras assoc.
  // -- Payment --
  payment: 'ok' | 'pending' | 'issue'  // Pago confirmado
  price?: string             // Precio inscripcion
  year: number               // Anno
  // -- UI helpers --
  otherSubmissions: string[]
  internalNotes?: string
}

export const mockSubmissions: MockSubmission[] = [
  {
    id:'1', ordre:1, code:'17/64795', title:'Disseny exposici\u00f3', category:'Branding',
    platform:'Impremta', material:'warning', physicalMatDesc:'Rollup 200\u00d780cm',
    digitalMat:'ok', digitalMatDesc:'PDF alta qualitat',
    projectUrl:'https://projecte1.com', dropboxUrl:'https://dropbox.com/1',
    returnMaterial:false, projectSelected:true, award:'',
    firstName:'Anna', lastName:'Puig', email:'anna@estudi.com',
    studio:'Estudi Anna Puig', phone:'934567890', website:'https://annapuig.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:['18/02341','20/33456'],
    internalNotes:"Pendent d'aprovaci\u00f3 final",
  },
  {
    id:'2', ordre:2, code:'18/02341', title:'Campanya gr\u00e0fica', category:'Publicitat',
    platform:'Impremta', material:'ok', physicalMatDesc:'3 p\u00f2sters A1',
    digitalMat:'ok', digitalMatDesc:'Arxius InDesign',
    projectUrl:'https://campanya2.com', dropboxUrl:'https://dropbox.com/2',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Joan', lastName:'Vidal', email:'joan@agencia.cat',
    studio:'Agencia Vidal', phone:'934567891', website:'https://vidal.cat',
    fadMember:false, associationMember:true,
    payment:'pending', price:'145', year:2024,
    otherSubmissions:['17/64795'],
    internalNotes:'Revis\u00ed\u00f3 de proofs',
  },
  {
    id:'3', ordre:3, code:'19/11223', title:'Web corporativa', category:'Digital',
    platform:'Web', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'Fitxers incomplets',
    projectUrl:'https://web3.com', dropboxUrl:'https://dropbox.com/3',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Marta', lastName:'Soler', email:'marta@web.cat',
    studio:'Web Soler', phone:'934567892', website:'https://marta.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Falten continguts',
  },
  {
    id:'4', ordre:4, code:'20/33456', title:'Identitat visual', category:'Branding',
    platform:'Impremta', material:'ok', physicalMatDesc:'Manual de marca + aplicacions',
    digitalMat:'ok', digitalMatDesc:'Guies editables AI/PDF',
    projectUrl:'https://identitat4.com', dropboxUrl:'https://dropbox.com/4',
    returnMaterial:true, projectSelected:true, award:'inBook',
    firstName:'Pau', lastName:'Roca', email:'pau@estudi.com',
    studio:'Estudi Roca', phone:'934567893', website:'https://pauroca.com',
    fadMember:false, associationMember:false,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:['17/64795'],
    internalNotes:'Lliurat. inBook 2024.',
  },
  {
    id:'5', ordre:5, code:'21/44567', title:'Anunci televisiu', category:'Audiovisual',
    platform:'Audiovisual', material:'warning', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'V\u00eddeo pendent de masteritzar',
    projectUrl:'https://spot5.com', dropboxUrl:'https://dropbox.com/5',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Laia', lastName:'Font', email:'laia@tv.cat',
    studio:'TV Font', phone:'934567894', website:'https://laiafont.cat',
    fadMember:true, associationMember:false,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Pendent de pagament',
  },
  {
    id:'6', ordre:6, code:'22/55678', title:'Packaging producte', category:'Packaging',
    platform:'Impremta', material:'ok', physicalMatDesc:'5 unitats + mostra material',
    digitalMat:'ok', digitalMatDesc:'Fitxers de producci\u00f3',
    projectUrl:'https://pack6.com', dropboxUrl:'https://dropbox.com/6',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Carles', lastName:'Mas', email:'carles@pack.cat',
    studio:'Pack Mas', phone:'934567895', website:'https://carlesmas.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'A punt per enviar',
  },
  {
    id:'7', ordre:7, code:'23/66789', title:'Il\u00b7lustraci\u00f3 editorial', category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'Llibre original + reproductions',
    digitalMat:'ok', digitalMatDesc:'Alta resoluci\u00f3 300dpi',
    projectUrl:'https://illustra7.com', dropboxUrl:'https://dropbox.com/7',
    returnMaterial:true, projectSelected:true, award:'Bronce',
    firstName:'Laura', lastName:'Estrany', email:'laura@illustra.cat',
    studio:"Il\u00b7lustra Laura", phone:'934567896', website:'https://laura.cat',
    fadMember:false, associationMember:false,
    payment:'issue', price:'145', year:2024,
    otherSubmissions:[],
    internalNotes:'Reclamaci\u00f3 pendent. Premi bronce confirmat.',
  },
  {
    id:'8', ordre:8, code:'24/77890', title:'Tipografia custom', category:'Digital',
    platform:'Web', material:'warning', physicalMatDesc:'Specimen impr\u00e8s A5',
    digitalMat:'ok', digitalMatDesc:'Font files OTF/TTF + specimen PDF',
    projectUrl:'https://font8.com', dropboxUrl:'https://dropbox.com/8',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Gerard', lastName:'Font', email:'gerard@tipografia.com',
    studio:'Tipografia Font', phone:'934567897', website:'https://gerardfont.com',
    fadMember:true, associationMember:true,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Llic\u00e8ncia per revisar',
  },
  {
    id:'9', ordre:9, code:'25/88901', title:'Senyalitzaci\u00f3', category:'Espai',
    platform:'Espai', material:'issue', physicalMatDesc:'Material no rebut',
    digitalMat:'issue', digitalMatDesc:'Fitxers no enviats',
    projectUrl:'https://senyal9.com', dropboxUrl:'https://dropbox.com/9',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Cristina', lastName:'Pla', email:'cristina@senyal.cat',
    studio:'Senyal Pla', phone:'934567898', website:'https://cristinapla.cat',
    fadMember:false, associationMember:true,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Material no rebut',
  },
  {
    id:'10', ordre:10, code:'26/99012', title:'Aplicaci\u00f3 m\u00f2bil', category:'Digital',
    platform:'Digital', material:'ok', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'APK + captures de pantalla',
    projectUrl:'https://app10.com', dropboxUrl:'https://dropbox.com/10',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Albert', lastName:'Rius', email:'albert@app.cat',
    studio:'App Rius', phone:'934567899', website:'https://albertrius.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Publicada',
  },
  {
    id:'11', ordre:11, code:'27/10123', title:'Cat\u00e0leg exposici\u00f3', category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'2 cat\u00e0legs + dossier premsa',
    digitalMat:'ok', digitalMatDesc:'InDesign + PDF impremta',
    projectUrl:'https://cataleg11.com', dropboxUrl:'https://dropbox.com/11',
    returnMaterial:true, projectSelected:true, award:'Plata',
    firstName:'N\u00faria', lastName:'Valls', email:'nuria@cataleg.cat',
    studio:'Cat\u00e0leg Valls', phone:'934567800', website:'https://nuriavalls.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Enviat a impremta. Plata 2024.',
  },
  {
    id:'12', ordre:12, code:'28/21234', title:'Fotografia campanya', category:'Fotografia',
    platform:'Digital', material:'warning', physicalMatDesc:'Proofs pendent',
    digitalMat:'warning', digitalMatDesc:'Arxius RAW pendent de selecci\u00f3',
    projectUrl:'https://foto12.com', dropboxUrl:'https://dropbox.com/12',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Toni', lastName:'Mir', email:'toni@foto.cat',
    studio:'Foto Mir', phone:'934567801', website:'https://tonimir.cat',
    fadMember:false, associationMember:false,
    payment:'pending', price:'145', year:2023,
    otherSubmissions:[],
    internalNotes:'Esperant selecci\u00f3',
  },
  {
    id:'13', ordre:13, code:'29/32345', title:'V\u00eddeo corporatiu', category:'Audiovisual',
    platform:'Audiovisual', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'ProRes 4K + subtitles',
    projectUrl:'https://video13.com', dropboxUrl:'https://dropbox.com/13',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'S\u00edlvia', lastName:'Grau', email:'silvia@video.cat',
    studio:'Video Grau', phone:'934567802', website:'https://silviagrau.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Falta llic\u00e8ncia m\u00fasica',
  },
  {
    id:'14', ordre:14, code:'30/43456', title:'Eines de comunicaci\u00f3', category:'Gr\u00e0fic',
    platform:'Impremta', material:'ok', physicalMatDesc:'Carpeta amb set de peces',
    digitalMat:'ok', digitalMatDesc:'Arxius editorials complets',
    projectUrl:'https://eines14.com', dropboxUrl:'https://dropbox.com/14',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Oriol', lastName:'Cases', email:'oriol@eines.cat',
    studio:'Eines Cases', phone:'934567803', website:'https://oriolcases.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Material complet',
  },
  {
    id:'15', ordre:15, code:'31/54567', title:"Instal\u00b7laci\u00f3 art\u00edstica", category:'Espai',
    platform:'Espai', material:'ok', physicalMatDesc:'Documentaci\u00f3 t\u00e8cnica + maqueta',
    digitalMat:'ok', digitalMatDesc:'V\u00eddeo documentaci\u00f3 + plantes',
    projectUrl:'https://installacio15.com', dropboxUrl:'https://dropbox.com/15',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'M\u00f2nica', lastName:'Serra', email:'monica@installacio.cat',
    studio:"Instal\u00b7laci\u00f3 Serra", phone:'934567804', website:'https://monicaserra.cat',
    fadMember:false, associationMember:true,
    payment:'issue', price:'545', year:2025,
    otherSubmissions:[],
    internalNotes:'Esperant confirmaci\u00f3',
  },
  {
    id:'16', ordre:16, code:'32/65678', title:'Disseny de producte', category:'Producte',
    platform:'Producte', material:'warning', physicalMatDesc:'Prototip en revisi\u00f3',
    digitalMat:'ok', digitalMatDesc:'CAD + renders 3D',
    projectUrl:'https://producte16.com', dropboxUrl:'https://dropbox.com/16',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Ramon', lastName:'Coll', email:'ramon@producte.cat',
    studio:'Producte Coll', phone:'934567805', website:'https://ramoncoll.cat',
    fadMember:true, associationMember:false,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Prototip en revisi\u00f3',
  },
  {
    id:'17', ordre:17, code:'33/76789', title:"Interf\u00edcie d'usuari", category:'Digital',
    platform:'Web', material:'ok', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'Figma + prototip interactiu',
    projectUrl:'https://ui17.com', dropboxUrl:'https://dropbox.com/17',
    returnMaterial:true, projectSelected:true, award:'Grand Laus',
    firstName:'Helena', lastName:'Bosch', email:'helena@ui.cat',
    studio:'UI Bosch', phone:'934567806', website:'https://helenabosch.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Grand Laus 2024.',
  },
  {
    id:'18', ordre:18, code:'34/87890', title:'Animaci\u00f3 2D', category:'Audiovisual',
    platform:'Audiovisual', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'Format incorrecte, pendent',
    projectUrl:'https://animacio18.com', dropboxUrl:'https://dropbox.com/18',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'David', lastName:'Parra', email:'david@animacio.cat',
    studio:'Animaci\u00f3 Parra', phone:'934567807', website:'https://davidparra.cat',
    fadMember:false, associationMember:false,
    payment:'ok', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Revisar format',
  },
  {
    id:'19', ordre:19, code:'35/98901', title:"Llibre d'artista", category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'Exemplar original + CD',
    digitalMat:'ok', digitalMatDesc:'PDF editorial + imatges',
    projectUrl:'https://llibre19.com', dropboxUrl:'https://dropbox.com/19',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Carme', lastName:'Roca', email:'carme@llibre.cat',
    studio:"Llibre Roca", phone:'934567808', website:'https://carmeroca.cat',
    fadMember:true, associationMember:true,
    payment:'pending', price:'195', year:2023,
    otherSubmissions:[],
    internalNotes:'Pendent de distribuci\u00f3',
  },
  {
    id:'20', ordre:20, code:'36/09012', title:"Estrat\u00e8gia de marca", category:'Branding',
    platform:'Digital', material:'ok', physicalMatDesc:'Dossier estratègic impr\u00e8s',
    digitalMat:'ok', digitalMatDesc:'Presentaci\u00f3 + manuals PDF',
    projectUrl:'https://marca20.com', dropboxUrl:'https://dropbox.com/20',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Jordi', lastName:'Sol\u00e0', email:'jordi@marca.cat',
    studio:'Marca Sol\u00e0', phone:'934567809', website:'https://jordisola.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Complet',
  },
]
'@


# =============================================================================
# 02  src\modules\submissions\components\Table\index.tsx
#     Canonical columns: # | Code | Title | Category | Platform | Payment |
#     Material | Award | Year. Real sort. Horizontal scroll on narrow view.
# =============================================================================
Write-File 'src\modules\submissions\components\Table\index.tsx' @'
// Table/index.tsx - v0.4.3c
// Canonical spreadsheet column simulation.
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

const SORTABLE = ['ordre', 'code', 'title', 'category', 'platform', 'payment', 'year']

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
      default:         return 0
    }
  })
}

function SortArrow({ col, sort }: { col: string; sort: Sort }) {
  if (sort.col !== col || !sort.dir) return <span className={styles.sortNull}>&#8597;</span>
  return <span className={styles.sortArrow}>{sort.dir === 'asc' ? '\u2191' : '\u2193'}</span>
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

  const th = (col: string, label: string, align?: string) => (
    <th
      className={`${styles.th} ${SORTABLE.includes(col) ? styles.sortable : ''} ${sort.col === col ? styles.sorted : ''}`}
      style={align ? { textAlign: align as any } : undefined}
      onClick={SORTABLE.includes(col) ? () => toggleSort(col) : undefined}
    >
      {label}{SORTABLE.includes(col) && <SortArrow col={col} sort={sort} />}
    </th>
  )

  return (
    <table className={styles.table}>
      <thead>
        <tr>
          <th className={styles.cbCell}>
            <input type="checkbox" checked={allSelected} onChange={e => toggleAll(e.target.checked)} />
          </th>
          {th('ordre',    '#',         'right')}
          {th('code',     'Code')}
          {th('title',    'Title')}
          {th('category', 'Category')}
          {th('platform', 'Platform')}
          {th('payment',  'Payment')}
          <th className={styles.th}>Material</th>
          <th className={styles.th}>Award</th>
          {th('year',     'Year',      'right')}
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
              <td className={styles.platCell}>{row.platform ?? '\u2014'}</td>
              <td>
                <StatusBadge status={row.payment === 'ok' ? 'ok' : row.payment === 'pending' ? 'warning' : 'issue'}>
                  {row.payment === 'ok' ? 'Confirmed' : row.payment === 'pending' ? 'Pending' : 'Error'}
                </StatusBadge>
              </td>
              <td>
                <StatusBadge status={row.material === 'ok' ? 'ok' : row.material === 'warning' ? 'warning' : 'issue'}>
                  {row.material === 'ok' ? 'Received' : row.material === 'warning' ? 'Pending' : 'Missing'}
                </StatusBadge>
              </td>
              <td className={styles.awardCell}>
                {row.award
                  ? <span className={styles.awardChip}>{row.award}</span>
                  : <span className={styles.awardNone}>\u2014</span>
                }
              </td>
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
# 03  src\modules\submissions\components\Table\styles.module.css
# =============================================================================
Write-File 'src\modules\submissions\components\Table\styles.module.css' @'
/* Table/styles.module.css - v0.4.3c - spreadsheet simulation */
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: 11.5px;
  table-layout: auto;
}

.th {
  position: sticky;
  top: 0;
  z-index: 2;
  text-align: left;
  padding: 6px 9px;
  background: var(--bg2);
  color: var(--text3);
  font-weight: 400;
  font-size: 7.5px;
  text-transform: uppercase;
  letter-spacing: 0.14em;
  border-bottom: 1px solid var(--border2);
  white-space: nowrap;
  user-select: none;
}

.sortable { cursor: pointer; }
.sortable:hover { color: var(--text2); }
.sorted { color: var(--text); }

.sortNull { margin-left: 3px; opacity: 0.3; font-style: normal; }
.sortArrow { margin-left: 3px; font-style: normal; }

.table td {
  padding: 7px 9px;
  border-bottom: 1px solid var(--border3);
  color: var(--text);
  vertical-align: middle;
  white-space: nowrap;
}

.row { cursor: pointer; transition: background 0.06s; }
.row:hover { background: var(--hover); }
.row.selected {
  background: var(--bg3);
  box-shadow: inset 3px 0 0 var(--text);
}
.row.selected td { color: var(--text); }

/* Column widths */
.cbCell    { width: 30px; text-align: center; padding: 0 8px; }
.ordreCell { width: 36px; text-align: right; color: var(--text3); font-size: 10px; }
.codeCell  { width: 72px; font-family: monospace; font-size: 11px; font-weight: 600; color: var(--text2); }
.titleCell { min-width: 180px; max-width: 320px; overflow: hidden; text-overflow: ellipsis; }
.catCell   { width: 90px; font-size: 11px; }
.platCell  { width: 80px; font-size: 11px; color: var(--text2); }
.yearCell  { width: 50px; text-align: right; color: var(--text3); font-size: 10px; }

.awardCell { width: 80px; }
.awardChip {
  display: inline-flex;
  align-items: center;
  font-size: 7.5px;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  padding: 2px 5px;
  border-radius: var(--radius);
  background: #01005D;
  color: #9694F4;
  border: 1px solid #9694F4;
}
.awardNone { color: var(--text3); font-size: 10px; }
'@


# =============================================================================
# 04  src\modules\submissions\components\Inspector\styles.module.css
#     - More breathing room throughout
#     - Row 2: linksRow(flex:2) + actionStack(flex:1) - proportional to upper 3-col
#     - Inline edit button inside infoVal box
#     - Form boxes taller (min-height: 26px)
#     - No blue left bar (was misinterpreted wireframe annotation)
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3c */

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

/* Row 1: 3-column upper grid ----------------------------------------------- */
.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  min-height: 190px;
}

/* Row 2: proportional 2/3 + 1/3 match upper grid --------------------------- */
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

/* InfoColumn --------------------------------------------------------------- */
.infoCol {
  padding: 12px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

/* Horizontal key|value rows */
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

/* Form box: hosts value text + inline edit pencil */
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
.infoVal:hover { border-color: var(--border2); }

.infoValText {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.3;
}

/* Inline edit pencil inside the form box */
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

/* Static / readonly info value */
.infoValStatic {
  flex: 1;
  font-size: 10.5px;
  color: var(--text2);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* ContactColumn ------------------------------------------------------------ */
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

/* All links: neutral, never browser blue */
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

/* ALTRES INSCRIPCIONS compact chips */
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

/* StatusColumn ------------------------------------------------------------- */
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
  margin-top: 2px; font-style: italic;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}

.statusDivider {
  border: none; border-top: 1px solid var(--border2);
  margin: 4px 0;
}

.statusBadgeWrap { position: relative; display: inline-block; }

.statusClickBadge {
  display: inline-flex; align-items: center; gap: 4px;
  font-size: 8px; font-weight: 700; letter-spacing: 0.08em;
  text-transform: uppercase; padding: 3px 8px;
  border: 1px solid; border-radius: var(--radius);
  cursor: pointer; background: none; transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }

.statusClickBadge.ok    { background:#003400; color:#39F669; border-color:#39F669; }
.statusClickBadge.warn  { background:#2B0502; color:#FB9D04; border-color:#FB9D04; }
.statusClickBadge.issue { background:#43091F; color:#E9486E; border-color:#E9486E; }

[data-theme="dark"] .statusClickBadge.ok    { background:var(--s-ok-bg);   color:var(--s-ok);   border-color:var(--s-ok); }
[data-theme="dark"] .statusClickBadge.warn  { background:var(--s-warn-bg); color:var(--s-warn); border-color:var(--s-warn); }
[data-theme="dark"] .statusClickBadge.issue { background:var(--s-des-bg);  color:var(--s-des);  border-color:var(--s-des); }

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
.toggleBtn.toggled { background:#003400; color:#39F669; border-color:#39F669; }
[data-theme="dark"] .toggleBtn.toggled { background:var(--s-ok-bg); color:var(--s-ok); border-color:var(--s-ok); }

.premioSelect {
  width: 100%; padding: 4px 24px 4px 7px;
  font-size: 9px; border: 1px solid var(--border2);
  border-radius: var(--radius); background: var(--bg2); color: var(--text2);
  cursor: pointer; appearance: none; outline: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='4'%3E%3Cpath d='M0 0l4 4 4-4z' fill='%23999'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 6px center;
}
.premioSelect:focus { border-color: var(--border); color: var(--text); }

/* LinksRow (Row 2, C4) - 2/3 width ---------------------------------------- */
.linksRow {
  flex: 2;
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

/* Neutral link colors */
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
  flex: 1; min-height: 70px;
  padding: 7px 8px; font-size: 10px; line-height: 1.55;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text2);
  resize: none; outline: none; font-family: inherit;
  transition: border-color 0.1s;
}
.notesTextarea:focus { border-color: var(--border); color: var(--text); background: var(--bg); }

/* ActionStack (Row 2, C5) - 1/3 width ------------------------------------- */
.actionStack {
  flex: 1;
  padding: 12px 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: var(--bg2);
  border-left: 1px solid var(--border2);
  min-width: 100px;
}

.actionBtn {
  display: flex; align-items: center; justify-content: center;
  gap: 5px; width: 100%; height: 28px;
  font-size: 8px; font-weight: 700; letter-spacing: 0.1em;
  text-transform: uppercase; border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s; white-space: nowrap;
}
.actionBtn:hover:not(:disabled) { opacity: 0.82; }
.actionBtn:disabled { opacity: 0.35; cursor: default; }

.actionDesa     { background:#003400; color:#39F669; border-color:#39F669; }
.actionDescartar{ background:#2B0502; color:#FB9D04; border-color:#FB9D04; }

.actionNeutral {
  background: transparent; color: var(--text2); border-color: var(--border2);
}
.actionNeutral:hover:not(:disabled) {
  background: var(--bg3); color: var(--text); border-color: var(--border);
}

.actionSpacer { flex: 1; }

.actionEliminar { background:#43091F; color:#E9486E; border-color:#E9486E; }

[data-theme="dark"] .actionDesa      { background:var(--s-ok-bg);   color:var(--s-ok);   border-color:var(--s-ok); }
[data-theme="dark"] .actionDescartar { background:var(--s-warn-bg); color:var(--s-warn); border-color:var(--s-warn); }
[data-theme="dark"] .actionEliminar  { background:var(--s-des-bg);  color:var(--s-des);  border-color:var(--s-des); }
'@


# =============================================================================
# 05  Inspector\InfoColumn.tsx
#     English labels. Canonical fields. Inline edit pencil inside form box.
#     No blue left bar.
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\InfoColumn.tsx' @'
// InfoColumn.tsx - v0.4.3c
// Col 1: canonical general information. English labels. Inline edit pencil.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

function InfoRow({ label, value, readonly }: { label: string; value: string; readonly?: boolean }) {
  return (
    <div className={styles.infoRow}>
      <div className={styles.infoKey}>{label}</div>
      <div className={styles.infoVal}>
        <span className={readonly ? styles.infoValStatic : styles.infoValText}>{value || '\u2014'}</span>
        {!readonly && (
          <button className={styles.inlineEdit} aria-label="Edit">
            <i className="bi bi-pencil" aria-hidden="true"></i>
          </button>
        )}
      </div>
    </div>
  )
}

export function InfoColumn({ submission }: Props) {
  const categories = submission.category.split(',').map(c => c.trim()).filter(Boolean)
  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>General info</span>
      <InfoRow label="Code"     value={submission.code}           readonly />
      <InfoRow label="Title"    value={submission.title} />
      {categories.map((cat, i) => (
        <InfoRow key={i} label={i === 0 ? 'Category' : ''} value={cat} />
      ))}
      <InfoRow label="Platform" value={submission.platform ?? ''} />
      <InfoRow label="Year"     value={String(submission.year)}   readonly />
      <InfoRow label="Entry #"  value={String(submission.ordre)}  readonly />
      <InfoRow label="Price"    value={submission.price ? `${submission.price}\u00a0\u20ac` : ''} readonly />
      <InfoRow
        label="Project"
        value={submission.projectSelected ? 'Selected' : 'Not selected'}
        readonly
      />
      {submission.award && (
        <InfoRow label="Award"  value={submission.award}           readonly />
      )}
    </div>
  )
}
'@


# =============================================================================
# 06  Inspector\ContactColumn.tsx
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\ContactColumn.tsx' @'
// ContactColumn.tsx - v0.4.3c - English labels. Compact chips for other entries.
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
      <span className={styles.colLabel}>Contact</span>

      {/* Primary block */}
      <div className={styles.contactBlock}>
        <CField label="Name"    value={submission.firstName} />
        <CField label="Email"   value={submission.email} />
        <CField label="Phone"   value={submission.phone ?? ''} />
        <CField label="FAD mbr" value={submission.fadMember ? 'Yes' : 'No'} />
      </div>

      {/* Secondary block */}
      <div className={styles.contactBlock}>
        <CField label="Surname" value={submission.lastName} />
        <CField label="Studio"  value={submission.studio ?? ''} />
        <CField label="Web"     value={submission.website ?? ''} />
        <CField label="Assoc."  value={submission.associationMember ? 'Yes' : 'No'} />
      </div>

      {/* Other entries - compact 3-col chip grid. Click navigates in-place. */}
      {submission.otherSubmissions.length > 0 && (
        <div className={styles.altresSection}>
          <span className={styles.altresLabel}>Other entries</span>
          <div className={styles.altresGrid}>
            {submission.otherSubmissions.map(code => {
              const linked = mockSubmissions.find(s => s.code === code)
              return linked ? (
                <button
                  key={code}
                  className={styles.codeBadge}
                  onClick={() => onSelectId(linked.id)}
                  title={code}
                >
                  <i className="bi bi-arrow-right-short" style={{ fontSize:'9px' }} aria-hidden="true"></i>
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
# 07  Inspector\StatusColumn.tsx
#     English labels. Canonical: payment, physical mat, digital mat, return mat,
#     project selected. Workflow: awarded, award level.
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\StatusColumn.tsx' @'
// StatusColumn.tsx - v0.4.3c
// Col 3: canonical status fields + workflow fields.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

type PayVal = 'ok' | 'pending' | 'issue'
type MatVal = 'ok' | 'warning' | 'issue'

const PAY_OPTS:  { v: PayVal; label: string }[] = [
  { v:'ok',      label:'Confirmed' },
  { v:'pending', label:'Pending'   },
  { v:'issue',   label:'Error'     },
]
const MAT_OPTS: { v: MatVal; label: string }[] = [
  { v:'ok',      label:'Received' },
  { v:'warning', label:'Pending'  },
  { v:'issue',   label:'Missing'  },
]
const AWARD_OPTS = ['','inBook','Bronce','Plata','Oro','Grand Laus','Grand Laus Students','Laus de Honor','Laus Aporta']

const bClass = (v: PayVal | MatVal) =>
  v === 'ok' ? styles.ok : v === 'pending' || v === 'warning' ? styles.warn : styles.issue

const payLabel = (v: PayVal):  string => v === 'ok' ? 'Confirmed' : v === 'pending' ? 'Pending' : 'Error'
const matLabel = (v: MatVal):  string => v === 'ok' ? 'Received'  : v === 'warning' ? 'Pending' : 'Missing'

function DropdownBadge<T extends string>({
  value, label, classKey, open, onToggle, opts, onSelect,
}: {
  value: T; label: string; classKey: string; open: boolean;
  onToggle: () => void; opts: { v: T; label: string }[]; onSelect: (v: T) => void;
}) {
  return (
    <div className={styles.statusRow}>
      <span className={styles.statusRowLabel}>{label}</span>
      <div className={styles.statusBadgeWrap}>
        <button
          className={`${styles.statusClickBadge} ${classKey}`}
          onClick={onToggle}
        >
          {opts.find(o => o.v === value)?.label ?? value}
          <i className="bi bi-chevron-down" style={{ fontSize:'6px' }} aria-hidden="true"></i>
        </button>
        {open && (
          <div className={styles.statusDropdown}>
            {opts.map(o => (
              <button key={o.v} className={styles.statusDropdownItem} onClick={() => onSelect(o.v)}>
                {o.label}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export function StatusColumn({ submission }: Props) {
  const [payment,  setPayment]  = useState<PayVal>(submission.payment)
  const [physMat,  setPhysMat]  = useState<MatVal>(submission.material)
  const [digMat,   setDigMat]   = useState<MatVal>(submission.digitalMat ?? 'ok')
  const [payOpen,  setPayOpen]  = useState(false)
  const [phyOpen,  setPhyOpen]  = useState(false)
  const [digOpen,  setDigOpen]  = useState(false)
  const [returnMat,    setReturnMat]    = useState(submission.returnMaterial ?? false)
  const [projSel,      setProjSel]      = useState(submission.projectSelected ?? false)
  const [awarded,      setAwarded]      = useState(!!submission.award)
  const [awardLevel,   setAwardLevel]   = useState(submission.award ?? '')

  const closeAll = () => { setPayOpen(false); setPhyOpen(false); setDigOpen(false) }

  return (
    <div className={styles.statusCol}>
      <span className={styles.colLabel}>Status</span>

      {/* PAYMENT */}
      <DropdownBadge
        value={payment} label="Payment" classKey={bClass(payment)}
        open={payOpen} onToggle={() => { closeAll(); setPayOpen(!payOpen) }}
        opts={PAY_OPTS} onSelect={v => { setPayment(v); setPayOpen(false) }}
      />

      {/* PHYSICAL MAT */}
      <DropdownBadge
        value={physMat} label="Physical mat." classKey={bClass(physMat)}
        open={phyOpen} onToggle={() => { closeAll(); setPhyOpen(!phyOpen) }}
        opts={MAT_OPTS} onSelect={v => { setPhysMat(v); setPhyOpen(false) }}
      />
      {submission.physicalMatDesc && (
        <span className={styles.statusSmallNote}>{submission.physicalMatDesc}</span>
      )}

      {/* DIGITAL MAT */}
      <DropdownBadge
        value={digMat} label="Digital mat." classKey={bClass(digMat)}
        open={digOpen} onToggle={() => { closeAll(); setDigOpen(!digOpen) }}
        opts={MAT_OPTS} onSelect={v => { setDigMat(v); setDigOpen(false) }}
      />

      {/* RETURN MATERIAL */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Return mat.</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${returnMat ? styles.toggled : ''}`}
            onClick={() => setReturnMat(!returnMat)}
          >
            {returnMat ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      {/* PROJECT SELECTED */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Project sel.</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${projSel ? styles.toggled : ''}`}
            onClick={() => setProjSel(!projSel)}
          >
            {projSel ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      <hr className={styles.statusDivider} />

      {/* AWARDED - workflow only */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Awarded</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${awarded ? styles.toggled : ''}`}
            onClick={() => setAwarded(!awarded)}
          >
            {awarded ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      {/* AWARD LEVEL - visible when awarded */}
      {awarded && (
        <div className={styles.statusRow}>
          <span className={styles.statusRowLabel}>Award level</span>
          <select
            className={styles.premioSelect}
            value={awardLevel}
            onChange={e => setAwardLevel(e.target.value)}
          >
            {AWARD_OPTS.map(o => (
              <option key={o} value={o}>{o || '-- select --'}</option>
            ))}
          </select>
        </div>
      )}
    </div>
  )
}
'@


# =============================================================================
# 08  Inspector\LinksRow.tsx - English labels
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\LinksRow.tsx' @'
// LinksRow.tsx - v0.4.3c - English labels. Neutral link colors.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  return (
    <div className={styles.linksRow}>

      <div className={styles.linksSection}>
        <span className={styles.colLabel}>Links</span>

        {submission.dropboxUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-dropbox ${styles.linkIcon}`} aria-hidden="true"></i>
            <a href={submission.dropboxUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>
              Dropbox
            </a>
            <button className={styles.editBtn} aria-label="Edit">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}

        {submission.projectUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-box-arrow-up-right ${styles.linkIcon}`} aria-hidden="true"></i>
            <a href={submission.projectUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>
              Project URL
            </a>
            <button className={styles.editBtn} aria-label="Edit">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}
      </div>

      <div className={styles.notesSection}>
        <span className={styles.notesLabel}>Internal notes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={e => setNotes(e.target.value)}
          placeholder="Internal notes..."
        />
      </div>

    </div>
  )
}
'@


# =============================================================================
# 09  Inspector\ActionStack.tsx - English labels
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\ActionStack.tsx' @'
// ActionStack.tsx - v0.4.3c - English labels. Actions are stubs until v0.4.3d.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission; onClose: () => void }

export function ActionStack({ submission, onClose }: Props) {
  return (
    <div className={styles.actionStack}>

      <button className={`${styles.actionBtn} ${styles.actionDesa}`}
        onClick={() => alert('Save - coming in v0.4.3d')}>
        <i className="bi bi-floppy" aria-hidden="true"></i> Save
      </button>

      <button className={`${styles.actionBtn} ${styles.actionDescartar}`}
        onClick={onClose}>
        <i className="bi bi-x-circle" aria-hidden="true"></i> Discard
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`}
        onClick={() => window.open(`mailto:${submission.email}`, '_blank')}>
        <i className="bi bi-envelope" aria-hidden="true"></i> Contact
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`}
        onClick={() => alert('Duplicate - coming in v0.4.3d')}>
        <i className="bi bi-files" aria-hidden="true"></i> Duplicate
      </button>

      <div className={styles.actionSpacer}></div>

      <button className={`${styles.actionBtn} ${styles.actionEliminar}`}
        onClick={() => { if(window.confirm(`Delete ${submission.code}?`)) onClose() }}>
        <i className="bi bi-trash" aria-hidden="true"></i> Delete
      </button>

    </div>
  )
}
'@


# =============================================================================
# 10  src\modules\submissions\Submissions.module.css - breathing room
# =============================================================================
Write-File 'src\modules\submissions\Submissions.module.css' @'
/* Submissions.module.css - v0.4.3c */

.submissions {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--bg);
  overflow: hidden;
}

/* KPI strip - ADG stats-strip style */
.kpiStrip {
  display: flex;
  align-items: stretch;
  background: var(--bg2);
  border-bottom: 1px solid var(--border2);
  flex-shrink: 0;
  overflow-x: auto;
  scrollbar-width: none;
  min-height: 36px;
}
.kpiStrip::-webkit-scrollbar { display: none; }

.kpi {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 0 20px;
  min-height: 36px;
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
}

.kpiWarn { color: var(--s-warn); }
.kpiOk   { color: var(--s-ok); }
.kpiDes  { color: var(--s-des); }

/* Main layout */
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
# 11  src\modules\submissions\index.tsx - English KPIs + canonical counts
# =============================================================================
Write-File 'src\modules\submissions\index.tsx' @'
// submissions/index.tsx - v0.4.3c
import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { Inspector } from './components/Inspector'
import { mockSubmissions } from './mockData'
import styles from './Submissions.module.css'

const kpis = {
  total:        mockSubmissions.length,
  payPending:   mockSubmissions.filter(s => s.payment !== 'ok').length,
  matPending:   mockSubmissions.filter(s => s.material !== 'ok').length,
  noAward:      mockSubmissions.filter(s => !s.award).length,
}

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail,   setShowDetail]   = useState(false)
  const [detailId,     setDetailId]     = useState<string | null>(null)

  const handleRowClick  = (id: string) => { setDetailId(id); setShowDetail(true) }
  const handleSelectId  = (id: string) => { setDetailId(id) }
  const closeDetail     = () => { setShowDetail(false); setDetailId(null) }

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
          <Button variant="icon" title="Refresh"><i className="bi bi-arrow-repeat"></i></Button>
          <Button variant="icon" title="Import CSV"><i className="bi bi-upload"></i></Button>
          <Button variant="icon" title="Save session"><i className="bi bi-save"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Remove CSV"><i className="bi bi-file-earmark-x"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Duplicate"><i className="bi bi-files"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Delete selected"><i className="bi bi-trash"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Export"><i className="bi bi-download"></i></Button>
          <Button variant="icon" title="Filter"><i className="bi bi-funnel"></i></Button>
          <Button variant="icon" title="Column visibility"><i className="bi bi-layout-three-columns"></i></Button>
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
# 12  src\shared\layout\TopBar\index.tsx
#     Remove kpiZone (|| placeholder) and the | pipe between logo and tabs.
#     Clean, no empty separators.
# =============================================================================
Write-File 'src\shared\layout\TopBar\index.tsx' @'
// TopBar/index.tsx - v0.4.3c
// Clean structure: logo + tabs (left) / operator + clock + lang + theme (right).
// kpiZone removed (placeholder was visual noise). KPIs live in each module strip.
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

function LiveClock() {
  const [ts, setTs] = useState(() => new Date())
  useEffect(() => {
    const id = setInterval(() => setTs(new Date()), 1000)
    return () => clearInterval(id)
  }, [])
  const p = (n: number) => String(n).padStart(2, '0')
  return (
    <span className={styles.clock}>
      {p(ts.getDate())}/{p(ts.getMonth()+1)}/{ts.getFullYear()}
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
          <button className={`${styles.langBtn} ${language === 'ca' ? styles.langActive : ''}`} onClick={() => setLanguage('ca')}>CA</button>
          <button className={`${styles.langBtn} ${language === 'es' ? styles.langActive : ''}`} onClick={() => setLanguage('es')}>ES</button>
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
# 13  src\shared\layout\TopBar\styles.module.css
#     Height 36px. More tab breathing. Clean right zone.
# =============================================================================
Write-File 'src\shared\layout\TopBar\styles.module.css' @'
/* TopBar/styles.module.css - v0.4.3c */

.topbar {
  display: flex;
  align-items: stretch;
  height: 36px;
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
  padding: 0 16px;
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

/* Tabs --------------------------------------------------------------------- */
.tabs {
  display: flex;
  align-items: stretch;
  flex-shrink: 0;
}

.tab {
  display: flex;
  align-items: center;
  padding: 0 12px;
  font-size: 8.5px;
  font-weight: 400;
  letter-spacing: 0.12em;
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
.tab:hover { color: var(--text); background: var(--hover); }

.tabActive {
  background: var(--text) !important;
  color: var(--bg) !important;
  font-weight: 700;
}

/* Right zone --------------------------------------------------------------- */
.right {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 14px;
  border-left: 1px solid var(--border2);
  margin-left: auto;
  flex-shrink: 0;
  font-size: 11px;
  color: var(--text3);
}

.operator {
  font-size: 8px;
  letter-spacing: 0.08em;
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
  height: 22px;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  overflow: hidden;
}

.langBtn {
  font-size: 8px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 0 7px;
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
.langActive { background: var(--text); color: var(--bg); font-weight: 700; }

.themeBtn {
  width: 24px; height: 24px;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: transparent; color: var(--text2); cursor: pointer;
  font-size: 12px; transition: all 0.1s;
}
.themeBtn:hover { border-color: var(--border); color: var(--text); background: var(--bg2); }
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3c complete - 13 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  mockData.ts        Full canonical 23-field structure, 20 complete entries" -ForegroundColor DarkGray
Write-Host "  Table/index        9 columns: # Code Title Category Platform Payment Material Award Year" -ForegroundColor DarkGray
Write-Host "  Table/styles       Spreadsheet feel, award chip (#9694F4 indigo)" -ForegroundColor DarkGray
Write-Host "  Inspector/styles   Breathing room, 2fr+1fr Row 2, inline edit boxes, no blue bar" -ForegroundColor DarkGray
Write-Host "  InfoColumn         English, canonical fields, pencil inside form box" -ForegroundColor DarkGray
Write-Host "  ContactColumn      English labels" -ForegroundColor DarkGray
Write-Host "  StatusColumn       English, digital mat + return mat + project selected" -ForegroundColor DarkGray
Write-Host "  LinksRow           English" -ForegroundColor DarkGray
Write-Host "  ActionStack        English" -ForegroundColor DarkGray
Write-Host "  Submissions.css    KPI 36px, more breathing" -ForegroundColor DarkGray
Write-Host "  submissions/index  English KPIs, canonical counts" -ForegroundColor DarkGray
Write-Host "  TopBar/index       Removed kpiZone (|| placeholders) and pipe separator" -ForegroundColor DarkGray
Write-Host "  TopBar/styles      36px height, 12px tab padding, cleaner right zone" -ForegroundColor DarkGray
Write-Host ""
