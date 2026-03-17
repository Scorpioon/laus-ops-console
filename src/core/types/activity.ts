// src/core/types/activity.ts
export interface ActivityLogEntry {
  id: string
  workspaceId: string
  timestamp: number
  operator: string
  actionType: 'single-edit' | 'bulk-edit' | 'discrepancy-resolution' | 'settings-change' | 'row-create' | 'row-delete' | 'export'
  affectedRecords?: string[]
  details: any
  undoable: boolean
}

export interface SavedView {
  id: string
  workspaceId: string
  name: string
  filters: any
  sort: { column: string; direction: 'asc'|'desc' } | null
  visibleColumns: string[]
  isSystem?: boolean
  createdAt: number
}
