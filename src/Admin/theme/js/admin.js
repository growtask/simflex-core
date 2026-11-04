/**
 * Общий модуль админки (без jQuery, без сборки).
 *
 * - request() — запрос к серверу: fetch с CSRF-токеном (заголовок X-CSRF-Token из <meta name="csrf-token">),
 *   заголовком X-Requested-With (ajax-запрос админки) и разбором JSON-ответа;
 * - register(name, init) — модуль компонента объявляет инициализацию элементов с data-sf="<name>": init(element)
 *   вызывается один раз для каждого элемента, в том числе добавленного на страницу позже (ajax, окна);
 * - window.sfAdmin — то же для обычных скриптов: request, register, init, toast(), confirm().
 *   toast() показывает тост компонента Toast (window.sfToast), confirm() — окно подтверждения (theme/js/modals.js,
 *   setConfirm); без них — запасной вариант браузера.
 */

const READY_ATTRIBUTE = 'data-sf-ready';

/** @type {Map<string, function(HTMLElement): void>} */
const initializers = new Map();

let toastHandler = null;
let confirmHandler = null;

/**
 * @returns {string} CSRF-токен страницы
 */
export function getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ?? '';
}

/**
 * Запрос к серверу админки
 * @param {string} url
 * @param {{method?: string, data?: FormData|Object|null, headers?: Object}} options data — тело POST: FormData или
 *        объект (отправляется как форма)
 * @returns {Promise<any>} JSON, если сервер ответил JSON, иначе текст
 */
export async function request(url, {method = 'GET', data = null, headers = {}} = {}) {
    let body = null;
    if (data instanceof FormData) {
        body = data;
    } else if (data) {
        body = new URLSearchParams(data);
    }

    const response = await fetch(url, {
        method: body && method === 'GET' ? 'POST' : method,
        body,
        credentials: 'same-origin',
        headers: {'X-Requested-With': 'XMLHttpRequest', 'X-CSRF-Token': getCsrfToken(), ...headers},
    });
    if (!response.ok) {
        throw new Error(`${response.status} ${response.statusText}`);
    }

    const type = response.headers.get('Content-Type') ?? '';
    return type.includes('application/json') ? response.json() : response.text();
}

/**
 * Инициализирует ещё не инициализированные элементы компонентов внутри root
 * @param {ParentNode} root
 */
export function init(root = document) {
    initializers.forEach((initElement, name) => {
        const selector = `[data-sf~="${name}"]`;
        const elements = [...root.querySelectorAll(selector)];
        if (root instanceof HTMLElement && root.matches(selector)) {
            elements.unshift(root);
        }
        elements.forEach((element) => {
            const ready = (element.getAttribute(READY_ATTRIBUTE) ?? '').split(' ');
            if (ready.includes(name)) {
                return;
            }
            element.setAttribute(READY_ATTRIBUTE, [...ready, name].join(' ').trim());
            initElement(element);
        });
    });
}

/**
 * Объявляет компонент: init(element) для каждого элемента с data-sf="<name>" (в data-sf можно перечислить
 * несколько компонентов через пробел)
 * @param {string} name
 * @param {function(HTMLElement): void} initElement
 */
export function register(name, initElement) {
    initializers.set(name, initElement);
    if (document.readyState !== 'loading') {
        init(document);
    }
}

/**
 * Показывает уведомление
 * @param {string} message
 * @param {{type?: 'success'|'error'|'alert'|'info'}} options
 */
export function toast(message, options = {}) {
    if (toastHandler) {
        toastHandler(message, options);
        return;
    }
    // тост компонента Toast (стопка тостов в макете)
    if (window.sfToast?.(message, {type: options.type === 'error' ? 'error' : (options.type === 'success' ? 'success' : 'default')})) {
        return;
    }
    window.alert(message);
}

/**
 * Спрашивает подтверждение действия
 * @param {string} message
 * @param {{title?: string, confirmText?: string, danger?: boolean}} options
 * @returns {Promise<boolean>}
 */
export function confirm(message, options = {}) {
    return confirmHandler ? confirmHandler(message, options) : Promise.resolve(window.confirm(message));
}

/** Слой тостов подключает свой показ уведомлений */
export function setToast(handler) {
    toastHandler = handler;
}

/** Окно подтверждения подключает свой показ */
export function setConfirm(handler) {
    confirmHandler = handler;
}

document.addEventListener('DOMContentLoaded', () => {
    init(document);
    // элементы, добавленные позже (ajax, окна), инициализируются сами
    new MutationObserver((mutations) => {
        mutations.forEach((mutation) => mutation.addedNodes.forEach((node) => {
            if (node instanceof HTMLElement) {
                init(node);
            }
        }));
    }).observe(document.body, {childList: true, subtree: true});
});

window.sfAdmin = {request, register, init, toast, confirm, getCsrfToken};
