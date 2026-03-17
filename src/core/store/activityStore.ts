// src/core/store/activityStore.ts
import { create } from 'zustand'
import { ActivityLogEntry } from '../types/activity'

interface ActivityState {
  entries: ActivityLogEntry[]
  addEntry: (entry: Omit<ActivityLogEntry, 'id' | 'timestamp'>) => void
  clear: () => void
}

export const useActivityStore = create<ActivityState>((set) => ({
  entries: [],
  addEntry: (entry) => set((state) => ({
    entries: [{ ...entry, id: crypto.randomUUID(), timestamp: Date.now() }, ...state.entries]
  })),
  clear: () => set({ entries: [] }),
}))
