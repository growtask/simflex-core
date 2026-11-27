/*
 * Кнопка меню (ButtonMenu): SfUi.menuBadge(button, text) ставит, меняет или (пустой текст) убирает бейдж-счётчик;
 * бейдж появляется прозрачностью и масштабом от угла с лёгкой пружиной, уходит быстрее (классы btn-menu-badge-*
 * в style.scss, SfUi.transition в assetsGlobal/script.js).
 */
(() => {
    const SfUi = window.SfUi = window.SfUi || {};
    if (SfUi.menuBadge) {
        return;
    }
    SfUi.menuBadge = (button, text = '') => {
        const root = button?.closest?.('.btn-menu');
        if (!root) {
            return;
        }
        const value = String(text ?? '');
        let badge = root.querySelector(':scope > .btn-menu__badge:not([data-sf-leaving])');
        if (value === '') {
            if (badge) {
                badge.setAttribute('data-sf-leaving', '');
                const remove = () => badge.remove();
                SfUi.transition ? SfUi.transition(badge, 'btn-menu-badge', false).then(remove) : remove();
            }
            return;
        }
        if (badge) {
            badge.textContent = value;
            return;
        }
        badge = document.createElement('span');
        badge.className = 'btn-menu__badge';
        badge.textContent = value;
        badge.hidden = true;
        root.prepend(badge);
        SfUi.transition ? SfUi.transition(badge, 'btn-menu-badge', true) : (badge.hidden = false);
    };
})();
