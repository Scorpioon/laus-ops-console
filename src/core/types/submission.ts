// src/core/types/submission.ts
export interface RawSubmission {
  id: string
  raw: Record<string, string>
  columnOrder: string[]
  sourceRowIndex: number
  importedAt: number
}

export interface MaterialChip {
  value: string
  semantic: 'error' | 'warning' | 'success' | 'info' | 'neutral'
}

export interface DerivedSubmission {
  submissionId: string
  programType?: 'professional' | 'student'
  programTypeSource: 'inferred' | 'manual' | 'unset'
  materialStatus: {
    physical: { raw: string; chips: MaterialChip[]; semantic: 'ok'|'warning'|'issue'|'info'|'neutral' }
    digital: { raw: string; chips: MaterialChip[]; semantic: 'ok'|'warning'|'issue'|'info'|'neutral' }
  }
  paymentStatus: { raw: string; confirmed: boolean | null; semantic: 'confirmed'|'pending'|'issue'|'unknown' }
  flags: Record<string, boolean>
  insightMarkers: string[]
  derivedAt: number
}

export interface WorkspaceSubmission {
  submissionId: string
  workspaceId: string
  edits: { field: string; newValue: string; editedAt: number; editedBy: string }[]
  notes?: string
  reviewed: boolean
  flagged: boolean
  createdAt?: number  // for rows created in workspace
}
