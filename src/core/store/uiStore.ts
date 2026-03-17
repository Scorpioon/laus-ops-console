// src/core/store/uiStore.ts
import { create } from 'zustand'

interface UIState {
  activeModule: string
  language: 'ca' | 'es'
  theme: 'light' | 'dark'
  setActiveModule: (mod: string) => void
  setLanguage: (lang: 'ca' | 'es') => void
  toggleTheme: () => void
}

export const useUIStore = create<UIState>((set) => ({
  activeModule: 'submissions',
  language: 'ca',
  theme: 'light',
  setActiveModule: (mod) => set({ activeModule: mod }),
  setLanguage: (lang) => set({ language: lang }),
  toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
}))
