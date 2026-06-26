// Illustrative button component — typed props, accessible by default.

interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
}

export function Button({ label, onClick, disabled = false }: ButtonProps) {
  return (
    <button type="button" onClick={onClick} disabled={disabled} aria-label={label}>
      {label}
    </button>
  );
}
