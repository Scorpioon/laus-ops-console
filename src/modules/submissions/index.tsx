// src/modules/submissions/index.tsx - v0.4.3a
// Old inline detailPanel block removed. Inspector component wired in its place.
import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { Inspector } from './components/Inspector'
import { mockSubmissions } from './mockData'
import styles from './Submissions.module.css'

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail,   setShowDetail]   = useState(false)
  const [detailId,     setDetailId]     = useState<string | null>(null)
  const [studentsOnly, setStudentsOnly] = useState(false)

  // Open inspector - does not remount if already open
  const handleRowClick = (id: string) => {
    setDetailId(id)
    setShowDetail(true)
  }

  // Navigate to a linked record inside the inspector (ALTRES INSCRIPCIONS).
  // Updates detailId in-place. Inspector component does NOT unmount.
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
          <Button
            variant="icon"
            disabled={selectedRows.length === 0}
            title="Duplicate selected"
          >
            <i className="bi bi-files"></i>
          </Button>
          <Button
            variant="icon"
            disabled={selectedRows.length === 0}
            title="Delete selected"
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
          <Button
            variant="icon"
            title={studentsOnly ? 'Show all' : 'Students only'}
            onClick={() => setStudentsOnly(!studentsOnly)}
            className={studentsOnly ? styles.activeToggle : ''}
          >
            <i className="bi bi-person-square"></i>
          </Button>
        </div>
      </div>

      {/* Main area */}
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

        {/* Inspector replaces old detailPanel */}
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