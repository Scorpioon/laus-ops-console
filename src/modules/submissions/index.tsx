// src/modules/submissions/index.tsx - v0.4.2 (revised)
import { useState } from 'react';
import { SubmissionsTable } from './components/Table';
import { Button } from '../../shared/ui/Button';
import { StatusBadge } from '../../shared/ui/StatusBadge';
import { mockSubmissions } from './mockData';
import styles from './Submissions.module.css';

// Mock KPI data
const kpiData = {
  total: mockSubmissions.length,
  pendingPayment: mockSubmissions.filter(s => s.payment === 'pending').length,
  missingMaterial: mockSubmissions.filter(s => s.material === 'issue').length,
  selectedWithoutPrize: 7,
};

export function SubmissionsModule() {
  const [selectedRows, setSelectedRows] = useState<string[]>([]);
  const [showDetail, setShowDetail] = useState(false);
  const [detailId, setDetailId] = useState<string | null>(null);
  const [studentsOnly, setStudentsOnly] = useState(false);

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
      {/* KPI Strip - tighter */}
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

      {/* Toolbar - compact, no duplicate refresh */}
      <div className="toolbar">
        <div className="toolbar-group">
          <Button variant="icon" title="Refresh"><i className="bi bi-arrow-repeat"></i></Button>
          <Button variant="icon" title="Upload CSV"><i className="bi bi-upload"></i></Button>
          <Button variant="icon" title="Save session"><i className="bi bi-save"></i></Button>
          <Button variant="icon" title="Close session"><i className="bi bi-x-circle"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Delete CSV"><i className="bi bi-file-earmark-x"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Duplicate selected"><i className="bi bi-files"></i></Button>
          <Button variant="icon" disabled={selectedRows.length === 0} title="Delete selected"><i className="bi bi-trash"></i></Button>
        </div>
        <div className="toolbar-group">
          <Button variant="icon" title="Export"><i className="bi bi-download"></i></Button>
          <Button variant="icon" title="Filter"><i className="bi bi-funnel"></i></Button>
          <Button variant="icon" title="Sort"><i className="bi bi-sort-alpha-down"></i></Button>
          <Button
            variant="icon"
            title={studentsOnly ? "Show all students" : "Show only students"}
            onClick={() => setStudentsOnly(!studentsOnly)}
            className={studentsOnly ? styles.activeToggle : ''}
          >
            <i className="bi bi-person-square"></i>
          </Button>
        </div>
        <div style={{ flex: 1 }}></div>
        {/* No duplicate refresh */}
      </div>

      {/* Main area: table + detail panel */}
      <div className={styles.mainArea}>
        <div
          className={`${styles.tableContainer} ${showDetail ? styles.tableContainerWithDetail : ''}`}
          style={{ flex: showDetail ? '1 1 50%' : '1 1 100%' }}
        >
          <SubmissionsTable
            selectedRows={selectedRows}
            onSelectionChange={setSelectedRows}
            onRowClick={handleRowClick}
          />
        </div>

        {showDetail && selectedSubmission && (
          <div className={styles.detailPanel}>
            <div className={styles.detailHeader}>
              <h3>Detall de la inscripciÃ³</h3>
              <button className={styles.closeBtn} onClick={closeDetail}><i className="bi bi-x-lg"></i></button>
            </div>
            <div className={styles.detailBody}>
              {/* UPPER AREA: General + Status + Contact */}
              <div className={styles.upperArea}>
                {/* General Information */}
                <div className={styles.sectionCard}>
                  <h4 className={styles.sectionTitle}>InformaciÃ³ general</h4>
                  <div className={styles.fieldRow}>
                    <label>Codi</label>
                    <div className={styles.fieldBox}>{selectedSubmission.code}</div>
                    <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                  </div>
                  <div className={styles.fieldRow}>
                    <label>TÃ­tol</label>
                    <div className={styles.fieldBox}>{selectedSubmission.title}</div>
                    <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                  </div>
                  <div className={styles.fieldRow}>
                    <label>Categoria</label>
                    <div className={styles.fieldBox}>{selectedSubmission.category}</div>
                    <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                  </div>
                </div>

                {/* Status */}
                <div className={styles.sectionCard}>
                  <h4 className={styles.sectionTitle}>Estat</h4>
                  <div className={styles.fieldRow}>
                    <label>Pagament</label>
                    <div className={styles.fieldBox}>
                      <StatusBadge status={selectedSubmission.payment === 'ok' ? 'ok' : selectedSubmission.payment === 'pending' ? 'warning' : 'issue'}>
                        {selectedSubmission.payment === 'ok' ? 'confirmat' : selectedSubmission.payment === 'pending' ? 'pendent' : 'error'}
                      </StatusBadge>
                    </div>
                    <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                  </div>
                  <div className={styles.fieldRow}>
                    <label>Material</label>
                    <div className={styles.fieldBox}>
                      <StatusBadge status={selectedSubmission.material === 'ok' ? 'ok' : selectedSubmission.material === 'warning' ? 'warning' : 'issue'}>
                        {selectedSubmission.material === 'ok' ? 'rebut' : selectedSubmission.material === 'warning' ? 'pendent' : 'falta'}
                      </StatusBadge>
                    </div>
                    <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                  </div>
                </div>

                {/* Contact */}
                <div className={styles.sectionCard}>
                  <h4 className={styles.sectionTitle}>Contacte</h4>
                  <div className={styles.contactGrid}>
                    <div className={styles.contactField}>
                      <label>Nom</label>
                      <span className={styles.fieldBox}>{selectedSubmission.firstName}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Cognom</label>
                      <span className={styles.fieldBox}>{selectedSubmission.lastName}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Email</label>
                      <span className={styles.fieldBox}><a href={`mailto:${selectedSubmission.email}`}>{selectedSubmission.email}</a></span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Estudi / AgÃ¨ncia</label>
                      <span className={styles.fieldBox}>{selectedSubmission.studio}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>TelÃ¨fon</label>
                      <span className={styles.fieldBox}>{selectedSubmission.phone || 'â€”'}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Web</label>
                      <span className={styles.fieldBox}>{selectedSubmission.website ? <a href={selectedSubmission.website} target="_blank" rel="noopener noreferrer">{selectedSubmission.website}</a> : 'â€”'}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Soci FAD</label>
                      <span className={styles.fieldBox}>{selectedSubmission.fadMember ? 'SÃ­' : 'No'}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                    <div className={styles.contactField}>
                      <label>Altres associacions</label>
                      <span className={styles.fieldBox}>{selectedSubmission.associationMember ? 'SÃ­' : 'No'}</span>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                  </div>
                  {selectedSubmission.otherSubmissions.length > 0 && (
                    <div className={styles.otherSubmissions}>
                      <label>Altres inscripcions</label>
                      <div>
                        {selectedSubmission.otherSubmissions.map(code => (
                          <button key={code} className={styles.codeLink} onClick={() => handleRowClick(mockSubmissions.find(s => s.code === code)?.id || '')}>
                            <i className="bi bi-box-arrow-up-right" style={{ marginRight: '0.25rem' }}></i>
                            {code}
                          </button>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              </div>

              {/* LOWER AREA: Links + Notes + Quick Actions */}
              <div className={styles.lowerArea}>
                {/* Dropbox & Digital Material Links */}
                <div className={styles.sectionCard}>
                  <h4 className={styles.sectionTitle}>EnllaÃ§os</h4>
                  {selectedSubmission.dropboxUrl && (
                    <div className={styles.linkTag}>
                      <i className="bi bi-dropbox"></i>
                      <a href={selectedSubmission.dropboxUrl} target="_blank" rel="noopener noreferrer">Dropbox</a>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                  )}
                  {selectedSubmission.projectUrl && (
                    <div className={styles.linkTag}>
                      <i className="bi bi-box-arrow-up-right"></i>
                      <a href={selectedSubmission.projectUrl} target="_blank" rel="noopener noreferrer">Projecte</a>
                      <button className={styles.editIcon}><i className="bi bi-pencil"></i></button>
                    </div>
                  )}
                </div>

                {/* Internal Notes */}
                <div className={styles.sectionCard}>
                  <h4 className={styles.sectionTitle}>Notes internes</h4>
                  <div className={styles.notesField}>
                    {selectedSubmission.internalNotes || 'â€”'}
                  </div>
                  <button className={styles.editIcon} style={{ float: 'right', marginTop: '0.25rem' }}><i className="bi bi-pencil"></i></button>
                </div>

                {/* Quick Action Zone */}
                <div className={styles.quickActionZone}>
                  <Button variant="secondary" onClick={() => alert('Desa')}><i className="bi bi-save"></i> Desa</Button>
                  <Button variant="secondary" onClick={() => alert('Descartar')}><i className="bi bi-x-circle"></i> Descartar</Button>
                  <Button variant="secondary" onClick={() => window.location.href = `mailto:${selectedSubmission.email}`}><i className="bi bi-envelope"></i> Contacte</Button>
                  <Button variant="secondary" onClick={() => alert('Duplicar')}><i className="bi bi-files"></i> Duplicar</Button>
                  <Button variant="secondary" onClick={() => alert('Eliminar')}><i className="bi bi-trash"></i> Eliminar</Button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
