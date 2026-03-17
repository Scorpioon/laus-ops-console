// src/shared/hooks/useUnsavedChanges.ts
import { useEffect } from 'react'
import { useWorkspaceStore } from '../../core/store/workspaceStore'

export function useUnsavedChanges() {
  const unsaved = useWorkspaceStore((state) => state.activeWorkspace?.unsavedChanges)
  useEffect(() => {
    const handleBeforeUnload = (e: BeforeUnloadEvent) => {
      if (unsaved) {
        e.preventDefault()
        e.returnValue = ''
      }
    }
    window.addEventListener('beforeunload', handleBeforeUnload)
    return () => window.removeEventListener('beforeunload', handleBeforeUnload)
  }, [unsaved])
}
