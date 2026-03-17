import { useState } from 'react'
import { Button } from '../../../shared/ui/Button'
import { useUIStore } from '../../../core/store/uiStore'
import styles from './SettingsPanel.module.css'

export const SettingsPanel = () => {
  const { language, setLanguage, theme, toggleTheme } = useUIStore()
  const [hasChanges, setHasChanges] = useState(false)
  const [showReview, setShowReview] = useState(false)

  // Mock settings state
  const [settings, setSettings] = useState({
    exportFormat: 'clean',
    laurelEnabled: true,
    laurelFrequency: 'normal',
  })

  const handleChange = (key: string, value: any) => {
    setSettings(prev => ({ ...prev, [key]: value }))
    setHasChanges(true)
  }

  const handleApply = () => {
    // Here you would persist settings
    setHasChanges(false)
    setShowReview(false)
  }

  const handleCancel = () => {
    // Revert changes
    setSettings({
      exportFormat: 'clean',
      laurelEnabled: true,
      laurelFrequency: 'normal',
    })
    setHasChanges(false)
    setShowReview(false)
  }

  return (
    <div className={styles.settingsPanel}>
      <h2 className={styles.sectionTitle}>Configuració</h2>

      <div className={styles.section}>
        <h3>Idioma / Llengua</h3>
        <div className={styles.optionRow}>
          <Button
            variant={language === 'ca' ? 'primary' : 'secondary'}
            onClick={() => { setLanguage('ca'); setHasChanges(true); }}
          >
            Català
          </Button>
          <Button
            variant={language === 'es' ? 'primary' : 'secondary'}
            onClick={() => { setLanguage('es'); setHasChanges(true); }}
          >
            Castellano
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Tema</h3>
        <div className={styles.optionRow}>
          <Button
            variant={theme === 'light' ? 'primary' : 'secondary'}
            onClick={() => { toggleTheme(); setHasChanges(true); }}
          >
            Clar
          </Button>
          <Button
            variant={theme === 'dark' ? 'primary' : 'secondary'}
            onClick={() => { toggleTheme(); setHasChanges(true); }}
          >
            Fosc
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Exportació per defecte</h3>
        <div className={styles.optionRow}>
          <Button
            variant={settings.exportFormat === 'clean' ? 'primary' : 'secondary'}
            onClick={() => handleChange('exportFormat', 'clean')}
          >
            Net (sense metadades)
          </Button>
          <Button
            variant={settings.exportFormat === 'metadata' ? 'primary' : 'secondary'}
            onClick={() => handleChange('exportFormat', 'metadata')}
          >
            Amb metadades
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Laurel</h3>
        <div className={styles.optionRow}>
          <label>
            <input
              type="checkbox"
              checked={settings.laurelEnabled}
              onChange={(e) => handleChange('laurelEnabled', e.target.checked)}
            />
            Activar
          </label>
        </div>
        {settings.laurelEnabled && (
          <div className={styles.optionRow}>
            <select
              value={settings.laurelFrequency}
              onChange={(e) => handleChange('laurelFrequency', e.target.value)}
              className={styles.select}
            >
              <option value="often">Sovint</option>
              <option value="normal">Normal</option>
              <option value="rare">Rar</option>
              <option value="muted">Silenciós</option>
            </select>
          </div>
        )}
      </div>

      {hasChanges && (
        <div className={styles.actionBar}>
          <Button variant="secondary" onClick={handleCancel}>Cancel·la</Button>
          <Button variant="primary" onClick={handleApply}>Aplica</Button>
        </div>
      )}
    </div>
  )
}