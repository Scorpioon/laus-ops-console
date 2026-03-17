// src/main.tsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './app'
import './core/utils/i18n'  // initialise i18n

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
