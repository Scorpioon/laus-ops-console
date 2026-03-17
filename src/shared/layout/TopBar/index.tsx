// src/shared/layout/TopBar/index.tsx
import { useUIStore } from '../../../core/store/uiStore';
import { useWorkspaceStore } from '../../../core/store/workspaceStore';
import { t } from '../../../core/utils/i18n';
import styles from './styles.module.css';

export function TopBar() {
  const { language, setLanguage, theme, toggleTheme } = useUIStore();
  const activeWorkspace = useWorkspaceStore((state) => state.activeWorkspace);
  const unsavedChanges = activeWorkspace?.unsavedChanges;

  return (
    <header className={styles.topbar}>
      <div className={styles.left}>
        <div className={styles.logo}>
          <span className={styles.logoPrimary}>LAUS OPS</span>
          <span className={styles.logoSecondary}>console</span>
        </div>
        <div className={styles.workspaceInfo}>
          {activeWorkspace ? (
            <>
              <span className={styles.workspaceName}>{activeWorkspace.name}</span>
              {unsavedChanges && <span className={styles.unsavedBadge}>*</span>}
            </>
          ) : (
            <span className={styles.noWorkspace}>{t('topbar.noWorkspace')}</span>
          )}
        </div>
      </div>

      <div className={styles.right}>
        <div className={styles.langSwitcher}>
          <button
            className={`${styles.langBtn} ${language === 'ca' ? styles.active : ''}`}
            onClick={() => setLanguage('ca')}
          >
            CA
          </button>
          <button
            className={`${styles.langBtn} ${language === 'es' ? styles.active : ''}`}
            onClick={() => setLanguage('es')}
          >
            ES
          </button>
        </div>
        <button className={styles.themeBtn} onClick={toggleTheme} aria-label={t('topbar.toggleTheme')}>
          {theme === 'light' ? <i className="bi bi-sun"></i> : <i className="bi bi-moon-stars"></i>}
        </button>
      </div>
    </header>
  );
}