import { useUIStore } from '../../../core/store/uiStore'
import { t } from '../../../core/utils/i18n'
import styles from './styles.module.css'

const modules = [
  { id: 'submissions', label: 'nav.submissions' },
  { id: 'jury', label: 'nav.jury' },
  { id: 'templates', label: 'nav.templates' },
  { id: 'insights', label: 'nav.insights' },
  { id: 'helpdesk', label: 'nav.help' },
  { id: 'settings', label: 'nav.settings' },
]

export function ModuleTabs() {
  const { activeModule, setActiveModule } = useUIStore()
  return (
    <nav className={styles.tabs}>
      {modules.map((m) => (
        <button
          key={m.id}
          className={`${styles.tab} ${activeModule === m.id ? styles.active : ''}`}
          onClick={() => setActiveModule(m.id)}
        >
          {t(m.label)}
        </button>
      ))}
    </nav>
  )
}