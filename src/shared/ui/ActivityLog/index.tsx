import styles from './styles.module.css'

export const ActivityLog = () => {
  // Mock entries
  const entries = [
    { time: '10:32', user: 'Aina', action: 'edició de camp "Pagament confirmat" a LAUS-0123' },
    { time: '10:15', user: 'Pao', action: 'resolució de discrepància mantingut valor A' },
    { time: '09:47', user: 'Mireia', action: 'creació de nova fila' },
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