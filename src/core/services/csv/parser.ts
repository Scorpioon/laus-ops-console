// src/core/services/csv/parser.ts
import Papa from 'papaparse'

export interface ParseResult {
  rows: string[][]
  columnCount: number
  headers?: string[]
}

export function parseCSV(file: File): Promise<ParseResult> {
  return new Promise((resolve, reject) => {
    Papa.parse(file, {
      header: false,
      skipEmptyLines: false,
      complete: (results) => {
        const rows = results.data as string[][]
        const columnCount = rows.reduce((max, row) => Math.max(max, row.length), 0)
        // Pad rows to consistent column count
        const paddedRows = rows.map(row => {
          const r = [...row]
          while (r.length < columnCount) r.push('')
          return r
        })
        // If first row looks like headers, extract them
        const headers = paddedRows[0]?.slice() ?? []
        resolve({ rows: paddedRows, columnCount, headers })
      },
      error: reject
    })
  })
}

export function buildCleanExport(
  rawRows: string[][],
  columnOrder: string[],
  submissions: any[],
  editsMap: Map<string, Map<string, string>>
): string {
  // Reconstruct CSV with edits applied
  const headerRow = columnOrder.join(',')
  const dataRows = rawRows.map((row, idx) => {
    const subId = submissions[idx]?.id
    const edits = subId ? editsMap.get(subId) : undefined
    if (edits) {
      // apply edits to row cells based on column index
      for (let i = 0; i < columnOrder.length; i++) {
        const col = columnOrder[i]
        if (edits.has(col)) {
          row[i] = edits.get(col)!
        }
      }
    }
    return row.map(cell => "").join(',')
  })
  return [headerRow, ...dataRows].join('\n')
}
