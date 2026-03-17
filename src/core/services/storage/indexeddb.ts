// src/core/services/storage/indexeddb.ts
import Dexie from 'dexie'

export class LausDB extends Dexie {
  workspaces: Dexie.Table<any, string>
  rawSubmissions: Dexie.Table<any, string>
  derivedSubmissions: Dexie.Table<any, string>
  workspaceSubmissions: Dexie.Table<any, string>
  juryContacts: Dexie.Table<any, string>
  templates: Dexie.Table<any, string>
  activityLog: Dexie.Table<any, string>
  savedViews: Dexie.Table<any, string>

  constructor() {
    super('LausOpsConsole')
    this.version(1).stores({
      workspaces: 'id, name, operatorProfile, startedAt, lastSavedAt',
      rawSubmissions: 'id, importedAt',
      derivedSubmissions: 'submissionId',
      workspaceSubmissions: '[workspaceId+submissionId], workspaceId, submissionId',
      juryContacts: 'id, email, status',
      templates: 'id, name, reason, isDefault',
      activityLog: 'id, workspaceId, timestamp',
      savedViews: 'id, workspaceId, name, isSystem',
    })
  }
}

export const db = new LausDB()
