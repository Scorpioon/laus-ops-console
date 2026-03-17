// src/modules/submissions/components/Table/index.tsx
import { useState } from 'react';
import { StatusBadge } from '../../../../shared/ui/StatusBadge';
import { mockSubmissions, MockSubmission } from '../../mockData';
import styles from './styles.module.css';

interface SubmissionsTableProps {
  selectedRows: string[];
  onSelectionChange: (selected: string[]) => void;
  onRowClick: (id: string) => void;
}

// Sorting state (visual only for now)
type SortDirection = 'asc' | 'desc' | null;
interface SortState {
  column: string;
  direction: SortDirection;
}

export function SubmissionsTable({ selectedRows, onSelectionChange, onRowClick }: SubmissionsTableProps) {
  const [sort, setSort] = useState<SortState>({ column: 'code', direction: 'asc' });

  const handleSelectAll = (checked: boolean) => {
    if (checked) {
      onSelectionChange(mockSubmissions.map(r => r.id));
    } else {
      onSelectionChange([]);
    }
  };

  const handleSelectRow = (id: string, checked: boolean) => {
    if (checked) {
      onSelectionChange([...selectedRows, id]);
    } else {
      onSelectionChange(selectedRows.filter(i => i !== id));
    }
  };

  const handleSort = (column: string) => {
    setSort(prev => {
      if (prev.column !== column) return { column, direction: 'asc' };
      if (prev.direction === 'asc') return { column, direction: 'desc' };
      if (prev.direction === 'desc') return { column, direction: null };
      return { column, direction: 'asc' };
    });
  };

  const renderSortIcon = (col: string) => {
    if (sort.column !== col) return <i className="bi bi-arrow-down-up" style={{ opacity: 0.3, marginLeft: '0.25rem' }}></i>;
    if (sort.direction === 'asc') return <i className="bi bi-sort-up" style={{ marginLeft: '0.25rem' }}></i>;
    if (sort.direction === 'desc') return <i className="bi bi-sort-down" style={{ marginLeft: '0.25rem' }}></i>;
    return <i className="bi bi-arrow-down-up" style={{ opacity: 0.3, marginLeft: '0.25rem' }}></i>;
  };

  const allSelected = selectedRows.length === mockSubmissions.length;

  return (
    <table className={styles.table}>
      <thead>
        <tr>
          <th className={styles.checkboxCell}>
            <input
              type="checkbox"
              checked={allSelected}
              onChange={(e) => handleSelectAll(e.target.checked)}
            />
          </th>
          <th onClick={() => handleSort('code')} style={{ cursor: 'pointer' }}>
            Codi {renderSortIcon('code')}
          </th>
          <th onClick={() => handleSort('title')} style={{ cursor: 'pointer' }}>
            Títol {renderSortIcon('title')}
          </th>
          <th onClick={() => handleSort('category')} style={{ cursor: 'pointer' }}>
            Categoria {renderSortIcon('category')}
          </th>
          <th>Pagament</th>
          <th>Material</th>
        </tr>
      </thead>
      <tbody>
        {mockSubmissions.map((row: MockSubmission) => (
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
            <td className={styles.codeCell}>{row.code}</td>
            <td>{row.title}</td>
            <td>{row.category}</td>
            <td>
              <StatusBadge status={row.payment === 'ok' ? 'ok' : row.payment === 'pending' ? 'warning' : 'issue'}>
                {row.payment === 'ok' ? 'confirmat' : row.payment === 'pending' ? 'pendent' : 'error'}
              </StatusBadge>
            </td>
            <td>
              <StatusBadge status={row.material === 'ok' ? 'ok' : row.material === 'warning' ? 'warning' : 'issue'}>
                {row.material === 'ok' ? 'rebut' : row.material === 'warning' ? 'pendent' : 'falta'}
              </StatusBadge>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}