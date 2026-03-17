import { ButtonHTMLAttributes, ReactNode } from 'react'
import styles from './styles.module.css'

type ButtonVariant = 'primary' | 'secondary' | 'icon'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode
  variant?: ButtonVariant
}

export const Button = ({
  children,
  variant = 'secondary',
  className = '',
  ...props
}: ButtonProps) => {
  return (
    <button
      className={`${styles.button} ${styles[variant]} ${className}`.trim()}
      {...props}
    >
      {children}
    </button>
  )
}