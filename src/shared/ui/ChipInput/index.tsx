import { useState } from 'react'
import styles from './styles.module.css'

interface ChipInputProps {
  chips: string[]
  onChange: (chips: string[]) => void
  placeholder?: string
}

export const ChipInput = ({ chips, onChange, placeholder }: ChipInputProps) => {
  const [input, setInput] = useState('')

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && input.trim()) {
      e.preventDefault()
      onChange([...chips, input.trim()])
      setInput('')
    }
  }

  const removeChip = (index: number) => {
    onChange(chips.filter((_, i) => i !== index))
  }

  return (
    <div className={styles.chipInput}>
      <div className={styles.chipList}>
        {chips.map((chip, i) => (
          <span key={i} className={styles.chip}>
            {chip}
            <button type="button" onClick={() => removeChip(i)} className={styles.remove}>×</button>
          </span>
        ))}
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder={placeholder}
          className={styles.input}
        />
      </div>
    </div>
  )
}