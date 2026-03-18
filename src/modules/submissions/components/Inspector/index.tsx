// Inspector/index.tsx - v0.4.3d
// Panel title: "Ficha de proyecto". Code is a field inside C1.
import { type MockSubmission } from '../../mockData'
import { InfoColumn }    from './InfoColumn'
import { ContactColumn } from './ContactColumn'
import { StatusColumn }  from './StatusColumn'
import { LinksRow }      from './LinksRow'
import { ActionStack }   from './ActionStack'
import styles from './styles.module.css'

interface InspectorProps {
  submission: MockSubmission
  onClose:    () => void
  onSelectId: (id: string) => void
}

export function Inspector({ submission, onClose, onSelectId }: InspectorProps) {
  return (
    <div className={styles.panel}>

      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>Ficha de proyecto</span>
        <button className={styles.closeBtn} onClick={onClose} aria-label="Close">
          <i className="bi bi-x-lg" aria-hidden="true"></i>
        </button>
      </div>

      <div className={styles.panelBody}>

        {/* Row 1: exactly 3 equal columns */}
        <div className={styles.upperGrid}>
          <InfoColumn    submission={submission} />
          <ContactColumn submission={submission} onSelectId={onSelectId} />
          <StatusColumn  submission={submission} />
        </div>

        {/* Row 2: wide links+notes (C4) + narrow action rail (C5) */}
        <div className={styles.lowerRow}>
          <LinksRow    submission={submission} />
          <ActionStack submission={submission} onClose={onClose} />
        </div>

      </div>
    </div>
  )
}