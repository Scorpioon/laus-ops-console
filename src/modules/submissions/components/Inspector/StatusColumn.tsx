// Inspector/StatusColumn.tsx - v0.4.3b
// Col 3: PAGAMENT/MATERIAL click-to-dropdown (dark-bg badges),
//        PREMIAT toggle, PREMIO selector.
// Workflow-only state. No write-back to RawSubmission (v0.4.3c).
import { useState } from 'react'
import { type MockSubmission } from '../../mockData'
import styles from './styles.module.css'

interface Props { submission: MockSubmission }

type PaymentVal  = 'ok' | 'pending' | 'issue'
type MaterialVal = 'ok' | 'warning' | 'issue'

const PAYMENT_OPTS: { value: PaymentVal;  label: string }[] = [
  { value: 'ok',      label: 'Rebut'   },
  { value: 'pending', label: 'Pendent' },
  { value: 'issue',   label: 'Error'   },
]
const MATERIAL_OPTS: { value: MaterialVal; label: string }[] = [
  { value: 'ok',      label: 'Rebut'   },
  { value: 'warning', label: 'Pendent' },
  { value: 'issue',   label: 'Falta'   },
]
const PREMIO_OPTS = [
  '',
  'inBook',
  'Bronce',
  'Plata',
  'Oro',
  'Grand Laus',
  'Grand Laus Estudiants',
  'Laus de Honor',
  'Laus Aporta',
]

const badgeClass = (val: PaymentVal | MaterialVal): string => {
  if (val === 'ok')      return styles.ok
  if (val === 'pending') return styles.warn
  if (val === 'warning') return styles.warn
  return styles.issue
}

const payLabel  = (v: PaymentVal):  string => v === 'ok' ? 'Rebut'  : v === 'pending' ? 'Pendent' : 'Error'
const matLabel  = (v: MaterialVal): string => v === 'ok' ? 'Rebut'  : v === 'warning' ? 'Pendent' : 'Falta'

export function StatusColumn({ submission }: Props) {
  const [payment,  setPayment]  = useState<PaymentVal>(submission.payment)
  const [material, setMaterial] = useState<MaterialVal>(submission.material)
  const [payOpen,  setPayOpen]  = useState(false)
  const [matOpen,  setMatOpen]  = useState(false)
  const [premiado, setPremiado] = useState(false)
  const [premio,   setPremio]   = useState('')

  return (
    <div className={styles.statusCol}>
      <span className={styles.colLabel}>Estat</span>

      {/* PAGAMENT */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Pagament</span>
        <div className={styles.statusBadgeWrap}>
          <button
            className={`${styles.statusClickBadge} ${badgeClass(payment)}`}
            onClick={() => { setPayOpen(!payOpen); setMatOpen(false) }}
          >
            {payLabel(payment)}
            <i className="bi bi-chevron-down" style={{ fontSize: '6px' }} aria-hidden="true"></i>
          </button>
          {payOpen && (
            <div className={styles.statusDropdown}>
              {PAYMENT_OPTS.map((o) => (
                <button
                  key={o.value}
                  className={styles.statusDropdownItem}
                  onClick={() => { setPayment(o.value); setPayOpen(false) }}
                >
                  {o.label}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* MATERIAL */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Material</span>
        <div className={styles.statusBadgeWrap}>
          <button
            className={`${styles.statusClickBadge} ${badgeClass(material)}`}
            onClick={() => { setMatOpen(!matOpen); setPayOpen(false) }}
          >
            {matLabel(material)}
            <i className="bi bi-chevron-down" style={{ fontSize: '6px' }} aria-hidden="true"></i>
          </button>
          {matOpen && (
            <div className={styles.statusDropdown}>
              {MATERIAL_OPTS.map((o) => (
                <button
                  key={o.value}
                  className={styles.statusDropdownItem}
                  onClick={() => { setMaterial(o.value); setMatOpen(false) }}
                >
                  {o.label}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* PREMIAT - workflow flag */}
      <div className={styles.statusRow}>
        <span className={styles.statusRowLabel}>Premiat</span>
        <div className={styles.premiadoRow}>
          <button
            className={`${styles.toggleBtn} ${premiado ? styles.toggled : ''}`}
            onClick={() => setPremiado(!premiado)}
          >
            {premiado ? 'S\u00ed' : 'No'}
          </button>
        </div>
      </div>

      {/* PREMIO - visible only when premiado */}
      {premiado && (
        <div className={styles.statusRow}>
          <span className={styles.statusRowLabel}>Premio</span>
          <select
            className={styles.premioSelect}
            value={premio}
            onChange={(e) => setPremio(e.target.value)}
          >
            {PREMIO_OPTS.map((o) => (
              <option key={o} value={o}>{o || '-- selecciona --'}</option>
            ))}
          </select>
        </div>
      )}
    </div>
  )
}