/**
 * Переключатель темы админки (кнопка с data-sf-theme-toggle="light|dark" в меню): пишет cookie темы и перезагружает
 * страницу — тему читает сервер (Admin\Page::getTheme()) и передаёт её компонентам Layout
 */
const THEME_COOKIE = 'sf_admin_theme';
const YEAR = 60 * 60 * 24 * 365;

document.addEventListener('click', (event) => {
    const toggle = event.target.closest?.('[data-sf-theme-toggle]');
    if (!toggle) {
        return;
    }
    document.cookie = `${THEME_COOKIE}=${encodeURIComponent(toggle.dataset.sfThemeToggle)}; path=/; max-age=${YEAR}; samesite=lax`;
    window.location.reload();
});
