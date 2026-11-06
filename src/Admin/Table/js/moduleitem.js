/**
 * Модули сайта (Handlers\ModuleItem): при выборе модуля в форме его параметры загружаются с сервера
 * (?action=module_param) — группы left в основную колонку, right в правую панель (без панели — в основную).
 * Скрипты в ответе (инициализация редактора) выполняются, компоненты data-sf инициализирует admin.js
 */
const FORM = '.edit-form';
const SELECT = 'input[name="module"]';

/** Вставляет HTML и выполняет его скрипты (innerHTML их не запускает) */
const setHtml = (container, html) => {
    // редакторы прежнего модуля
    container.querySelectorAll('textarea[id]').forEach((textarea) => window.tinymce?.get(textarea.id)?.remove());
    container.innerHTML = html;
    container.querySelectorAll('script').forEach((old) => {
        const script = document.createElement('script');
        [...old.attributes].forEach((attribute) => script.setAttribute(attribute.name, attribute.value));
        script.textContent = old.textContent;
        old.replaceWith(script);
    });
};

const loadParams = async (form, module) => {
    const itemId = form.querySelector('#info-key-value')?.value ?? '0';
    const query = new URLSearchParams({action: 'module_param', module, item_id: itemId});
    const response = await window.sfAdmin.request(`${location.pathname}?${query}`);
    const positions = response;
    const left = form.querySelector('.ajax-params-left');
    const right = form.querySelector('.ajax-params');
    if (right) {
        setHtml(left, positions.left ?? '');
        setHtml(right, positions.right ?? '');
    } else {
        setHtml(left, (positions.left ?? '') + (positions.right ?? ''));
    }
};

document.addEventListener('change', (event) => {
    const form = event.target.matches?.(SELECT) && event.target.closest(FORM);
    if (form) {
        loadParams(form, event.target.value);
    }
});

// форма существующей записи: параметры выбранного модуля сразу
const form = document.querySelector(FORM);
const select = form?.querySelector(SELECT);
if (select?.value) {
    loadParams(form, select.value);
}
