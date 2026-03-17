// src/core/services/rules/canonicalOrder.ts
export const CANONICAL_MATERIAL_ORDER = [
  'NO PERMÈS',
  'No',
  'Rebut',
  'Error/Falta',
  'Reclamat',
  'No trobat',
  'Amb retard'
] as const

export const DELIMITER = ' + '

export function serializeChips(chips: string[]): string {
  // sort according to canonical order
  const ordered = chips.sort((a, b) => {
    const ia = CANONICAL_MATERIAL_ORDER.indexOf(a as any)
    const ib = CANONICAL_MATERIAL_ORDER.indexOf(b as any)
    if (ia === -1 && ib === -1) return a.localeCompare(b)
    if (ia === -1) return 1
    if (ib === -1) return -1
    return ia - ib
  })
  return ordered.join(DELIMITER)
}

export function parseChips(raw: string): string[] {
  // simple split on common delimiters
  const parts = raw.split(/\s*[+,\|]\s*/).map(s => s.trim()).filter(Boolean)
  return parts
}
