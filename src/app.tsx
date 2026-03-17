// src/app.tsx
import { useUIStore } from './core/store'
import { TopBar } from './shared/layout/TopBar'
import { ModuleTabs } from './shared/layout/ModuleTabs'
import { Footer } from './shared/layout/Footer'
import { SubmissionsModule } from './modules/submissions'
import { JuryModule } from './modules/jury'
import { TemplatesModule } from './modules/templates'
import { InsightsModule } from './modules/insights'
import { HelpDeskModule } from './modules/helpdesk'
import { LaurelModule } from './modules/laurel'
import { SettingsModule } from './modules/settings'
import { useUnsavedChanges } from './shared/hooks/useUnsavedChanges'
import './app.css'

function App() {
  const activeModule = useUIStore((state) => state.activeModule)
  useUnsavedChanges()

  return (
    <div className="app">
      <TopBar />
      <ModuleTabs />
      <main className="main-content">
        {activeModule === 'submissions' && <SubmissionsModule />}
        {activeModule === 'jury' && <JuryModule />}
        {activeModule === 'templates' && <TemplatesModule />}
        {activeModule === 'insights' && <InsightsModule />}
        {activeModule === 'helpdesk' && <HelpDeskModule />}
        {activeModule === 'laurel' && <LaurelModule />}
        {activeModule === 'settings' && <SettingsModule />}
      </main>
      <Footer />
    </div>
  )
}

export default App