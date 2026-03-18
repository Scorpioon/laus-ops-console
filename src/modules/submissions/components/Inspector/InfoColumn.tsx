// src/modules/submissions/components/Inspector/InfoColumn.tsx - v0.4.3a
// Col 1: blue left-border accent, CODI + TITOL readonly, CATEGORIA rows.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function InfoColumn({ submission }: Props) {
  return (
    <div className={styles.infoCol}>
      <span className={styles.colLabel}>Informacio general</span>

      <div className={styles.fieldGroup}>
        <div className={styles.fieldKey}>Codi</div>
        <div className={styles.fieldVal}>{submission.code}</div>
      </div>

      <div className={styles.fieldGroup}>
        <div className={styles.fieldKey}>Titol</div>
        <div className={styles.fieldVal}>{submission.title}</div>
      </div>

      <div className={`${styles.fieldGroup} ${styles.catSection}`}>
        <div className={styles.fieldKey}>Categoria</div>
        {submission.category.split(',').map((cat) => (
          <div key={cat.trim()} className={styles.catRow}>
            <span className={styles.catVal}>{cat.trim()}</span>
          </div>
        ))}
      </div>
    </div>
  )
}