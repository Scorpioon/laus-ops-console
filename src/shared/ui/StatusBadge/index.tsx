import { ReactNode } from 'react'
import styles from './styles.module.css'

type StatusType = 'ok' | 'warning' | 'issue' | 'info' | 'neutral'

interface StatusBadgeProps {
  status: StatusType
  children: ReactNode
}

export const StatusBadge = ({ status, children }: StatusBadgeProps) => {
  return <span className={`${styles.badge} ${styles[status]}`}>{children}</span>
}