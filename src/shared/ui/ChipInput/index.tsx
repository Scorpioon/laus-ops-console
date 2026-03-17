type ChipInputProps = {
    chips: string[]
    onChange: (chips: string[]) => void
}

export const ChipInput = ({ chips }: ChipInputProps) => {
    return (
        <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
            {chips.map((chip) => (
                <span key={chip}>{chip}</span>
            ))}
        </div>
    )
}