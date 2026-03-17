// src/core/utils/date.ts
import { format, formatDistanceToNow } from 'date-fns'
import { ca, es } from 'date-fns/locale'
import { useUIStore } from '../store/uiStore'

const locales = { ca, es }

export function formatDate(date: number | Date, fmt = 'dd/MM/yyyy'): string {
  const lang = useUIStore.getState().language
  return format(date, fmt, { locale: locales[lang] })
}

export function timeAgo(date: number | Date): string {
  const lang = useUIStore.getState().language
  return formatDistanceToNow(date, { addSuffix: true, locale: locales[lang] })
}
