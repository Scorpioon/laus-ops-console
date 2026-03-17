// src/core/store/workspaceStore.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { Workspace, RawSubmission, DerivedSubmission, WorkspaceSubmission } from '../types/workspace'

interface WorkspaceState {
  activeWorkspace: Workspace | null
  rawSubmissions: RawSubmission[]
  derivedSubmissions: DerivedSubmission[]
  workspaceSubmissions: WorkspaceSubmission[]
  setActiveWorkspace: (ws: Workspace | null) => void
  loadWorkspace: (id: string) => Promise<void>
  saveWorkspace: () => Promise<void>
  updateSubmission: (id: string, edits: any) => void
}

export const useWorkspaceStore = create<WorkspaceState>()(
  persist(
    (set, get) => ({
      activeWorkspace: null,
      rawSubmissions: [],
      derivedSubmissions: [],
      workspaceSubmissions: [],
      setActiveWorkspace: (ws) => set({ activeWorkspace: ws }),
      loadWorkspace: async (id) => { /* TODO */ },
      saveWorkspace: async () => { /* TODO */ },
      updateSubmission: (id, edits) => { /* TODO */ },
    }),
    { name: 'workspace-storage' }
  )
)
