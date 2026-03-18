// StatusColumn.tsx - v0.4.3c
// Col 3: canonical status fields + workflow fields.
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

type PayVal = 'ok' | 'pending' | 'issue'
type MatVal = 'ok' | 'warning' | 'issue'

const PAY_OPTS:  { v: PayVal; label: string }[] = [
  { v:'ok',      label:'Confirmed' },
  { v:'pending', label:'Pending'   },
  { v:'issue',   label:'Error'     },
]
const MAT_OPTS: { v: MatVal; label: string }[] = [
  { v:'ok',      label:'Received' },
  { v:'warning', label:'Pending'  },
  { v:'issue',   label:'Missing'  },
]
const AWARD_OPTS = ['','inBook','Bronce','Plata','Oro','Grand Laus','Grand Laus Students','Laus de Honor','Laus Aporta']

const bClass = (v: PayVal | MatVal) =>
  v === 'ok' ? styles.ok : v === 'pending' || v === 'warning' ? styles.warn : styles.issue

const payLabel = (v: PayVal):  string => v === 'ok' ? 'Confirmed' : v === 'pending' ? 'Pending' : 'Error'
const matLabel = (v: MatVal):  string => v === 'ok' ? 'Received'  : v === 'warning' ? 'Pending' : 'Missing'

function DropdownBadge<T extends string>({
  value, label, classKey, open, onToggle, opts, onSelect,
}: {
  value: T; label: string; classKey: string; open: boolean;
  onToggle: () => void; opts: { v: T; label: string }[]; onSelect: (v: T) => void;
}) {
  return (
    <div className={styles.statusRow}>
      <span className={styles.statusRowLabel}>{label}</span>
      <div className={styles.statusBadgeWrap}>
        <button
          className={`${styles.statusClickBadge} ${classKey}`}
          onClick={onToggle}
        >
          {opts.find(o => o.v === value)?.label ?? value}
          <i className="bi bi-chevron-down" style={{ fontSize:'6px' }} aria-hidden="true"></i>
        </button>
        {open && (
          <div className={styles.statusDropdown}>
            {opts.map(o => (
              <button key={o.v} className={styles.statusDropdownItem} onClick={() => onSelect(o.v)}>
                {o.label}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export function StatusColumn({ submission }: Props) {
  const [payment,  setPayment]  = useState<PayVal>(submission.payment)
  const [physMat,  setPhysMat]  = useState<MatVal>(submission.material)
  const [digMat,   setDigMat]   = useState<MatVal>(submission.digitalMat ?? 'ok')
  const [payOpen,  setPayOpen]  = useState(false)
  const [phyOpen,  setPhyOpen]  = useState(false)
  const [digOpen,  setDigOpen]  = useState(false)
  const [returnMat,    setReturnMat]    = useState(submission.returnMaterial ?? false)
  const [projSel,      setProjSel]      = useState(submission.projectSelected ?? false)
  const [awarded,      setAwarded]      = useState(!!submission.award)
  const [awardLevel,   setAwardLevel]   = useState(submission.award ?? '')

  const closeAll = () => { setPayOpen(false); setPhyOpen(false); setDigOpen(false) }

  return (
    <div className={styles.statusCol}>
      <span className={styles.colLabel}>Status</span>

      {/* PAYMENT */}
      <DropdownBadge
        value={payment} label="Payment" classKey={bClass(payment)}
        open={payOpen} onToggle={() => { closeAll(); setPayOpen(!payOpen) }}
        opts={PAY_OPTS} onSelect={v => { setPayment(v); setPayOpen(false) }}
      />

      {/* PHYSICAL MAT */}
      <DropdownBadge
        value={physMat} label="Physical mat." classKey={bClass(physMat)}
        open={phyOpen} onToggle={() => { closeAll(); setPhyOpen(!phyOpen) }}
        opts={MAT_OPTS} onSelect={v => { setPhysMat(v); setPhyOpen(false) }}
      />
      {submission.physicalMatDesc && (
        <span className={styles.statusSmallNote}>{submission.physicalMatDesc}</span>
      )}

      {/* DIGITAL MAT */}
      <DropdownBadge
        value={digMat} label="Digital mat." classKey={bClass(digMat)}
        open={digOpen} onToggle={() => { closeAll(); setDigOpen(!digOpen) }}
        opts={MAT_OPTS} onSelect={v => { setDigMat(v); setDigOpen(false) }}
      />

      {/* RETURN MATERIAL */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Return mat.</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${returnMat ? styles.toggled : ''}`}
            onClick={() => setReturnMat(!returnMat)}
          >
            {returnMat ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      {/* PROJECT SELECTED */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Project sel.</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${projSel ? styles.toggled : ''}`}
            onClick={() => setProjSel(!projSel)}
          >
            {projSel ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      <hr className={styles.statusDivider} />

      {/* AWARDED - workflow only */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Awarded</span>
        <div className={styles.toggleRow}>
          <button
            className={`${styles.toggleBtn} ${awarded ? styles.toggled : ''}`}
            onClick={() => setAwarded(!awarded)}
          >
            {awarded ? 'Yes' : 'No'}
          </button>
        </div>
      </div>

      {/* AWARD LEVEL - visible when awarded */}
      {awarded && (
        <div className={styles.statusRow}>
          <span className={styles.statusRowLabel}>Award level</span>
          <select
            className={styles.premioSelect}
            value={awardLevel}
            onChange={e => setAwardLevel(e.target.value)}
          >
            {AWARD_OPTS.map(o => (
              <option key={o} value={o}>{o || '-- select --'}</option>
            ))}
          </select>
        </div>
      )}
    </div>
  )
}