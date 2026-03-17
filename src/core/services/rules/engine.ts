// src/core/services/rules/engine.ts
import { DerivedSubmission, RawSubmission } from '../../types/submission'
import { parseChips, serializeChips, CANONICAL_MATERIAL_ORDER } from './canonicalOrder'

export function deriveSubmission(raw: RawSubmission): DerivedSubmission {
  // Simple derivation for demo
  const materialPhysical = raw.raw['Material físico recibido'] || ''
  const chips = parseChips(materialPhysical)
  return {
    submissionId: raw.id,
    materialStatus: {
      physical: {
        raw: materialPhysical,
        chips: chips.map(v => ({ value: v, semantic: 'neutral' })),
        semantic: chips.length ? 'info' : 'neutral'
      },
      digital: { raw: '', chips: [], semantic: 'neutral' }
    },
    paymentStatus: { raw: '', confirmed: null, semantic: 'unknown' },
    flags: {},
    insightMarkers: [],
    derivedAt: Date.now()
  } as any // simplified
}
