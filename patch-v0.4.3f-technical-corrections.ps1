#Requires -Version 5.1
# =============================================================================
# LAUS OPS CONSOLE - patch v0.4.3f - Technical Correction Pass
#
# Apply AFTER v0.4.3c + v0.4.3c-rev1 + v0.4.3d + v0.4.3e (partial).
# Run from project root:
#   cd K:\DEVKIT\projects\laus-ops-console\laus-ops-console
#   .\patch-v0.4.3f-technical-corrections.ps1
#
# Files changed (3):
#   src\modules\submissions\components\Inspector\styles.module.css
#       PRIMARY: upperGrid flex:1 -> fills panelBody, eliminates empty whitespace
#       SECONDARY: ADG pastel color system on action btns / badges / toggles
#   src\modules\settings\components\SettingsPanel.tsx
#       Mojibake fix: Configuracio, Catala, Exportacio, Silencis, Cancel.la
#   src\app.tsx
#       Remove dead ModuleTabs import/usage (returns null, zero visual impact)
# =============================================================================

Set-StrictMode -Off
$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path

if (!(Test-Path (Join-Path $root 'package.json'))) {
    Write-Host ""
    Write-Host "ERROR: package.json not found in: $root" -ForegroundColor Red
    Write-Host "Navigate to the project root first." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

function Write-File {
    param([string]$Rel, [string]$Content)
    $full = Join-Path $root $Rel
    $dir  = Split-Path $full -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($full, $Content, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  OK  $Rel" -ForegroundColor Green
}

Write-Host ""
Write-Host "LAUS OPS CONSOLE - patch v0.4.3f" -ForegroundColor Cyan
Write-Host "Technical Correction Pass" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray
Write-Host ""


# =============================================================================
# 01  Inspector\styles.module.css
#
# STRUCTURAL FIX:
#   .upperGrid gains flex:1 (was flex-shrink:0 only).
#   This makes upperGrid grow to fill all panelBody space not claimed by
#   lowerRow, eliminating the empty whitespace below the action rail.
#   The fix chain:
#     panelBody (flex:1, flex-direction:column)
#       upperGrid (flex:1)         <- FILLS remaining space
#       lowerRow  (flex:0 0 auto)  <- stays fixed
#   Inner columns (infoCol/contactCol/statusCol) keep overflow-y:auto ->
#   they scroll if content exceeds height.
#
# COLOR FIX:
#   Replace dark neon action buttons/badges/toggles with ADG pastel system.
#   Same rule as StatusBadge: text=accent / border=accent+#33 / bg=pastel.
# =============================================================================
Write-File 'src\modules\submissions\components\Inspector\styles.module.css' @'
/* Inspector/styles.module.css - v0.4.3f
   STRUCTURAL: upperGrid flex:1 eliminates empty whitespace below lowerRow.
   COLOR: ADG pastel system throughout. */

/* Outer panel -------------------------------------------------------------- */
.panel {
  flex: 0 0 50%;
  max-width: 50%;
  background: var(--bg);
  border-left: 1px solid var(--border2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.panelHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 12px;
  min-height: 32px;
  border-bottom: 1px solid var(--border2);
  background: var(--bg2);
  flex-shrink: 0;
}

.panelTitle {
  font-size: 8.5px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--text2);
}

.closeBtn {
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border2);
  border-radius: var(--radius);
  background: none;
  color: var(--text2);
  cursor: pointer;
  font-size: 12px;
  transition: all 0.1s;
}
.closeBtn:hover { border-color: var(--border); color: var(--text); background: var(--bg3); }

.panelBody {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

/* Row 1: 3-col grid
   flex:1  = grow to fill all panelBody space not taken by lowerRow
   min-height:190px = minimum height floor regardless of content
   Inner columns have overflow-y:auto so they scroll if content overflows */
.upperGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  border-bottom: 1px solid var(--border2);
  flex: 1;
  min-height: 190px;
  min-width: 0;
}

/* Row 2: compact fixed-height zone ---------------------------------------- */
.lowerRow {
  display: flex;
  flex: 0 0 auto;
  min-height: 0;
  max-height: 130px;
  overflow: hidden;
}

/* Shared section label ----------------------------------------------------- */
.colLabel {
  font-size: 7px;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: var(--text3);
  margin-bottom: 6px;
  flex-shrink: 0;
  display: block;
}

/* C1 - InfoColumn ---------------------------------------------------------- */
.infoCol {
  padding: 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.infoRow {
  display: flex;
  align-items: center;
  gap: 6px;
  min-height: 26px;
  padding: 2px 0;
  border-bottom: 1px solid var(--border3);
}
.infoRow:last-child { border-bottom: none; }

.infoKey {
  width: 58px;
  flex-shrink: 0;
  font-size: 7px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text3);
}

.infoVal {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 4px;
  min-height: 24px;
  padding: 3px 7px;
  background: var(--bg2);
  border: 1px solid var(--border2);
  border-radius: var(--radius);
}

.infoValText {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.inlineEdit {
  flex-shrink: 0;
  width: 14px;
  height: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: none;
  color: var(--text3);
  cursor: pointer;
  font-size: 9px;
  padding: 0;
  transition: color 0.1s;
}
.inlineEdit:hover { color: var(--text); }

.infoValStatic {
  flex: 1;
  font-size: 10.5px;
  color: var(--text2);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* C2 - ContactColumn ------------------------------------------------------- */
.contactCol {
  padding: 10px;
  border-right: 1px solid var(--border2);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.contactBlock {
  display: flex;
  flex-direction: column;
  margin-bottom: 7px;
  padding-bottom: 7px;
  border-bottom: 1px solid var(--border3);
}
.contactBlock:last-of-type { border-bottom: none; margin-bottom: 0; }

.contactField {
  display: flex;
  align-items: center;
  gap: 5px;
  min-height: 22px;
  border-bottom: 1px solid var(--border3);
}
.contactField:last-child { border-bottom: none; }

.cfLabel {
  font-size: 7px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text3);
  width: 60px;
  flex-shrink: 0;
}

.cfVal {
  flex: 1;
  font-size: 10.5px;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.cfVal a { color: var(--text2); text-decoration: none; border-bottom: 1px solid var(--border2); }
.cfVal a:hover { color: var(--text); border-bottom-color: var(--text); }

.editBtn {
  width: 16px; height: 16px;
  display: flex; align-items: center; justify-content: center;
  border: none; background: none; color: var(--text3);
  cursor: pointer; font-size: 10px; flex-shrink: 0; padding: 0; transition: color 0.1s;
}
.editBtn:hover { color: var(--text); }

/* Other entries compact chip grid */
.altresSection { margin-top: 5px; }
.altresLabel {
  font-size: 7px; letter-spacing: 0.14em; text-transform: uppercase;
  color: var(--text3); margin-bottom: 4px; display: block;
}
.altresGrid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2px; }
.codeBadge {
  display: inline-flex; align-items: center; justify-content: center;
  gap: 2px; font-size: 7.5px; padding: 2px 4px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text3);
  cursor: pointer; transition: all 0.08s; font-family: monospace;
}
.codeBadge:hover { border-color: var(--border); background: var(--bg3); color: var(--text); }

/* C3 - StatusColumn -------------------------------------------------------- */
.statusCol {
  padding: 10px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-height: 0;
}

.statusRow { display: flex; flex-direction: column; gap: 3px; }

.statusRowLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3);
}

