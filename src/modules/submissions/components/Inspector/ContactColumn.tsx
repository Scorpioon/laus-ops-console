// ContactColumn.tsx - v0.4.3c - English labels. Compact chips for other entries.
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
      <button className={styles.editBtn} aria-label="Edit">
        <i className="bi bi-pencil" aria-hidden="true"></i>
      </button>
    </div>
  )
}

export function ContactColumn({ submission, onSelectId }: Props) {
  return (
    <div className={styles.contactCol}>
      <span className={styles.colLabel}>Contact</span>

      {/* Primary block */}
      <div className={styles.contactBlock}>
        <CField label="Name"    value={submission.firstName} />
        <CField label="Email"   value={submission.email} />
        <CField label="Phone"   value={submission.phone ?? ''} />
        <CField label="FAD mbr" value={submission.fadMember ? 'Yes' : 'No'} />
      </div>

      {/* Secondary block */}
      <div className={styles.contactBlock}>
        <CField label="Surname" value={submission.lastName} />
        <CField label="Studio"  value={submission.studio ?? ''} />
        <CField label="Web"     value={submission.website ?? ''} />
        <CField label="Assoc."  value={submission.associationMember ? 'Yes' : 'No'} />
      </div>

      {/* Other entries - compact 3-col chip grid. Click navigates in-place. */}
      {submission.otherSubmissions.length > 0 && (
        <div className={styles.altresSection}>
          <span className={styles.altresLabel}>Other entries</span>
          <div className={styles.altresGrid}>
            {submission.otherSubmissions.map(code => {
              const linked = mockSubmissions.find(s => s.code === code)
              return linked ? (
                <button
                  key={code}
                  className={styles.codeBadge}
                  onClick={() => onSelectId(linked.id)}
                  title={code}
                >
                  <i className="bi bi-arrow-right-short" style={{ fontSize:'9px' }} aria-hidden="true"></i>
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