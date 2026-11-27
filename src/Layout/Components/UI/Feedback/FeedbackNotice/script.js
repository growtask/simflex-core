/* Уведомление (Notice): крестик «Закрыть» убирает уведомление со страницы; фокус с крестика переходит на следующий
 * фокусируемый элемент страницы (или предыдущий), а не теряется в body */
(() => {
    // фокус после удаления узла: ближайший фокусируемый элемент после него в документе, иначе перед ним
    const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]):not([type="hidden"]), select:not([disabled]), '
        + 'textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';
    const nextFocus = (node) => {
        const all = [...document.querySelectorAll(FOCUSABLE)]
            .filter((el) => !node.contains(el) && el.getClientRects().length > 0);
        return all.find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING)
            ?? all.reverse().find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_PRECEDING) ?? null;
    };
    // удалить узел; если фокус был внутри — перенести его, а не потерять в body
    const removeKeepingFocus = (node) => {
        const target = node.contains(document.activeElement) ? nextFocus(node) : null;
        node.remove();
        target?.focus();
    };

    document.addEventListener('click', (event) => {
        const close = event.target.closest?.('[data-sf-notice-close]');
        const notice = close?.closest('[data-sf-notice]');
        if (notice) {
            removeKeepingFocus(notice);
        }
    });
})();
