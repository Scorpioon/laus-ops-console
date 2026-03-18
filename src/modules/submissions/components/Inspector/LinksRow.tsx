// Inspector/LinksRow.tsx - v0.4.3b
// Lower-left: Enlla\u00e7os (Dropbox + Projecte with pencil) + Notes internes textarea.
// Links use neutral color, never browser-default blue.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  return (
    <div className={styles.linksRow}>

      <div className={styles.linksSection}>
        <span className={styles.colLabel}>Enlla\u00e7os</span>

        {submission.dropboxUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-dropbox ${styles.linkIcon}`} aria-hidden="true"></i>
            <a
              href={submission.dropboxUrl}
              target="_blank"
              rel="noopener noreferrer"
              className={styles.linkAnchor}
            >
              Dropbox
            </a>
            <button className={styles.editBtn} aria-label="Edita">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}

        {submission.projectUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-box-arrow-up-right ${styles.linkIcon}`} aria-hidden="true"></i>
            <a
              href={submission.projectUrl}
              target="_blank"
              rel="noopener noreferrer"
              className={styles.linkAnchor}
            >
              Projecte
            </a>
            <button className={styles.editBtn} aria-label="Edita">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}
      </div>

      <div className={styles.notesSection}>
        <span className={styles.notesLabel}>Notes internes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Notes internes..."
        />
      </div>

    </div>
  )
}