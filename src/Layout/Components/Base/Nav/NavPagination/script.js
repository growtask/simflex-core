/* Пагинация: переход на страницу по номеру (Enter или «Перейти»), номер вне диапазона приводится к границе */
document.addEventListener('submit', (event) => {
    const form = event.target.closest?.('[data-sf-pagination-search]');
    if (!form) {
        return;
    }
    event.preventDefault();
    const input = form.querySelector('input');
    const pageCount = Number(form.dataset.pageCount);
    const page = Math.min(Math.max(1, parseInt(input.value, 10) || 1), pageCount);
    input.value = String(page);
    window.location.href = form.dataset.urlPattern.replace('{page}', String(page + Number(form.dataset.pageOffset || 0)));
});
