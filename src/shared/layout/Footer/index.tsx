import styles from './styles.module.css'

export function Footer() {
  return (
    <footer className={styles.footer}>
      made with <span style={{ color: '#e44' }}>♥</span> by{' '}
      <a href="https://collapsecreative.com" target="_blank" rel="noopener noreferrer">
        collapsecreative
      </a>{' '}
      para Aina, Pao, Mireia, Eva y el GOAT.
    </footer>
  )
}