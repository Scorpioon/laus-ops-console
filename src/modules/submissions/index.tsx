// submissions/index.tsx - v0.4.3e
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

      {/* Toolbar - system buttons colored in resting state */}
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