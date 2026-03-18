// src/shared/ui/ActivityLog/index.tsx - v0.4.3b
import styles from './styles.module.css'

export const ActivityLog = () => {
  const entries = [
    { time: '10:32', user: 'Aina',   action: 'edici\u00f3 de camp "Pagament confirmat" a LAUS-0123' },
    { time: '10:15', user: 'Pao',    action: 'resoluci\u00f3 de discrepÃ n\u00e0cia, mantingut valor A' },
    { time: '09:47', user: 'Mireia', action: 'creaci\u00f3 de nova fila' },
  ]

  return (
    <div className={styles.log}>
      <h4 className={styles.title}>Activitat recent</h4>
      <ul className={styles.list}>
        {entries.map((e, i) => (
          <li key={i} className={styles.entry}>
            <span className={styles.time}>{e.time}</span>
            <span className={styles.user}>{e.user}</span>
            <span className={styles.action}>{e.action}</span>
          </li>
        ))}
      </ul>
    </div>
  )
}