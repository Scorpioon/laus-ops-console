// src/core/types/template.ts
export interface Template {
  id: string
  name: string
  reason: string
  subject: string
  body: string
  isDefault: boolean
  lastEdited?: number
}
