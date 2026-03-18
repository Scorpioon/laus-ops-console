// src/modules/submissions/components/Inspector/ActionStack.tsx - v0.4.3a
// Lower-right: DESA / DESCARTAR / CONTACTE / DUPLICAR / (spacer) / ELIMINAR.
// Save, duplicate, delete are stubs until data layer is wired in v0.4.3b.
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props {
  submission: MockSubmission
  onClose:    () => void
}

export function ActionStack({ submission, onClose }: Props) {
  const handleDesa = () => {
    // TODO v0.4.3b: persist workflow fields to WorkspaceSubmission layer.
    // Premio/premiado must never overwrite RawSubmission canonical data.
    alert('Desa - pending implementation (v0.4.3b)')
  }

  const handleDescartar = () => {
    onClose()
  }

  const handleContacte = () => {
    window.open(`mailto:${submission.email}`, '_blank')
  }

  const handleDuplicar = () => {
    // TODO v0.4.3b
    alert('Duplicar - pending implementation (v0.4.3b)')
  }

  const handleEliminar = () => {
    if (window.confirm(`Eliminar inscripcio ${submission.code}?`)) {
      // TODO v0.4.3b: remove from store
      onClose()
    }
  }

  return (
    <div className={styles.actionStack}>

      <button className={`${styles.actionBtn} ${styles.actionDesa}`} onClick={handleDesa}>
        <i className="bi bi-floppy" aria-hidden="true"></i>
        Desa
      </button>

      <button className={`${styles.actionBtn} ${styles.actionDescartar}`} onClick={handleDescartar}>
        <i className="bi bi-x-circle" aria-hidden="true"></i>
        Descartar
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`} onClick={handleContacte}>
        <i className="bi bi-envelope" aria-hidden="true"></i>
        Contacte
      </button>

      <button className={`${styles.actionBtn} ${styles.actionNeutral}`} onClick={handleDuplicar}>
        <i className="bi bi-files" aria-hidden="true"></i>
        Duplicar
      </button>

      {/* Spacer pushes ELIMINAR to the bottom */}
      <div className={styles.actionSpacer}></div>

      <button className={`${styles.actionBtn} ${styles.actionEliminar}`} onClick={handleEliminar}>
        <i className="bi bi-trash" aria-hidden="true"></i>
        Eliminar
      </button>

    </div>
  )
}