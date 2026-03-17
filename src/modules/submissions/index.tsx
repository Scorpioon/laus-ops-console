// src/modules/submissions/index.tsx
import { useState } from 'react';
import { SubmissionsTable } from './components/Table';
import { Button } from '../../shared/ui/Button';
import { StatusBadge } from '../../shared/ui/StatusBadge';
import { mockSubmissions } from './mockData';
import styles from './Submissions.module.css';

// Mock KPI data (derived from mock submissions)
const kpiData = {
  total: mockSubmissions.length,
  pendingPayment: mockSubmissions.filter(s => s.payment === 'pending').length,
  missingMaterial: mockSubmissions.filter(s => s.material === 'issue').length,
  selectedWithoutPrize: 7, // Keeping as is for now
};

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([]);
  const [showDetail, setShowDetail] = useState(false);
  const [detailId, setDetailId] = useState<string | null>(null);

  const handleRowClick = (id: string) => {
    setDetailId(id);
    setShowDetail(true);
  };

  const closeDetail = () => {
    setShowDetail(false);
    setDetailId(null);
  };

  const selectedSubmission = detailId ? mockSubmissions.find(s => s.id === detailId) : null;

  return (
    <div className={styles.submissions}>
      {/* Upload Area - compact */}
      <div className={styles.uploadArea}>
        <div className={styles.uploadBox}>
          <i className="bi bi-upload"></i>
          <span>Arrossega CSV o fes clic</span>
          <Button variant="secondary">Puja CSV</Button>
        </div>
      </div>

      {/* KPI Strip - subtle */}
      <div className={styles.kpiStrip}>
        <div className={styles.kpiItem}>
          <span className={styles.kpiValue}>{kpiData.total}</span>
          <span className={styles.kpiLabel}>Total</span>
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
          <span className={styles.kpiLabel}>Sense premi</span>
        </div>
      </div>

      {/* Toolbar */}
      <div className="toolbar">
        <div className="toolbar-group">
          <Button variant="icon" disabled={selectedRows.length === 0}><i className="bi bi-pencil-square"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0}><i className="bi bi-files"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0}><i className="bi bi-trash"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon"><i className="bi bi-plus-lg"></i></Button>
          <Button variant="icon"><i className="bi bi-download"></i></Button>
          <Button variant="icon"><i className="bi bi-bookmark-plus"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon"><i className="bi bi-funnel"></i></Button>
          <Button variant="icon"><i className="bi bi-sort-alpha-down"></i></Button>
        </div>
        <div style={{ flex: 1 }}></div>
        <div className="toolbar-group">
          <Button variant="icon"><i className="bi bi-arrow-repeat"></i></Button>
          <Button variant="icon"><i className="bi bi-question-circle"></i></Button>
        </div>
      </div>

      {/* Main area: table + detail panel (flex) */}
      <div className={styles.mainArea} style={{ display: 'flex', gap: '1rem', alignItems: 'flex-start' }}>
        <div className={styles.tableContainer} style={{ flex: showDetail ? '1 1 50%' : '1 1 100%', transition: 'flex 0.2s' }}>
          <SubmissionsTable
            selectedRows={selectedRows}
            onSelectionChange={setSelectedRows}
            onRowClick={handleRowClick}
          />
        </div>

        {showDetail && selectedSubmission && (
          <div className={styles.detailPanel} style={{ flex: '0 0 50%', maxWidth: '50%' }}>
            <div className={styles.detailHeader}>
              <h3>Detall de la inscripció</h3>
              <button className={styles.closeBtn} onClick={closeDetail}><i className="bi bi-x-lg"></i></button>
            </div>
            <div className={styles.detailBody}>
              <p><strong>Codi:</strong> {selectedSubmission.code}</p>
              <p><strong>Títol:</strong> {selectedSubmission.title}</p>
              <p><strong>Categoria:</strong> {selectedSubmission.category}</p>
              <p><strong>Estat material:</strong> <StatusBadge status={selectedSubmission.material === 'ok' ? 'ok' : selectedSubmission.material === 'warning' ? 'warning' : 'issue'}>
                {selectedSubmission.material === 'ok' ? 'Rebut' : selectedSubmission.material === 'warning' ? 'Pendent' : 'Falta'}
              </StatusBadge></p>
              <p><strong>Pagament:</strong> <StatusBadge status={selectedSubmission.payment === 'ok' ? 'ok' : selectedSubmission.payment === 'pending' ? 'warning' : 'issue'}>
                {selectedSubmission.payment === 'ok' ? 'Confirmat' : selectedSubmission.payment === 'pending' ? 'Pendent' : 'Error'}
              </StatusBadge></p>
              <div className={styles.quickActions}>
                <Button variant="icon"><i className="bi bi-box-arrow-up-right"></i></Button>
                <Button variant="icon"><i className="bi bi-files"></i></Button>
                <Button variant="icon"><i className="bi bi-pencil"></i></Button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}