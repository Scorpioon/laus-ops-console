// LinksRow.tsx - v0.4.3c - English labels. Neutral link colors.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  return (
    <div className={styles.linksRow}>

      <div className={styles.linksSection}>
        <span className={styles.colLabel}>Links</span>

        {submission.dropboxUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-dropbox ${styles.linkIcon}`} aria-hidden="true"></i>
            <a href={submission.dropboxUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>
              Dropbox
            </a>
            <button className={styles.editBtn} aria-label="Edit">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}

        {submission.projectUrl && (
          <div className={styles.linkItem}>
            <i className={`bi bi-box-arrow-up-right ${styles.linkIcon}`} aria-hidden="true"></i>
            <a href={submission.projectUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>
              Project URL
            </a>
            <button className={styles.editBtn} aria-label="Edit">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        )}
      </div>

      <div className={styles.notesSection}>
        <span className={styles.notesLabel}>Internal notes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={e => setNotes(e.target.value)}
          placeholder="Internal notes..."
        />
      </div>

    </div>
  )
}