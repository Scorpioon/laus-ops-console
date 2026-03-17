// src/core/store/workspaceStore.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { Workspace } from '../types/workspace'
import type {
  RawSubmission,
  DerivedSubmission,
  WorkspaceSubmission,
} from '../types/submission'

export interface WorkspaceState {
  activeWorkspace: Workspace | null
  rawSubmissions: RawSubmission[]
  derivedSubmissions: DerivedSubmission[]
  workspaceSubmissions: WorkspaceSubmission[]
  setActiveWorkspace: (ws: Workspace | null) => void
  loadWorkspace: (id: string) => Promise<void>
  saveWorkspace: () => Promise<void>
  updateSubmission: (id: string, edits: Record<string, unknown>) => void
}

export const useWorkspaceStore = create<WorkspaceState>()(
  persist(
    (set) => ({
      activeWorkspace: null,
      rawSubmissions: [],
      derivedSubmissions: [],
      workspaceSubmissions: [],
      setActiveWorkspace: (ws) => set({ activeWorkspace: ws }),
      loadWorkspace: async (_id) => {
        // TODO: implement
      },
      saveWorkspace: async () => {
        // TODO: implement
      },
      updateSubmission: (_id, _edits) => {
        // TODO: implement
      },
    }),
    { name: 'workspace-storage' }
  )
)