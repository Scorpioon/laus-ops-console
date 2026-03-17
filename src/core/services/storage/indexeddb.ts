import Dexie from 'dexie'

export class LausOpsDatabase extends Dexie {
  workspaces!: Dexie.Table<any, string>
  rawSubmissions!: Dexie.Table<any, string>
  derivedSubmissions!: Dexie.Table<any, string>
  workspaceSubmissions!: Dexie.Table<any, string>
  juryContacts!: Dexie.Table<any, string>
  templates!: Dexie.Table<any, string>
  activityLog!: Dexie.Table<any, string>
  savedViews!: Dexie.Table<any, string>

  constructor() {
    super('lausOpsDatabase')

    this.version(1).stores({
      workspaces: 'id, name, operatorProfile, startedAt, lastSavedAt, lastExportedAt',
      rawSubmissions: 'id, sourceRowIndex, importedAt',
      derivedSubmissions: 'submissionId, programType, derivedAt',
      workspaceSubmissions: 'submissionId, workspaceId, reviewed, flagged, createdAt',
      juryContacts: 'id, email, status, conflictOfInterest',
      templates: 'id, reason, isDefault',
      activityLog: 'id, workspaceId, timestamp, operator, actionType',
      savedViews: 'id, workspaceId, name, isSystem, createdAt',
    })
  }
}

export const db = new LausOpsDatabase()
