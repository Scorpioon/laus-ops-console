// InfoColumn.tsx - v0.4.3c
// Col 1: canonical general information. English labels. Inline edit pencil.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

function InfoRow({ label, value, readonly }: { label: string; value: string; readonly?: boolean }) {
  return (
    <div className={styles.infoRow}>
      <div className={styles.infoKey}>{label}</div>
      <div className={styles.infoVal}>
        <span className={readonly ? styles.infoValStatic : styles.infoValText}>{value || '\u2014'}</span>
        {!readonly && (
          <button className={styles.inlineEdit} aria-label="Edit">
            <i className="bi bi-pencil" aria-hidden="true"></i>
          </button>
        )}
      </div>
    </div>
  )
}

export function InfoColumn({ submission }: Props) {
  const categories = submission.category.split(',').map(c => c.trim()).filter(Boolean)
  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>General info</span>
      <InfoRow label="Code"     value={submission.code}           readonly />
      <InfoRow label="Title"    value={submission.title} />
      {categories.map((cat, i) => (
        <InfoRow key={i} label={i === 0 ? 'Category' : ''} value={cat} />
      ))}
      <InfoRow label="Platform" value={submission.platform ?? ''} />
      <InfoRow label="Year"     value={String(submission.year)}   readonly />
      <InfoRow label="Entry #"  value={String(submission.ordre)}  readonly />
      <InfoRow label="Price"    value={submission.price ? `${submission.price}\u00a0\u20ac` : ''} readonly />
      <InfoRow
        label="Project"
        value={submission.projectSelected ? 'Selected' : 'Not selected'}
        readonly
      />
      {submission.award && (
        <InfoRow label="Award"  value={submission.award}           readonly />
      )}
    </div>
  )
}