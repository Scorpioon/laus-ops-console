import { useUIStore } from '../store/uiStore'

const translations: Record<'ca' | 'es', Record<string, string>> = {
  ca: {
    'nav.submissions': 'Inscripcions',
    'nav.jury': 'Jurat',
    'nav.templates': 'Plantilles',
    'nav.insights': 'Insights',
    'nav.help': 'Ajuda',
    'nav.settings': 'Configuració',
    'topbar.noWorkspace': 'Cap espai de treball actiu',
    'topbar.toggleTheme': 'Canvia tema',
    'settings.title': 'Configuració',
    'settings.language': 'Idioma',
    'settings.theme': 'Tema',
    'settings.export': 'Exportació per defecte',
    'settings.laurel': 'Laurel',
    'settings.apply': 'Aplica',
    'settings.cancel': 'Cancel·la',
  },
  es: {
    'nav.submissions': 'Inscripciones',
    'nav.jury': 'Jurado',
    'nav.templates': 'Plantillas',
    'nav.insights': 'Insights',
    'nav.help': 'Ayuda',
    'nav.settings': 'Configuración',
    'topbar.noWorkspace': 'Sin espacio de trabajo activo',
    'topbar.toggleTheme': 'Cambiar tema',
    'settings.title': 'Configuración',
    'settings.language': 'Idioma',
    'settings.theme': 'Tema',
    'settings.export': 'Exportación por defecto',
    'settings.laurel': 'Laurel',
    'settings.apply': 'Aplicar',
    'settings.cancel': 'Cancelar',
  },
}

export function t(key: string): string {
  const lang = useUIStore.getState().language
  return translations[lang]?.[key] || key
}

// Simple event for language change
const listeners: (() => void)[] = []
export const onLanguageChange = (fn: () => void) => {
  listeners.push(fn)
  return () => {
    const i = listeners.indexOf(fn)
    if (i >= 0) listeners.splice(i, 1)
  }
}
export const emitLanguageChange = () => listeners.forEach(fn => fn())