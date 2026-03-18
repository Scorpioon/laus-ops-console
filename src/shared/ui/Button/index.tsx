// src/shared/ui/Button/index.tsx - v0.4.3a
import { type ButtonHTMLAttributes, type ReactNode } from 'react'
import styles from './styles.module.css'

// Semantic variants. Legacy primary/secondary/icon kept for backward compat.
type ButtonVariant =
  | 'primary'    // black fill (legacy)
  | 'secondary'  // border only (legacy)
  | 'icon'       // icon-only square (legacy)
  | 'save'       // green fill  - DESA
  | 'discard'    // amber fill  - DESCARTAR
  | 'delete'     // red fill    - ELIMINAR
  | 'neutral'    // border only - CONTACTE / DUPLICAR
  | 'ghost'      // no border, text only

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
  const variantClass = styles[variant] ?? styles.secondary
  return (
    <button
      className={`${styles.button} ${variantClass} ${className}`.trim()}
      {...props}
    >
      {children}
    </button>
  )
}