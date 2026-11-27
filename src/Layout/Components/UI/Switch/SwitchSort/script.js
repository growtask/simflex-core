/*
 * Сортировка (SwitchSort): кнопки без ссылки (сортировка на месте) переключают направление - индикатор переезжает к
 * выбранной стрелке пружиной (style.scss), повторное нажатие снимает сортировку. Событие sort:change
 * ({detail: {direction: 'ascending' | 'descending' | 'none'}}) на .sort. Кнопки-ссылки переходят по адресу сами.
 */
(() => {
    if (window.SimflexSortReady) {
        return;
    }
    window.SimflexSortReady = true;

    document.addEventListener('click', (event) => {
        const button = event.target.closest?.('[data-sf-sort] > button.sort-button');
        if (!button) {
            return;
        }
        const box = button.parentElement;
        const glide = box.querySelector(':scope > .sort__glide');
        const buttons = [...box.querySelectorAll(':scope > .sort-button')];
        const picked = buttons.indexOf(button) === 0 ? 'ascending' : 'descending';
        const direction = glide?.dataset.direction === picked ? 'none' : picked;
        if (glide) {
            glide.dataset.direction = direction;
        }
        buttons.forEach((item, index) => {
            const on = (index === 0 ? 'ascending' : 'descending') === direction;
            item.classList.toggle('active', on);
            on ? item.setAttribute('aria-pressed', 'true') : item.removeAttribute('aria-pressed');
        });
        box.closest('.sort')?.dispatchEvent(new CustomEvent('sort:change', {bubbles: true, detail: {direction}}));
    });
})();
