// src/shared/layout/TopBar/index.tsx
import { useUIStore } from '../../../core/store/uiStore'
import { t } from '../../../core/utils/i18n'

export function TopBar() {
  const { language, setLanguage, theme, toggleTheme } = useUIStore()
  return (
    <header className="topbar">
      <div className="logo">LAUS OPS</div>
      <div className="lang-switcher">
        <button className={language === 'ca' ? 'active' : ''} onClick={() => setLanguage('ca')}>CA</button>
        <button className={language === 'es' ? 'active' : ''} onClick={() => setLanguage('es')}>ES</button>
      </div>
      <button onClick={toggleTheme}>{theme === 'light' ? '🌙' : '☀️'}</button>
    </header>
  )
}
