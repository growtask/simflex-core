/* Плашка cookie: «Настройки» переключает вид, «Принять все», «Отклонить», «Сохранить выбор» закрывают плашку
 * и шлют на document событие sf:cookie-choose с detail { action, choice }.
 * Cookie скрипт не пишет - выбор запоминает сайт, например:
 *   document.addEventListener('sf:cookie-choose', (e) => { document.cookie = 'cookie_consent='
 *     + encodeURIComponent(JSON.stringify(e.detail.choice)) + '; path=/; max-age=31536000; samesite=lax'; });
 * Фокус с кнопки закрытой плашки переходит на следующий фокусируемый элемент страницы (или предыдущий).
 */
(() => {
    const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]):not([type="hidden"]), select:not([disabled]), '
        + 'textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';
    const nextFocus = (node) => {
        const all = [...document.querySelectorAll(FOCUSABLE)]
            .filter((el) => !node.contains(el) && el.getClientRects().length > 0);
        return all.find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING)
            ?? all.reverse().find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_PRECEDING) ?? null;
    };
    const removeKeepingFocus = (node) => {
        const target = node.contains(document.activeElement) ? nextFocus(node) : null;
        node.remove();
        target?.focus();
    };

    document.addEventListener('click', (event) => {
        // обязательные категории (aria-disabled) всегда включены
        if (event.target.matches?.('[data-sf-cookie] .cookie__list input[aria-disabled="true"]')) {
            event.preventDefault();
            return;
        }
        const button = event.target.closest?.('[data-sf-cookie-action]');
        const cookie = button?.closest('[data-sf-cookie]');
        if (!cookie) {
            return;
        }
        const action = button.getAttribute('data-sf-cookie-action');
        if (action === 'settings') {
            cookie.classList.replace('cookie-state_default', 'cookie-state_settings');
            cookie.querySelector('.cookie__list input:not([aria-disabled])')?.focus();
            return;
        }
        const choice = {};
        cookie.querySelectorAll('.cookie__list input[name^="cookie-"]').forEach((input) => {
            const key = input.name.slice(7);
            choice[key] = input.hasAttribute('aria-disabled') ? true : (action === 'save' ? input.checked : action === 'accept');
        });
        document.dispatchEvent(new CustomEvent('sf:cookie-choose', { detail: { action, choice } }));
        // в витрине (inline) плашка остаётся, чтобы её можно было пересмотреть
        if (!cookie.classList.contains('cookie_inline')) {
            removeKeepingFocus(cookie);
        }
    });
})();
