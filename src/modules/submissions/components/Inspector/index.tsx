// src/modules/submissions/components/Inspector/index.tsx - v0.4.3a
// Wireframe-compliant layout: 3-col upper row + 2-zone lower row.
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
        <span className={styles.codeTag}>{submission.code}</span>
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

        {/* Row 2: links+notes on left, action stack on right */}
        <div className={styles.lowerRow}>
          <LinksRow    submission={submission} />
          <ActionStack submission={submission} onClose={onClose} />
        </div>

      </div>
    </div>
  )
}