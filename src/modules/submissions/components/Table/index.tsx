import { useState } from 'react'
import { StatusBadge } from '../../../../shared/ui/StatusBadge'
import styles from './styles.module.css'

interface SubmissionsTableProps {
  selectedRows: string[]
  onSelectionChange: (selected: string[]) => void
  onRowClick: (id: string) => void
}

// Mock data
const mockRows = [
  { id: '1', title: 'Disseny exposició', category: 'Branding', payment: 'ok', material: 'warning' },
  { id: '2', title: 'Campanya gràfica', category: 'Publicitat', payment: 'pending', material: 'ok' },
  { id: '3', title: 'Web corporativa', category: 'Digital', payment: 'ok', material: 'issue' },
]

export function SubmissionsTable({ selectedRows, onSelectionChange, onRowClick }: SubmissionsTableProps) {
  const [selectAll, setSelectAll] = useState(false)

  const handleSelectAll = (checked: boolean) => {
    setSelectAll(checked)
    if (checked) {
      onSelectionChange(mockRows.map(r => r.id))
    } else {
      onSelectionChange([])
    }
  }

  const handleSelectRow = (id: string, checked: boolean) => {
    if (checked) {
      onSelectionChange([...selectedRows, id])
    } else {
      onSelectionChange(selectedRows.filter(i => i !== id))
    }
  }

  return (
    <table className={styles.table}>
      <thead>
        <tr>
          <th className={styles.checkboxCell}>
            <input
              type="checkbox"
              checked={selectAll}
              onChange={(e) => handleSelectAll(e.target.checked)}
            />
          </th>
          <th>Títol</th>
          <th>Categoria</th>
          <th>Pagament</th>
          <th>Material</th>
          <th>Accions</th>
        </tr>
      </thead>
      <tbody>
        {mockRows.map((row) => (
          <tr
            key={row.id}
            className={selectedRows.includes(row.id) ? styles.selected : ''}
            onClick={() => onRowClick(row.id)}
          >
            <td className={styles.checkboxCell} onClick={(e) => e.stopPropagation()}>
              <input
                type="checkbox"
                checked={selectedRows.includes(row.id)}
                onChange={(e) => handleSelectRow(row.id, e.target.checked)}
              />
            </td>
            <td>{row.title}</td>
            <td>{row.category}</td>
            <td>
              <StatusBadge status={row.payment === 'ok' ? 'ok' : row.payment === 'pending' ? 'warning' : 'issue'}>
                {row.payment === 'ok' ? 'Confirmat' : row.payment === 'pending' ? 'Pendent' : 'Error'}
              </StatusBadge>
            </td>
            <td>
              <StatusBadge status={row.material === 'ok' ? 'ok' : row.material === 'warning' ? 'warning' : 'issue'}>
                {row.material === 'ok' ? 'Rebut' : row.material === 'warning' ? 'Pendent' : 'Falta'}
              </StatusBadge>
            </td>
            <td>
              <button className={styles.actionIcon} onClick={(e) => e.stopPropagation()}>🌐</button>
              <button className={styles.actionIcon} onClick={(e) => e.stopPropagation()}>📋</button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}