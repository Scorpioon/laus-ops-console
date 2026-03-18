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