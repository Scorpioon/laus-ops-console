// src/shared/layout/ModuleTabs/index.tsx
import { useUIStore } from '../../../core/store/uiStore'
import { t } from '../../../core/utils/i18n'

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
    <div className="tabs">
      {modules.map(m => (
        <button key={m.id} className={activeModule === m.id ? 'active' : ''} onClick={() => setActiveModule(m.id)}>
          {t(m.label)}
        </button>
      ))}
    </div>
  )
}
