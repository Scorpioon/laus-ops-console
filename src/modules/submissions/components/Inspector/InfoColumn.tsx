// Inspector/InfoColumn.tsx - v0.4.3b
// Col 1: blue left-border, horizontal key|value rows, multiple CATEGORIA rows.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function InfoColumn({ submission }: Props) {
  const categories = submission.category
    .split(',')
    .map(c => c.trim())
    .filter(Boolean)

  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>Informaci\u00f3 general</span>

      <div className={styles.infoRow}>
        <div className={styles.infoKey}>Codi</div>
        <div className={styles.infoVal}>{submission.code}</div>
      </div>

      <div className={styles.infoRow}>
        <div className={styles.infoKey}>T\u00edtol</div>
        <div className={styles.infoVal}>{submission.title}</div>
      </div>

      {categories.map((cat, i) => (
        <div key={`cat-${i}`} className={styles.infoRow}>
          <div className={styles.infoKey}>Categoria</div>
          <div className={styles.infoVal}>{cat}</div>
        </div>
      ))}
    </div>
  )
}