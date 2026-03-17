import styles from './styles.module.css'

type StatusBadgeProps = {
  status: string
}

export const StatusBadge = ({ status }: StatusBadgeProps) => {
  return <span className={styles.badge}>{status}</span>
}
