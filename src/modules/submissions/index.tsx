import { useState } from 'react'
import { SubmissionsTable } from './components/Table'
import { Button } from '../../shared/ui/Button'
import { StatusBadge } from '../../shared/ui/StatusBadge'
import styles from './Submissions.module.css'

// Mock KPI data
const kpiData = {
  total: 124,
  pendingPayment: 18,
  missingMaterial: 23,
  selectedWithoutPrize: 7,
}

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([])
  const [showDetail, setShowDetail] = useState(false)

  return (
    <div className={styles.submissions}>
      {/* Upload Area */}
      <div className={styles.uploadArea}>
        <div className={styles.uploadBox}>
          <p>Arrossega un CSV o fes clic per pujar</p>
          <Button variant="secondary">Puja CSV</Button>
        </div>
      </div>

      {/* KPI Strip */}
      <div className={styles.kpiStrip}>
        <div className={styles.kpiItem}>
          <span className={styles.kpiValue}>{kpiData.total}</span>
          <span className={styles.kpiLabel}>Total inscripcions</span>
        </div>
        <div className={styles.kpiItem}>
          <span className={styles.kpiValue}>{kpiData.pendingPayment}</span>
          <span className={styles.kpiLabel}>Pagament pendent</span>
        </div>
        <div className={styles.kpiItem}>
          <span className={styles.kpiValue}>{kpiData.missingMaterial}</span>
          <span className={styles.kpiLabel}>Material pendent</span>
        </div>
        <div className={styles.kpiItem}>
          <span className={styles.kpiValue}>{kpiData.selectedWithoutPrize}</span>
          <span className={styles.kpiLabel}>Seleccionats sense premi</span>
        </div>
      </div>

      {/* Action Bar */}
      <div className={styles.actionBar}>
        <div className={styles.leftActions}>
          <Button variant="secondary" disabled={selectedRows.length === 0}>
            Edita seleccionats
          </Button>
          <Button variant="secondary" disabled={selectedRows.length === 0}>
            Exporta seleccionats
          </Button>
        </div>
        <div className={styles.rightActions}>
          <Button variant="primary">+ Nou</Button>
          <Button variant="secondary">Desa vista</Button>
          <Button variant="secondary">Exporta tot</Button>
        </div>
      </div>

      {/* Main Table */}
      <div className={styles.tableContainer}>
        <SubmissionsTable
          selectedRows={selectedRows}
          onSelectionChange={setSelectedRows}
          onRowClick={() => setShowDetail(true)}
        />
      </div>

      {/* Detail Panel (right side) */}
      {showDetail && (
        <div className={styles.detailPanel}>
          <div className={styles.detailHeader}>
            <h3>Detall de la inscripció</h3>
            <button className={styles.closeBtn} onClick={() => setShowDetail(false)}>×</button>
          </div>
          <div className={styles.detailBody}>
            <p><strong>ID:</strong> LAUS-2026-0123</p>
            <p><strong>Títol:</strong> Disseny gràfic per a exposició</p>
            <p><strong>Categoria:</strong> Branding</p>
            <p><strong>Estat material:</strong> <StatusBadge status="warning">Pendent</StatusBadge></p>
            <p><strong>Pagament:</strong> <StatusBadge status="ok">Confirmat</StatusBadge></p>
            <div className={styles.quickActions}>
              <Button variant="icon" onClick={() => window.open('#', '_blank')}>🌐</Button>
              <Button variant="icon" onClick={() => navigator.clipboard.writeText('link')}>📋</Button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}