// src/shared/ui/Modal/index.tsx
export const Modal = ({ isOpen, onClose, children }) => isOpen ? <div className="modal-overlay"><div className="modal">{children}</div></div> : null
