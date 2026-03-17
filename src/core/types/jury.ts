// src/core/types/jury.ts
export interface JuryContact {
  id: string
  firstName: string
  lastName: string
  email: string
  phone?: string
  discipline?: string
  categories: string[]
  status: 'invited' | 'confirmed' | 'declined' | 'tentative'
  conflictOfInterest: 'none' | 'possible' | 'recused'
  conflictNotes?: string
  internalNotes?: string
  createdAt: number
  updatedAt: number
}
