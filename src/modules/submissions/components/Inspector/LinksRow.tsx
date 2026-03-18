// LinksRow.tsx - v0.4.3d
// C4: two compact sub-cols (Dropbox | Project URL) + compact notes below.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

export function LinksRow({ submission }: Props) {
  const [notes, setNotes] = useState(submission.internalNotes ?? '')

  const shortUrl = (url: string) => {
    try { return new URL(url).hostname } catch { return url }
  }

  return (
    <div className={styles.linksRow}>

      {/* Top: Dropbox | Project URL as two compact sub-cols */}
      <div className={styles.linksCols}>

        <div className={styles.linkSubCol}>
          <span className={styles.subColLabel}>Dropbox</span>
          <div className={styles.linkSubVal}>
            <i className="bi bi-dropbox" style={{ fontSize:'11px', color:'var(--text3)', flexShrink: 0 }} aria-hidden="true"></i>
            {submission.dropboxUrl
              ? <a href={submission.dropboxUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>{shortUrl(submission.dropboxUrl)}</a>
              : <span className={styles.linkEmpty}>{'â€”'}</span>
            }
            <button className={styles.editBtn} aria-label="Edit Dropbox">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        </div>

        <div className={styles.linkSubColDiv}></div>

        <div className={styles.linkSubCol}>
          <span className={styles.subColLabel}>Project URL</span>
          <div className={styles.linkSubVal}>
            <i className="bi bi-box-arrow-up-right" style={{ fontSize:'11px', color:'var(--text3)', flexShrink: 0 }} aria-hidden="true"></i>
            {submission.projectUrl
              ? <a href={submission.projectUrl} target="_blank" rel="noopener noreferrer" className={styles.linkAnchor}>{shortUrl(submission.projectUrl)}</a>
              : <span className={styles.linkEmpty}>{'â€”'}</span>
            }
            <button className={styles.editBtn} aria-label="Edit Project URL">
              <i className="bi bi-pencil" aria-hidden="true"></i>
            </button>
          </div>
        </div>

      </div>

      {/* Bottom: compact internal notes */}
      <div className={styles.notesCompact}>
        <span className={styles.notesLabel}>Internal notes</span>
        <textarea
          className={styles.notesTextarea}
          value={notes}
          onChange={e => setNotes(e.target.value)}
          placeholder="Notes..."
        />
      </div>

    </div>
  )
}