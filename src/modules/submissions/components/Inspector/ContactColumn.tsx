// src/modules/submissions/components/Inspector/ContactColumn.tsx - v0.4.3a
// Col 2: two contact blocks + ALTRES INSCRIPCIONS 3-col badge grid.
// Clicking a badge calls onSelectId - inspector updates in-place, no remount.
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
      <span className={styles.colLabel}>Contacte</span>

      {/* Primary contact block */}
      <div className={styles.contactBlock}>
        <CField label="Nom"      value={submission.firstName} />
        <CField label="Email"    value={submission.email} />
        <CField label="Tel."     value={submission.phone ?? ''} />
        <CField label="Soci FAD" value={submission.fadMember ? 'Si' : 'No'} />
      </div>

      {/* Secondary contact block */}
      <div className={styles.contactBlock}>
        <CField label="Cognom" value={submission.lastName} />
        <CField label="Estudi" value={submission.studio} />
        <CField label="Web"    value={submission.website ?? ''} />
        <CField label="Altres" value={submission.associationMember ? 'Si' : 'No'} />
      </div>

      {/* ALTRES INSCRIPCIONS: 3-col badge grid.
          Clicking navigates to the linked record inside the inspector.
          Does NOT unmount the inspector - only updates selectedId. */}
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
                  title={code}
                >
                  <i className="bi bi-arrow-right-short" aria-hidden="true"></i>
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