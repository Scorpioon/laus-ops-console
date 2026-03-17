import { useUIStore } from '../../../core/store/uiStore'
import { t } from '../../../core/utils/i18n'
import styles from './styles.module.css'

const modules = [
  { id: 'submissions', label: 'Inscripcions' },
  { id: 'jury', label: 'Jurats' },
  { id: 'templates', label: 'Plantilles' },
  { id: 'insights', label: 'Insights' },
  { id: 'helpdesk', label: 'Ajuda' },
  { id: 'laurel', label: 'Premiats' },
  { id: 'settings', label: 'Config' },
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
