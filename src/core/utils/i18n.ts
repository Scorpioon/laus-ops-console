// src/core/utils/i18n.ts
import { useUIStore } from '../store/uiStore'

const translations: Record<'ca' | 'es', Record<string, string>> = {
  ca: {
    'nav.submissions': 'Inscripcions',
    'nav.jury': 'Jurat',
    'nav.templates': 'Plantilles',
    'nav.insights': 'Insights',
    'nav.help': 'Ajuda',
    'nav.settings': 'Configuració',
    // ... add all Catalan strings
  },
  es: {
    'nav.submissions': 'Inscripciones',
    'nav.jury': 'Jurado',
    'nav.templates': 'Plantillas',
    'nav.insights': 'Insights',
    'nav.help': 'Ayuda',
    'nav.settings': 'Configuración',
    // ... add all Spanish strings
  }
}

export function t(key: string): string {
  const lang = useUIStore.getState().language
  return translations[lang]?.[key] || key
}

// Simple event for language change
const listeners: (() => void)[] = []
export const onLanguageChange = (fn: () => void) => { listeners.push(fn); return () => { const i = listeners.indexOf(fn); if (i>=0) listeners.splice(i,1); } }
export const emitLanguageChange = () => listeners.forEach(fn => fn())
