// Inspector/ContactColumn.tsx - v0.4.3b
// Col 2: two contact blocks + ALTRES INSCRIPCIONS compact chip grid.
// Clicking a badge navigates to that record in-place - no remount.
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
      <button className={styles.editBtn} aria-label="Edita">
        <i className="bi bi-pencil" aria-hidden="true"></i>
      </button>
    </div>
  )
}

export function ContactColumn({ submission, onSelectId }: Props) {
  return (
    <div className={styles.contactCol}>
      <span className={styles.colLabel}>Contacte</span>

      {/* Primary block */}
      <div className={styles.contactBlock}>
        <CField label="Nom"       value={submission.firstName} />
        <CField label="Email"     value={submission.email} />
        <CField label="Tel\u00e8fon"  value={submission.phone ?? ''} />
        <CField label="Soci FAD"  value={submission.fadMember ? 'S\u00ed' : 'No'} />
      </div>

      {/* Secondary block */}
      <div className={styles.contactBlock}>
        <CField label="Cognom"    value={submission.lastName} />
        <CField label="Estudi"    value={submission.studio} />
        <CField label="Web"       value={submission.website ?? ''} />
        <CField label="Altres"    value={submission.associationMember ? 'S\u00ed' : 'No'} />
      </div>

      {/* ALTRES INSCRIPCIONS: compact 3-col chip grid.
          Clicking navigates in-place - inspector does not remount. */}
      {submission.otherSubmissions.length > 0 && (
        <div className={styles.altresSection}>
          <span className={styles.altresLabel}>Altres inscripcions</span>
          <div className={styles.altresGrid}>
            {submission.otherSubmissions.map((code) => {
              const linked = mockSubmissions.find((s) => s.code === code)
              return linked ? (
                <button
                  key={code}
                  className={styles.codeBadge}
                  onClick={() => onSelectId(linked.id)}
                  title={`Obre ${code}`}
                >
                  <i className="bi bi-arrow-right-short" style={{ fontSize: '9px' }} aria-hidden="true"></i>
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