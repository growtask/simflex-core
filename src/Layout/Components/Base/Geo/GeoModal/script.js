/* Выбор города (GeoModal): на desktop — окно под кнопкой (содержимое .geo-main переносится в .geo__panel), на телефоне —
 * окно ModalMain (window.SimflexModal: экран целиком, ловушка и возврат фокуса, Esc, блокировка прокрутки и фона;
 * без Modal на странице — тоже окно под кнопкой). «Да»/«Принять» подтверждают город, «Нет»/«Изменить» открывают
 * поиск, список фильтруется на клиенте (Esc закрывает список до ввода или ↓), «Сохранить» подтверждает выбранный.
 * Выбор — в localStorage (data-storage-key) и событие sf-geo-change ({ detail: { city } }) на корне.
 * Автопоказ вопроса при загрузке (data-ask) на desktop не переносит фокус — окно под кнопкой следует за
 * ней в порядке Tab, фокус остаётся там, где был; на телефоне это модальное окно Modal (фокус в нём). Esc (на документе,
 * если его ещё не обработал другой компонент — defaultPrevented) закрывает окно под кнопкой и без фокуса в нём; фокус
 * возвращается на кнопку, только если он был в окне (или нигде). */
(() => {
    const norm = (s) => String(s ?? '').toLowerCase().replace(/ё/g, 'е').trim();
    const mobile = () => matchMedia('(width <= 481px)').matches;

    const init = (geo) => {
        if (geo.dataset.sfGeoReady || geo.hasAttribute('data-sf-geo-specimen')) return;
        geo.dataset.sfGeoReady = '1';
        // окно Modal при открытии уходит в body — ссылки на части берём заранее
        const $ = (s) => geo.querySelector(s);
        const trigger = $('[data-sf-geo-trigger]'), panel = $('[data-sf-geo-panel]'), panelBody = $('[data-sf-geo-body]');
        const modal = $('[data-sf-geo-modal]'), main = $('[data-sf-geo-main]');
        const modalBody = modal?.querySelector('.modal__body');
        const m$ = (s) => main.querySelector(s);
        const m$$ = (s) => [...main.querySelectorAll(s)];
        const search = m$('[data-sf-geo-search]'), input = m$('[data-sf-geo-input]'), list = m$('[data-sf-geo-list]');
        const label = $('[data-sf-geo-label]'), cityEl = m$('[data-sf-geo-city]'), save = m$('[data-sf-geo-save]');
        const key = geo.dataset.storageKey;
        let city = '', picked = '', listClosed = false;
        let mode = ''; // '' — закрыто, 'panel' — под кнопкой, 'modal' — окно Modal

        const setState = (state) => {
            main.dataset.state = state;
            // dropdown, selected, empty — тоже поиск (вид в витрине); скрипт дальше ведёт их как choice
            const choice = ['choice', 'dropdown', 'selected', 'empty'].includes(state);
            search.hidden = !choice;
            cityEl.hidden = choice;
            const [yes, accept] = m$$('[data-sf-geo-yes]');
            const [no, change] = m$$('[data-sf-geo-no]');
            yes.hidden = no.hidden = state !== 'static';
            accept.hidden = change.hidden = state !== 'active';
            save.hidden = !choice;
        };
        const setExpanded = (open) => trigger.setAttribute('aria-expanded', open ? 'true' : 'false');
        // вид содержимого (GEO/main, GEO/list style=mobile — кнопки внизу столбиком, список в потоке)
        const setScreen = (isMobile) => {
            main.classList.toggle('geo-main-screen_mobile', isMobile);
            list.classList.toggle('geo-list-screen_mobile', isMobile);
        };
        // auto — автопоказ при загрузке: на desktop без переноса фокуса в окно
        const setOpen = (open, restore = true, auto = false) => {
            if (open === !!mode) return;
            if (open) {
                if (mobile() && modal && modalBody && window.SimflexModal) {
                    mode = 'modal';
                    setScreen(true);
                    modalBody.appendChild(main);
                    trigger.setAttribute('aria-controls', modal.id);
                    window.SimflexModal.open(modal.id, trigger);
                } else {
                    mode = 'panel';
                    setScreen(false);
                    panelBody.appendChild(main);
                    trigger.setAttribute('aria-controls', panel.id);
                    if (window.SfUi?.transition) {
                        window.SfUi.transition(panel, 'geo-panel', true);
                    } else {
                        panel.hidden = false;
                    }
                    // первый видимый элемент (поле поиска в состоянии вопроса скрыто); при автопоказе фокус не трогаем
                    if (!auto) {
                        [...main.querySelectorAll('button:not([disabled]), input')].find((el) => el.getClientRects().length)?.focus();
                    }
                }
                setExpanded(true);
                return;
            }
            const was = mode;
            // фокус возвращаем, только если он был в окне (окно, показанное само, фокус не брало) или нигде
            const active = document.activeElement;
            const inside = panel.contains(active) || !active || active === document.body;
            mode = '';
            setExpanded(false);
            if (was === 'modal') {
                // фокус на кнопку вернёт Modal
                if (window.SimflexModal.isOpen(modal.id)) window.SimflexModal.close(modal.id);
            } else {
                if (window.SfUi?.transition) {
                    window.SfUi.transition(panel, 'geo-panel', false);
                } else {
                    panel.hidden = true;
                }
                if (restore && inside) trigger.focus();
            }
        };
        const confirm = (value) => {
            if (!value) return;
            city = value;
            label.textContent = value;
            cityEl.textContent = value;
            try { if (key) localStorage.setItem(key, value); } catch (e) { /* хранилище недоступно */ }
            geo.dispatchEvent(new CustomEvent('sf-geo-change', { bubbles: true, detail: { city: value } }));
            setState('active');
            setOpen(false);
        };
        const filter = () => {
            const q = norm(input.value);
            let any = false;
            m$$('[data-city]').forEach((li) => {
                const hit = q !== '' && norm(li.dataset.city).includes(q);
                li.hidden = !hit;
                any ||= hit;
            });
            m$('[data-sf-geo-empty]').hidden = any;
            list.hidden = q === '' || !!picked || listClosed;
            input.setAttribute('aria-expanded', list.hidden ? 'false' : 'true');
            save.disabled = !picked;
        };
        const firstItem = () => list.querySelector('li:not([hidden]) button');
        // Esc в поле или списке закрывает только список (окно остаётся открытым)
        const closeList = (e) => {
            if (e.key !== 'Escape' || list.hidden) return false;
            e.preventDefault();
            e.stopPropagation();
            listClosed = true;
            filter();
            input.focus();
            return true;
        };

        trigger.addEventListener('click', () => setOpen(!mode));
        // окно Modal закрыто крестиком, Esc или подложкой
        modal?.addEventListener('modal:close', () => { if (mode === 'modal') setOpen(false); });
        m$$('[data-sf-geo-yes]').forEach((b) => b.addEventListener('click', () => confirm(city || geo.dataset.guess)));
        m$$('[data-sf-geo-no]').forEach((b) => b.addEventListener('click', () => {
            setState('choice');
            input.value = '';
            picked = '';
            listClosed = false;
            filter();
            input.focus();
        }));
        save.addEventListener('click', () => confirm(picked));
        input.addEventListener('input', () => { picked = ''; listClosed = false; filter(); });
        input.addEventListener('keydown', (e) => {
            if (closeList(e)) return;
            if (e.key === 'ArrowDown') {
                if (list.hidden && listClosed && input.value.trim() !== '' && !picked) {
                    listClosed = false;
                    filter();
                }
                if (!list.hidden) {
                    e.preventDefault();
                    firstItem()?.focus();
                }
            } else if (e.key === 'Enter' && picked) {
                // без preventDefault этот Enter после закрытия окна нажал бы кнопку города (на ней уже фокус)
                e.preventDefault();
                confirm(picked);
            }
        });
        list.addEventListener('click', (e) => {
            const li = e.target.closest('[data-city]');
            if (!li) return;
            picked = li.dataset.city;
            input.value = picked;
            filter();
            input.focus();
        });
        list.addEventListener('keydown', (e) => {
            if (closeList(e)) return;
            if (e.key !== 'ArrowDown' && e.key !== 'ArrowUp') return;
            e.preventDefault();
            const items = [...list.querySelectorAll('li:not([hidden]) button')];
            const i = items.indexOf(document.activeElement) + (e.key === 'ArrowDown' ? 1 : -1);
            (i < 0 ? input : items[i % items.length]).focus();
        });
        // desktop: Esc закрывает окно под кнопкой (окно Modal закрывает Esc само); слушатель на документе — окно,
        // показанное само, закрывается и без фокуса в нём; Esc, уже обработанный другим компонентом, не трогаем
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && mode === 'panel' && !e.defaultPrevented) {
                e.preventDefault();
                setOpen(false);
            }
        });
        document.addEventListener('pointerdown', (e) => {
            if (mode === 'panel' && !geo.contains(e.target)) setOpen(false, false);
        }, true);

        let saved = '';
        try { saved = key ? localStorage.getItem(key) || '' : ''; } catch (e) { /* хранилище недоступно */ }
        if (saved) {
            city = saved;
            label.textContent = saved;
            cityEl.textContent = saved;
            setState('active');
        } else {
            setState(main.dataset.state);
            if (geo.dataset.ask) setOpen(true, false, true);
        }
    };

    const run = () => document.querySelectorAll('[data-sf-geo]').forEach(init);
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', run);
    } else {
        run();
    }
})();
