// src/core/store/index.ts
export * from './workspaceStore'
export * from './uiStore'
export * from './activityStore'

import { useWorkspaceStore } from './workspaceStore'
import { useUIStore } from './uiStore'
import { useActivityStore } from './activityStore'

export type CombinedStoreState = {
    workspace: ReturnType<typeof useWorkspaceStore>
    ui: ReturnType<typeof useUIStore>
    activity: ReturnType<typeof useActivityStore>
}

export function useStore<T>(selector: (state: CombinedStoreState) => T): T {
    const workspace = useWorkspaceStore()
    const ui = useUIStore()
    const activity = useActivityStore()

    return selector({
        workspace,
        ui,
        activity,
    })
}