// TopBar/index.tsx - v0.4.3c-rev1
// English tabs - consistent with inspector and KPI language.
import { useState, useEffect } from 'react'
import { useUIStore } from '../../../core/store/uiStore'
import styles from './styles.module.css'

const TABS = [
  { id: 'submissions', label: 'SUBMISSIONS' },
  { id: 'jury',        label: 'JURY'        },
  { id: 'templates',   label: 'TEMPLATES'   },
  { id: 'insights',    label: 'INSIGHTS'    },
  { id: 'helpdesk',    label: 'HELP'        },
  { id: 'laurel',      label: 'AWARDED'     },
  { id: 'settings',    label: 'CONFIG'      },
]

function LiveClock() {
  const [ts, setTs] = useState(() => new Date())
  useEffect(() => {
    const id = setInterval(() => setTs(new Date()), 1000)
    return () => clearInterval(id)
  }, [])
  const p = (n: number) => String(n).padStart(2, '0')
  return (
    <span className={styles.clock}>
      {p(ts.getDate())}/{p(ts.getMonth() + 1)}/{ts.getFullYear()}
      &nbsp;|&nbsp;
      {p(ts.getHours())}:{p(ts.getMinutes())}:{p(ts.getSeconds())}
    </span>
  )
}

export function TopBar() {
  const { activeModule, setActiveModule, language, setLanguage, theme, toggleTheme } = useUIStore()

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  return (
    <header className={styles.topbar}>

      {/* Left: logo + tabs */}
      <div className={styles.left}>
        <div className={styles.logo}>
          <span className={styles.logoPrimary}>LAUS OPS</span>
          <span className={styles.logoSecondary}>console</span>
        </div>
        <nav className={styles.tabs} aria-label="Modules">
          {TABS.map(tab => (
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

      {/* Right: operator + clock + lang + theme */}
      <div className={styles.right}>
        <i className="bi bi-person-circle" aria-hidden="true"></i>
        <span className={styles.operator}>OPERATOR ADG</span>
        <LiveClock />
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
        <button className={styles.themeBtn} onClick={toggleTheme} aria-label="Toggle theme">
          {theme === 'light'
            ? <i className="bi bi-sun" aria-hidden="true"></i>
            : <i className="bi bi-moon-stars" aria-hidden="true"></i>
          }
        </button>
      </div>

    </header>
  )
}