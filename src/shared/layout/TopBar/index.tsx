// src/shared/layout/TopBar/index.tsx - v0.4.3a
// Single dense row: LOGO | TABS || KPI placeholder || OPERATOR CLOCK CA/ES THEME
import { useState, useEffect } from 'react'
import { useUIStore } from '../../../core/store/uiStore'
import styles from './styles.module.css'

const TABS = [
  { id: 'submissions', label: 'INSCRIPCIONS' },
  { id: 'jury',        label: 'JURATS'       },
  { id: 'templates',   label: 'PLANTILLES'   },
  { id: 'insights',    label: 'INSIGHTS'     },
  { id: 'helpdesk',    label: 'AJUDA'        },
  { id: 'laurel',      label: 'PREMIATS'     },
  { id: 'settings',    label: 'CONFIG'       },
]

// Isolated clock component - owns its own interval.
// Keeping it separate prevents clock ticks from re-rendering TopBar siblings.
function LiveClock() {
  const [ts, setTs] = useState(() => new Date())
  useEffect(() => {
    const id = setInterval(() => setTs(new Date()), 1000)
    return () => clearInterval(id)
  }, [])
  const pad = (n: number) => String(n).padStart(2, '0')
  return (
    <span className={styles.clock}>
      {pad(ts.getDate())}/{pad(ts.getMonth() + 1)}/{ts.getFullYear()}
      &nbsp;|&nbsp;
      {pad(ts.getHours())}:{pad(ts.getMinutes())}:{pad(ts.getSeconds())}
    </span>
  )
}

export function TopBar() {
  const { activeModule, setActiveModule, language, setLanguage, theme, toggleTheme } = useUIStore()

  // Sync theme attribute to document root
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  return (
    <header className={styles.topbar}>

      {/* LEFT: logo + separator + nav tabs */}
      <div className={styles.left}>
        <div className={styles.logo}>
          <span className={styles.logoPrimary}>LAUS OPS</span>
          <span className={styles.logoSecondary}>console</span>
        </div>
        <span className={styles.divider} aria-hidden="true">|</span>
        <nav className={styles.tabs} aria-label="Modules">
          {TABS.map((tab) => (
            <button
              key={tab.id}
              className={`${styles.tab} ${activeModule === tab.id ? styles.tabActive : ''}`}
              onClick={() => setActiveModule(tab.id)}
            >
              {tab.label}
            </button>
          ))}
        </nav>
      </div>

      {/* CENTER: KPI zone - populated in v0.4.3b */}
      <div className={styles.kpiZone}>
        <span className={styles.divider} aria-hidden="true">||</span>
        <span className={styles.kpiPlaceholder}>&mdash;</span>
        <span className={styles.divider} aria-hidden="true">||</span>
      </div>

      {/* RIGHT: operator name + live clock + language + theme */}
      <div className={styles.right}>
        <i className="bi bi-person-circle" aria-hidden="true"></i>
        <span className={styles.operator}>Operador ADG</span>
        <LiveClock />
        <span className={styles.divider} aria-hidden="true">||</span>
        <div className={styles.langWrap}>
          <button
            className={`${styles.langBtn} ${language === 'ca' ? styles.langActive : ''}`}
            onClick={() => setLanguage('ca')}
          >CA</button>
          <button
            className={`${styles.langBtn} ${language === 'es' ? styles.langActive : ''}`}
            onClick={() => setLanguage('es')}
          >ES</button>
        </div>
        <button
          className={styles.themeBtn}
          onClick={toggleTheme}
          aria-label="Toggle theme"
        >
          {theme === 'light'
            ? <i className="bi bi-sun" aria-hidden="true"></i>
            : <i className="bi bi-moon-stars" aria-hidden="true"></i>
          }
        </button>
      </div>

    </header>
  )
}