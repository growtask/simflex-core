/* Селектор: выбор одного сегмента, aria-pressed, скрытое поле формы и событие sf-selector-change */
(() => {
    const select = (selector, button) => {
        selector.querySelectorAll('.selector-item').forEach(item => {
            const active = item === button;
            item.classList.toggle('selector-item_active', active);
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
        if (!selector || button.disabled || button.classList.contains('selector-item_active')) {
            return;
        }
        select(selector, button);
    });
})();
