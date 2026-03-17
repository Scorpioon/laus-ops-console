import type { ButtonHTMLAttributes, ReactNode } from 'react'
import styles from './styles.module.css'

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
    children: ReactNode
}

export const Button = ({
    children,
    className = '',
    ...props
}: ButtonProps) => {
    return (
        <button className={`${styles.button} ${className}`.trim()} {...props}>
            {children}
        </button>
    )
}