// src/shared/layout/Footer/index.tsx - v0.4.3b
import styles from './styles.module.css'

export function Footer() {
  return (
    <footer className={styles.footer}>
      made with <span style={{ color: '#e44' }}>&#9829;</span> by{' '}
      <a href="https://collapsecreative.com" target="_blank" rel="noopener noreferrer">
        collapsecreative
      </a>{' '}
      per Aina, Pao, Mireia, Eva i el GOAT.
    </footer>
  )
}