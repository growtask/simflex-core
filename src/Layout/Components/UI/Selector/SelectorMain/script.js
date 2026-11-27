/* Селектор: выбор одного сегмента, aria-pressed, скрытое поле формы и событие sf-selector-change; подложка выбранного
   переезжает к новому сегменту (SfUi.glide, assetsGlobal/script.js) */
(() => {
    const ACTIVE = 'selector-item_active';
    const glide = (button, animate) => window.SfUi?.glide?.(button, 'selector-item__glide',
        () => button.classList.contains(ACTIVE), animate);
    const select = (selector, button) => {
        selector.querySelectorAll('.selector-item').forEach(item => {
            const active = item === button;
            item.classList.toggle(ACTIVE, active);
            item.setAttribute('aria-pressed', active ? 'true' : 'false');
        });
        const input = selector.querySelector('.selector__input');
        if (input) {
            input.value = button.dataset.value ?? '';
            input.dispatchEvent(new Event('change', {bubbles: true}));
        }
        selector.dispatchEvent(new CustomEvent('sf-selector-change', {
            bubbles: true,
            detail: {value: button.dataset.value ?? ''},
        }));
    };

    document.addEventListener('click', event => {
        const button = event.target.closest?.('.selector-item');
        const selector = button?.closest('.selector');
        if (!selector || button.disabled || button.classList.contains(ACTIVE)) {
            return;
        }
        // прежний выбранный - точка отсчёта переезда
        const current = selector.querySelector(`.${ACTIVE}`);
        if (current && !selector.dataset.sfGlideReady) {
            selector.dataset.sfGlideReady = '1';
            glide(current, false);
        }
        select(selector, button);
        glide(button, true);
    });
})();
