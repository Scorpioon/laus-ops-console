// src/core/types/workspace.ts
import { RawSubmission, DerivedSubmission, WorkspaceSubmission } from './submission'
import { JuryContact } from './jury'
import { Template } from './template'
import { SavedView } from './activity'

export interface Workspace {
  id: string
  name: string
  operatorProfile: string
  startedAt: number
  lastSavedAt?: number
  lastExportedAt?: number
  rawSubmissionIds: string[]
  juryContactIds: string[]
  templateIds: string[]
  savedViewIds: string[]
  unsavedChanges: boolean
}
