/*
 * Загрузка одного файла (Uploader): «Выбрать файл» и «Заменить» открывают выбор, файл можно перетащить в зону,
 * «Из библиотеки» берёт файл из файлового менеджера (window.fileManager) — сервер копирует его (поле source).
 * Загрузка — XHR с прогрессом на data-upload-url (поле data-upload-field и поля data-upload-data), ответ — имя
 * файла, пустой — не принят. Значение — data-value-prefix + имя в скрытом поле (событие change), «Удалить» его
 * очищает, у сохранённого файла — ещё и запрос data-delete-url.
 */
(() => {
    const ROOT = '[data-sf-uploader]';

    const parts = (root) => ({
        value: root.querySelector('[data-sf-uploader-value]'),
        input: root.querySelector('.uploader__input'),
        error: root.querySelector('.uploader__error'),
        name: root.querySelector('.uploader__name'),
        meta: root.querySelector('[data-sf-uploader-meta]'),
        progress: root.querySelector('.uploader__progress'),
        bar: root.querySelector('.uploader__progress-bar'),
        image: root.querySelector('.uploader__image'),
        links: root.querySelectorAll('.uploader__preview, .uploader__name'),
    });

    const sizeText = (bytes) => {
        if (bytes < 1024) {
            return `${bytes} Б`;
        }
        return bytes < 1024 * 1024 ? `${Math.round(bytes / 1024)} КБ` : `${(bytes / 1024 / 1024).toFixed(1)} МБ`;
    };

    const setError = (root, message) => {
        const {error} = parts(root);
        error.textContent = message;
        error.hidden = message === '';
        root.classList.toggle('uploader_error', message !== '');
    };

    const setValue = (root, value, label = '') => {
        const {value: hidden, name, image, links} = parts(root);
        hidden.value = value;
        hidden.dispatchEvent(new Event('change', {bubbles: true}));
        root.classList.toggle('uploader_filled', value !== '');
        name.textContent = label || value.split('/').pop();
        links.forEach((link) => link.setAttribute('href', value));
        if (image) {
            image.src = value;
        }
    };

    const setLoading = (root, isLoading, text = '') => {
        const {progress, bar, meta} = parts(root);
        root.classList.toggle('uploader_loading', isLoading);
        root.setAttribute('aria-busy', String(isLoading));
        progress.hidden = !isLoading;
        bar.style.width = '0%';
        meta.textContent = text;
    };

    /** Запрос загрузки: файл или source (файл библиотеки) */
    const send = (root, body, label) => {
        const {bar, meta, name} = parts(root);
        Object.entries(JSON.parse(root.dataset.uploadData || '{}')).forEach(([key, value]) => body.append(key, value));
        root.classList.add('uploader_filled');
        name.textContent = label;
        setError(root, '');
        setLoading(root, true, 'Загрузка…');
        const request = new XMLHttpRequest();
        request.upload.addEventListener('progress', (event) => {
            if (event.lengthComputable) {
                const percent = Math.round(event.loaded / event.total * 100);
                bar.style.width = `${percent}%`;
                meta.textContent = `Загрузка… ${percent}%`;
            }
        });
        request.addEventListener('loadend', () => {
            setLoading(root, false);
            const fileName = request.status === 200 ? request.responseText.trim() : '';
            const previous = parts(root).value.value;
            if (fileName === '') {
                setError(root, 'Файл не принят: тип или размер не подходит');
                setValue(root, previous);
                return;
            }
            setValue(root, (root.dataset.valuePrefix || '') + fileName, fileName);
        });
        request.open('POST', root.dataset.uploadUrl);
        request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        const token = document.querySelector('meta[name="csrf-token"]')?.content;
        if (token) {
            request.setRequestHeader('X-CSRF-Token', token);
        }
        request.send(body);
    };

    const upload = (root, file) => {
        const body = new FormData();
        body.append(root.dataset.uploadField || 'file', file);
        send(root, body, file.name);
        parts(root).meta.textContent = sizeText(file.size);
    };

    document.addEventListener('click', (event) => {
        const root = event.target.closest(ROOT);
        if (!root || root.classList.contains('uploader_disabled')) {
            return;
        }
        if (event.target.closest('[data-sf-uploader-pick]')) {
            parts(root).input.click();
        } else if (event.target.closest('[data-sf-uploader-remove]')) {
            setError(root, '');
            setValue(root, '');
            // сохранённый файл удаляется сразу (файл и значение в записи), только что загруженный — только из поля
            if (root.dataset.deleteUrl) {
                fetch(root.dataset.deleteUrl, {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content ?? '',
                    },
                });
                delete root.dataset.deleteUrl;
            }
        } else if (event.target.closest('[data-sf-uploader-library]')) {
            window.fileManager?.open({
                onSelect: ([file]) => {
                    const body = new FormData();
                    body.append('source', file.url);
                    send(root, body, file.name);
                },
            });
        }
    });

    document.addEventListener('change', (event) => {
        const root = event.target.matches?.('.uploader__input') && event.target.closest(ROOT);
        if (root && event.target.files[0]) {
            upload(root, event.target.files[0]);
            event.target.value = '';
        }
    });

    // перетаскивание в зону
    const dropRoot = (event) => event.target.closest?.(`${ROOT}:not(.uploader_disabled)`);
    ['dragenter', 'dragover'].forEach((type) => document.addEventListener(type, (event) => {
        const root = dropRoot(event);
        if (root && [...(event.dataTransfer?.types ?? [])].includes('Files')) {
            event.preventDefault();
            root.classList.add('uploader_drag');
        }
    }));
    document.addEventListener('dragleave', (event) => {
        const root = dropRoot(event);
        if (root && !root.contains(event.relatedTarget)) {
            root.classList.remove('uploader_drag');
        }
    });
    document.addEventListener('drop', (event) => {
        const root = dropRoot(event);
        if (!root || !event.dataTransfer?.files.length) {
            return;
        }
        event.preventDefault();
        root.classList.remove('uploader_drag');
        upload(root, event.dataTransfer.files[0]);
    });
})();
