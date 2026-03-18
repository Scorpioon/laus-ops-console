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