.statusSmallNote {
  font-size: 8.5px; color: var(--text3);
  font-style: italic; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}

.statusDivider { border: none; border-top: 1px solid var(--border2); margin: 2px 0; }

.statusBadgeWrap { position: relative; display: inline-block; }

/* Status click-badges: ADG pastel system */
.statusClickBadge {
  display: inline-flex; align-items: center; gap: 4px;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em;
  text-transform: uppercase; padding: 3px 8px;
  border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s;
}
.statusClickBadge:hover { opacity: 0.82; }

.statusClickBadge.ok    { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
.statusClickBadge.warn  { background: #FFFBEB; color: #B45309; border-color: #B4530933; }
.statusClickBadge.issue { background: #FFF0F6; color: #C4294A; border-color: #C4294A33; }

[data-theme="dark"] .statusClickBadge.ok    { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .statusClickBadge.warn  { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .statusClickBadge.issue { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }

.statusDropdown {
  position: absolute; top: calc(100% + 2px); left: 0; z-index: 50;
  background: var(--bg); border: 1px solid var(--border);
  border-radius: var(--radius); box-shadow: 0 2px 10px rgba(0,0,0,.1);
  min-width: 110px; overflow: hidden;
}
.statusDropdownItem {
  display: block; width: 100%; padding: 6px 10px;
  text-align: left; font-size: 8px; font-weight: 600;
  letter-spacing: 0.07em; text-transform: uppercase;
  background: none; border: none; border-bottom: 1px solid var(--border3);
  color: var(--text2); cursor: pointer; transition: background 0.08s;
}
.statusDropdownItem:last-child { border-bottom: none; }
.statusDropdownItem:hover { background: var(--hover); color: var(--text); }

.toggleRow { display: flex; align-items: center; gap: 5px; }

/* Toggle: neutral at rest / green-pastel when active */
.toggleBtn {
  display: inline-flex; align-items: center; justify-content: center;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em;
  text-transform: uppercase; padding: 3px 10px;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: #F9FAFB; color: #374151;
  cursor: pointer; transition: all 0.1s; min-width: 36px;
}
.toggleBtn.toggled { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
[data-theme="dark"] .toggleBtn { background: var(--bg2); color: var(--text3); border-color: var(--border2); }
[data-theme="dark"] .toggleBtn.toggled { background: var(--s-ok-bg); color: var(--s-ok); border-color: var(--s-ok); }

.premioSelect {
  width: 100%; padding: 4px 24px 4px 7px;
  font-size: 9px; border: 1px solid var(--border2);
  border-radius: var(--radius); background: var(--bg2); color: var(--text2);
  cursor: pointer; appearance: none; outline: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='4'%3E%3Cpath d='M0 0l4 4 4-4z' fill='%23999'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 6px center;
}
.premioSelect:focus { border-color: var(--border); color: var(--text); }

/* C4 - LinksRow ------------------------------------------------------------ */
.linksRow {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-right: 1px solid var(--border2);
  overflow: hidden;
}

.linksCols { display: flex; flex: 0 0 auto; border-bottom: 1px solid var(--border2); }

.linkSubCol {
  flex: 1; display: flex; flex-direction: column;
  gap: 2px; padding: 6px 8px; min-width: 0;
}
.linkSubColDiv { flex: 0 0 1px; background: var(--border2); align-self: stretch; }

.subColLabel {
  font-size: 7px; letter-spacing: 0.16em;
  text-transform: uppercase; color: var(--text3);
}

.linkSubVal {
  display: flex; align-items: center; gap: 5px;
  padding: 3px 6px; background: var(--bg2);
  border: 1px solid var(--border2); border-radius: var(--radius);
  min-height: 24px; min-width: 0;
}

.linkAnchor {
  flex: 1; font-size: 9.5px; color: var(--text2);
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  text-decoration: none; border-bottom: 1px solid var(--border2);
}
.linkAnchor:hover { color: var(--text); border-bottom-color: var(--text); }

.linkEmpty { font-size: 9.5px; color: var(--text3); flex: 1; }

.notesCompact {
  flex: 1; display: flex; flex-direction: column;
  padding: 5px 8px; gap: 3px; min-height: 0;
}

.notesLabel {
  font-size: 7px; letter-spacing: 0.18em;
  text-transform: uppercase; color: var(--text3); flex-shrink: 0;
}

.notesTextarea {
  flex: 1; min-height: 28px; max-height: 50px;
  padding: 4px 6px; font-size: 9.5px; line-height: 1.45;
  border: 1px solid var(--border2); border-radius: var(--radius);
  background: var(--bg2); color: var(--text2);
  resize: none; outline: none; font-family: inherit;
  transition: border-color 0.1s;
}
.notesTextarea:focus { border-color: var(--border); color: var(--text); background: var(--bg); }

/* C5 - ActionStack - fixed narrow rail ------------------------------------- */
.actionStack {
  flex: 0 0 108px;
  width: 108px;
  padding: 6px 7px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: var(--bg2);
  flex-shrink: 0;
  overflow: hidden;
}

.actionBtn {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; width: 100%; height: 26px;
  font-size: 8px; font-weight: 600; letter-spacing: 0.07em;
  text-transform: uppercase; border: 1px solid; border-radius: var(--radius);
  cursor: pointer; transition: opacity 0.1s; white-space: nowrap; flex-shrink: 0;
}
.actionBtn:hover:not(:disabled) { opacity: 0.82; }
.actionBtn:disabled { opacity: 0.35; cursor: default; }

/* ADG pastel action buttons */
.actionDesa      { background: #DCFCE7; color: #15803D; border-color: #15803D33; }
.actionDescartar { background: #FFFBEB; color: #B45309; border-color: #B4530933; }
.actionNeutral   { background: #F9FAFB; color: #374151; border-color: #37415133; }
.actionNeutral:hover:not(:disabled) { background: var(--bg3); color: var(--text); border-color: var(--border); }
.actionSpacer    { flex: 0 0 6px; }
.actionEliminar  { background: #FFF0F6; color: #C4294A; border-color: #C4294A33; }

[data-theme="dark"] .actionDesa      { background: var(--s-ok-bg);   color: var(--s-ok);   border-color: var(--s-ok); }
[data-theme="dark"] .actionDescartar { background: var(--s-warn-bg); color: var(--s-warn); border-color: var(--s-warn); }
[data-theme="dark"] .actionNeutral   { background: var(--bg3); color: var(--text2); border-color: var(--border2); }
[data-theme="dark"] .actionEliminar  { background: var(--s-des-bg);  color: var(--s-des);  border-color: var(--s-des); }
'@


# =============================================================================
# 02  src\modules\settings\components\SettingsPanel.tsx
#     Mojibake fixes only. Logic unchanged.
#     Configuraci[mojibake]  -> Configuraci\u00f3
#     Catal[mojibake]        -> Catal\u00e0
#     Exportaci[mojibake]    -> Exportaci\u00f3
#     Silenci[mojibake]s     -> Silenci\u00f3s
#     Cancel[mojibake]la     -> Cancel\u00b7la
# =============================================================================
Write-File 'src\modules\settings\components\SettingsPanel.tsx' @'
// SettingsPanel.tsx - v0.4.3f (mojibake fixed, logic unchanged)
import { useState } from 'react';
import { Button } from '../../../shared/ui/Button';
import { useUIStore } from '../../../core/store/uiStore';
import styles from './SettingsPanel.module.css';

export const SettingsPanel = () => {
  const { language, setLanguage, theme, toggleTheme } = useUIStore();
  const [hasChanges, setHasChanges] = useState(false);

  const [settings, setSettings] = useState({
    exportFormat: 'clean',
    laurelEnabled: true,
    laurelFrequency: 'normal',
  });

  const handleChange = (key: string, value: any) => {
    setSettings(prev => ({ ...prev, [key]: value }));
    setHasChanges(true);
  };

  const handleApply = () => { setHasChanges(false); };

  const handleCancel = () => {
    setSettings({ exportFormat: 'clean', laurelEnabled: true, laurelFrequency: 'normal' });
    setHasChanges(false);
  };

  return (
    <div className={styles.settingsPanel}>
      <h2 className={styles.sectionTitle}>Configuraci\u00f3</h2>

      <div className={styles.section}>
        <h3>Idioma / Llengua</h3>
        <div className={styles.optionRow}>
          <Button
            variant={language === 'ca' ? 'primary' : 'secondary'}
            onClick={() => { setLanguage('ca'); setHasChanges(true); }}
          >
            Catal\u00e0
          </Button>
          <Button
            variant={language === 'es' ? 'primary' : 'secondary'}
            onClick={() => { setLanguage('es'); setHasChanges(true); }}
          >
            Castellano
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Tema</h3>
        <div className={styles.optionRow}>
          <Button
            variant={theme === 'light' ? 'primary' : 'secondary'}
            onClick={() => { toggleTheme(); setHasChanges(true); }}
          >
            Clar
          </Button>
          <Button
            variant={theme === 'dark' ? 'primary' : 'secondary'}
            onClick={() => { toggleTheme(); setHasChanges(true); }}
          >
            Fosc
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Exportaci\u00f3 per defecte</h3>
        <div className={styles.optionRow}>
          <Button
            variant={settings.exportFormat === 'clean' ? 'primary' : 'secondary'}
            onClick={() => handleChange('exportFormat', 'clean')}
          >
            Net (sense metadades)
          </Button>
          <Button
            variant={settings.exportFormat === 'metadata' ? 'primary' : 'secondary'}
            onClick={() => handleChange('exportFormat', 'metadata')}
          >
            Amb metadades
          </Button>
        </div>
      </div>

      <div className={styles.section}>
        <h3>Laurel</h3>
        <div className={styles.optionRow}>
          <label>
            <input
              type="checkbox"
              checked={settings.laurelEnabled}
              onChange={(e) => handleChange('laurelEnabled', e.target.checked)}
            />
            {' '}Activar
          </label>
        </div>
        {settings.laurelEnabled && (
          <div className={styles.optionRow}>
            <select
              value={settings.laurelFrequency}
              onChange={(e) => handleChange('laurelFrequency', e.target.value)}
              className={styles.select}
            >
              <option value="often">Sovint</option>
              <option value="normal">Normal</option>
              <option value="rare">Rar</option>
              <option value="muted">Silenci\u00f3s</option>
            </select>
          </div>
        )}
      </div>

      {hasChanges && (
        <div className={styles.actionBar}>
          <Button variant="secondary" onClick={handleCancel}>Cancel\u00b7la</Button>
          <Button variant="primary" onClick={handleApply}>Aplica</Button>
        </div>
      )}
    </div>
  );
};
'@


# =============================================================================
# 03  src\app.tsx
#     Remove ModuleTabs import and JSX usage.
#     ModuleTabs returns null and has no CSS - zero visual or layout impact.
#     Safe to remove: no other file imports it.
# =============================================================================
Write-File 'src\app.tsx' @'
// src/app.tsx - v0.4.3f (ModuleTabs removed - was returning null)
import { useUIStore } from './core/store'
import { TopBar } from './shared/layout/TopBar'
import { Footer } from './shared/layout/Footer'
import { SubmissionsModule } from './modules/submissions'
import { JuryModule } from './modules/jury'
import { TemplatesModule } from './modules/templates'
import { InsightsModule } from './modules/insights'
import { HelpDeskModule } from './modules/helpdesk'
import { LaurelModule } from './modules/laurel'
import { SettingsModule } from './modules/settings'
import { useUnsavedChanges } from './shared/hooks/useUnsavedChanges'
import './app.css'

function App() {
  const activeModule = useUIStore((state) => state.activeModule)
  useUnsavedChanges()

  return (
    <div className="app">
      <TopBar />
      <main className="main-content">
        {activeModule === 'submissions' && <SubmissionsModule />}
        {activeModule === 'jury'        && <JuryModule />}
        {activeModule === 'templates'   && <TemplatesModule />}
        {activeModule === 'insights'    && <InsightsModule />}
        {activeModule === 'helpdesk'    && <HelpDeskModule />}
        {activeModule === 'laurel'      && <LaurelModule />}
        {activeModule === 'settings'    && <SettingsModule />}
      </main>
      <Footer />
    </div>
  )
}

export default App
'@


# =============================================================================
Write-Host ""
Write-Host "patch v0.4.3f complete - 3 files written." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "What changed:" -ForegroundColor DarkGray
Write-Host "  Inspector/styles   STRUCTURAL: upperGrid flex:1 fills panelBody" -ForegroundColor DarkGray
Write-Host "                     -> empty whitespace below lowerRow is eliminated" -ForegroundColor DarkGray
Write-Host "                     -> inner columns keep overflow-y:auto for scroll" -ForegroundColor DarkGray
Write-Host "                     COLOR: ADG pastel on action btns/badges/toggles" -ForegroundColor DarkGray
Write-Host "                     (was dark neon from pre-v0.4.3e state)" -ForegroundColor DarkGray
Write-Host "  SettingsPanel.tsx  Mojibake fixed: Configuracio/Catala/Exportacio" -ForegroundColor DarkGray
Write-Host "                     Silencis/Cancel.la now use Unicode escapes" -ForegroundColor DarkGray
Write-Host "  app.tsx            ModuleTabs import/usage removed (was null)" -ForegroundColor DarkGray
Write-Host ""
