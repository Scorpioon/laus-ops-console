// ActionStack.tsx - v0.4.3c - English labels. Actions are stubs until v0.4.3d.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission; onClose: () => void }

export function ActionStack({ submission, onClose }: Props) {
  return (
    <div className={styles.actionStack}>

      <button className={`${styles.actionBtn} ${styles.actionDesa}`}
        onClick={() => alert('Save - coming in v0.4.3d')}>
        <i className="bi bi-floppy" aria-hidden="true"></i> Save
      </button>

      <button className={`${styles.actionBtn} ${styles.actionDescartar}`}
        onClick={onClose}>
        <i className="bi bi-x-circle" aria-hidden="true"></i> Discard
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`}
        onClick={() => window.open(`mailto:${submission.email}`, '_blank')}>
        <i className="bi bi-envelope" aria-hidden="true"></i> Contact
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`}
        onClick={() => alert('Duplicate - coming in v0.4.3d')}>
        <i className="bi bi-files" aria-hidden="true"></i> Duplicate
      </button>

      <div className={styles.actionSpacer}></div>

      <button className={`${styles.actionBtn} ${styles.actionEliminar}`}
        onClick={() => { if(window.confirm(`Delete ${submission.code}?`)) onClose() }}>
        <i className="bi bi-trash" aria-hidden="true"></i> Delete
      </button>

    </div>
  )
}