/*
 * Календарь (Calendar): виды days (сетка дней, неделя с понедельника, дни других месяцев приглушены), months,
 * years (по 20 лет), time (часы и минуты с шагом data-step). Заголовок переключает виды, стрелки листают месяц,
 * год, страницу лет. Клавиатура в днях: стрелки — день и неделя, PageUp/PageDown — месяц (с Shift — год),
 * Home/End — начало и конец недели, Enter/Space — выбор. Даты вне data-min/data-max недоступны.
 * Выбор — событие calendar:select ({detail: {value}}): дата 'Y-m-d', дата и время 'Y-m-d H:i', время 'H:i';
 * в режиме datetime день открывает вид time. Метод: element.sfCalendar.setValue(value).
 *
 * Поле даты (TextInput с data-sf-date): маска ДД.ММ.ГГГГ [ЧЧ:ММ] или ЧЧ:ММ, кнопка календаря раскрывает его под
 * полем, выбор записывает значение (события input и change) и закрывает календарь; Esc и клик снаружи закрывают,
 * фокус возвращается на кнопку.
 */
(() => {
    if (window.SimflexCalendar) {
        return;
    }

    const MONTHS = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь',
        'Ноябрь', 'Декабрь'];
    const MONTHS_GENITIVE = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября',
        'октября', 'ноября', 'декабря'];
    const MONTHS_SHORT = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    const WEEKDAYS = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const YEARS_PAGE = 20;

    const pad = (number) => String(number).padStart(2, '0');
    const isoDate = (date) => `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
    const sameDay = (a, b) => a && b && isoDate(a) === isoDate(b);
    const parseIso = (value) => {
        const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value ?? '');
        return match ? new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3])) : null;
    };
    const parseTime = (value) => {
        const match = /(\d{1,2}):(\d{2})/.exec(value ?? '');
        return match ? {hours: Math.min(23, Number(match[1])), minutes: Math.min(59, Number(match[2]))} : null;
    };
    const element = (tag, className, text = '') => {
        const node = document.createElement(tag);
        node.className = className;
        if (text !== '') {
            node.textContent = text;
        }
        return node;
    };

    const create = (root) => {
        const mode = root.dataset.sfCalendar || 'date';
        const body = root.querySelector('[data-sf-calendar-body]');
        const min = parseIso(root.dataset.min);
        const max = parseIso(root.dataset.max);
        const step = Math.max(1, Number(root.dataset.step) || 5);
        const today = new Date();

        const state = {
            view: mode === 'time' ? 'time' : 'days',
            selected: null,
            time: null,
            cursor: new Date(today.getFullYear(), today.getMonth(), today.getDate()),
        };

        const isDisabled = (date) => (min && date < min) || (max && date > max);

        const setValue = (value) => {
            state.selected = mode === 'time' ? null : parseIso(value);
            state.time = parseTime(mode === 'date' ? '' : value);
            state.cursor = state.selected ? new Date(state.selected) : new Date(today.getFullYear(), today.getMonth(), today.getDate());
            state.view = mode === 'time' ? 'time' : 'days';
            render();
        };

        const getValue = () => {
            const time = state.time ?? {hours: 0, minutes: 0};
            const timeText = `${pad(time.hours)}:${pad(time.minutes)}`;
            if (mode === 'time') {
                return timeText;
            }
            const date = state.selected ? isoDate(state.selected) : '';
            return mode === 'datetime' && date ? `${date} ${timeText}` : date;
        };

        const emit = () => root.dispatchEvent(new CustomEvent('calendar:select', {bubbles: true, detail: {value: getValue()}}));

        const renderHead = () => {
            const month = root.querySelector('.calendar__month');
            const year = root.querySelector('.calendar__year');
            const timeButton = root.querySelector('.calendar__time');
            const line = root.querySelector('.calendar__line');
            const isTime = state.view === 'time';
            month.hidden = state.view === 'years' || (isTime && mode === 'time');
            year.hidden = isTime;
            month.textContent = isTime && state.selected
                ? `${state.selected.getDate()} ${MONTHS_GENITIVE[state.selected.getMonth()]}`
                : MONTHS[state.cursor.getMonth()];
            month.dataset.sfCalendarView = isTime ? 'days' : 'months';
            month.setAttribute('aria-label', isTime ? 'К дням' : 'Выбрать месяц');
            const startYear = state.cursor.getFullYear() - (state.cursor.getFullYear() % YEARS_PAGE);
            year.textContent = state.view === 'years' ? `${startYear}–${startYear + YEARS_PAGE - 1}` : String(state.cursor.getFullYear());
            year.setAttribute('aria-label', 'Выбрать год');
            const hasTime = mode !== 'date' && state.time !== null;
            timeButton.hidden = !hasTime;
            line.hidden = !hasTime || (isTime && mode === 'time');
            if (hasTime) {
                timeButton.textContent = `${pad(state.time.hours)}:${pad(state.time.minutes)}`;
                timeButton.setAttribute('aria-label', 'Выбрать время');
            }
            // в виде time стрелок нет: часы и минуты прокручиваются
            root.querySelectorAll('[data-sf-calendar-step]').forEach((button) => {
                button.hidden = isTime;
            });
            const field = root.querySelector('.calendar__time-field');
            if (field) {
                field.textContent = hasTime ? `${pad(state.time.hours)}:${pad(state.time.minutes)}` : '—:—';
            }
        };

        const renderDays = () => {
            const grid = element('div', 'calendar__days');
            grid.setAttribute('role', 'grid');
            const head = element('div', 'calendar__row');
            head.setAttribute('role', 'row');
            WEEKDAYS.forEach((name) => {
                const cell = element('span', 'calendar__weekday', name);
                cell.setAttribute('role', 'columnheader');
                head.append(cell);
            });
            grid.append(head);
            const first = new Date(state.cursor.getFullYear(), state.cursor.getMonth(), 1);
            const offset = (first.getDay() + 6) % 7;
            const start = new Date(first);
            start.setDate(first.getDate() - offset);
            const weeks = Math.ceil((offset + new Date(first.getFullYear(), first.getMonth() + 1, 0).getDate()) / 7);
            for (let week = 0; week < weeks; week++) {
                const row = element('div', 'calendar__row');
                row.setAttribute('role', 'row');
                for (let day = 0; day < 7; day++) {
                    const date = new Date(start);
                    date.setDate(start.getDate() + week * 7 + day);
                    const cell = element('button', 'calendar__day', String(date.getDate()));
                    cell.type = 'button';
                    cell.setAttribute('role', 'gridcell');
                    cell.dataset.date = isoDate(date);
                    cell.classList.toggle('calendar__day_weekend', day >= 5);
                    cell.classList.toggle('calendar__day_muted', date.getMonth() !== state.cursor.getMonth());
                    const isSelected = sameDay(date, state.selected);
                    cell.setAttribute('aria-selected', String(isSelected));
                    if (sameDay(date, today)) {
                        cell.setAttribute('aria-current', 'date');
                    }
                    if (isDisabled(date)) {
                        cell.disabled = true;
                    }
                    cell.tabIndex = sameDay(date, state.cursor) ? 0 : -1;
                    cell.setAttribute('aria-label', `${date.getDate()} ${MONTHS_GENITIVE[date.getMonth()]} ${date.getFullYear()}`);
                    row.append(cell);
                }
                grid.append(row);
            }
            return grid;
        };

        const renderItems = (items) => {
            const grid = element('div', 'calendar__items');
            grid.setAttribute('role', 'listbox');
            items.forEach(({text, value, isSelected, isCurrent, label}) => {
                const item = element('button', 'calendar__item', text);
                item.type = 'button';
                item.setAttribute('role', 'option');
                item.dataset.value = String(value);
                item.setAttribute('aria-selected', String(isSelected));
                item.classList.toggle('calendar__item_current', isCurrent);
                if (label) {
                    item.setAttribute('aria-label', label);
                }
                item.tabIndex = isSelected || (!items.some((entry) => entry.isSelected) && isCurrent) ? 0 : -1;
                grid.append(item);
            });
            if (!grid.querySelector('[tabindex="0"]')) {
                grid.firstChild.tabIndex = 0;
            }
            return grid;
        };

        const renderTime = () => {
            const columns = element('div', 'calendar__columns');
            const time = state.time ?? {hours: today.getHours(), minutes: Math.floor(today.getMinutes() / step) * step};
            const column = (title, kind, values, current) => {
                const wrap = element('div', 'calendar__column');
                wrap.append(element('span', 'calendar__column-title', title));
                const list = element('div', 'calendar__column-list');
                list.setAttribute('role', 'listbox');
                list.setAttribute('aria-label', title);
                list.dataset.kind = kind;
                values.forEach((value) => {
                    const item = element('button', 'calendar__item', pad(value));
                    item.type = 'button';
                    item.setAttribute('role', 'option');
                    item.dataset.value = String(value);
                    const isSelected = state.time !== null && value === current;
                    item.setAttribute('aria-selected', String(isSelected));
                    item.tabIndex = value === current ? 0 : -1;
                    list.append(item);
                });
                wrap.append(list);
                return wrap;
            };
            const minutes = [];
            for (let minute = 0; minute < 60; minute += step) {
                minutes.push(minute);
            }
            const minute = minutes.reduce((best, value) => (Math.abs(value - time.minutes) < Math.abs(best - time.minutes) ? value : best), 0);
            columns.append(
                column('Часы', 'hours', [...Array(24).keys()], time.hours),
                column('Минуты', 'minutes', minutes, minute),
            );
            return columns;
        };

        const render = () => {
            root.dataset.view = state.view;
            renderHead();
            let content;
            if (state.view === 'months') {
                content = renderItems(MONTHS_SHORT.map((text, index) => ({
                    text,
                    value: index,
                    label: MONTHS[index],
                    isSelected: state.selected?.getMonth() === index && state.selected?.getFullYear() === state.cursor.getFullYear(),
                    isCurrent: today.getMonth() === index && today.getFullYear() === state.cursor.getFullYear(),
                })));
            } else if (state.view === 'years') {
                const startYear = state.cursor.getFullYear() - (state.cursor.getFullYear() % YEARS_PAGE);
                content = renderItems([...Array(YEARS_PAGE).keys()].map((index) => ({
                    text: String(startYear + index),
                    value: startYear + index,
                    isSelected: state.selected?.getFullYear() === startYear + index,
                    isCurrent: today.getFullYear() === startYear + index,
                })));
            } else if (state.view === 'time') {
                content = renderTime();
            } else {
                content = renderDays();
            }
            body.replaceChildren(content);
            // выбранное время — в видимой части колонок
            body.querySelectorAll('.calendar__column-list [tabindex="0"]').forEach((item) => item.scrollIntoView({block: 'center'}));
        };

        const focusCurrent = () => body.querySelector('[tabindex="0"]')?.focus();

        const moveCursor = (days, months = 0) => {
            const next = new Date(state.cursor);
            if (months) {
                next.setDate(1);
                next.setMonth(next.getMonth() + months);
                const last = new Date(next.getFullYear(), next.getMonth() + 1, 0).getDate();
                next.setDate(Math.min(state.cursor.getDate(), last));
            } else {
                next.setDate(next.getDate() + days);
            }
            state.cursor = next;
            render();
            focusCurrent();
        };

        const selectDay = (date) => {
            if (isDisabled(date)) {
                return;
            }
            state.selected = date;
            state.cursor = new Date(date);
            if (mode === 'datetime') {
                state.view = 'time';
                render();
                focusCurrent();
                return;
            }
            render();
            emit();
        };

        root.addEventListener('click', (event) => {
            const viewButton = event.target.closest('[data-sf-calendar-view]');
            const stepButton = event.target.closest('[data-sf-calendar-step]');
            const day = event.target.closest('.calendar__day');
            const item = event.target.closest('.calendar__item');
            if (viewButton) {
                state.view = viewButton.dataset.sfCalendarView;
                render();
                focusCurrent();
            } else if (stepButton) {
                const direction = Number(stepButton.dataset.sfCalendarStep);
                if (state.view === 'days') {
                    moveCursor(0, direction);
                } else {
                    state.cursor = new Date(state.cursor.getFullYear() + direction * (state.view === 'years' ? YEARS_PAGE : 1), state.cursor.getMonth(), 1);
                    render();
                }
            } else if (day && !day.disabled) {
                selectDay(parseIso(day.dataset.date));
            } else if (item && state.view === 'months') {
                state.cursor = new Date(state.cursor.getFullYear(), Number(item.dataset.value), 1);
                state.view = 'days';
                render();
                focusCurrent();
            } else if (item && state.view === 'years') {
                state.cursor = new Date(Number(item.dataset.value), state.cursor.getMonth(), 1);
                state.view = 'months';
                render();
                focusCurrent();
            } else if (item && state.view === 'time') {
                const kind = item.closest('[data-kind]').dataset.kind;
                const time = state.time ?? {hours: today.getHours(), minutes: 0};
                state.time = {...time, [kind]: Number(item.dataset.value)};
                if (kind === 'hours') {
                    // после часа — минуты
                    render();
                    body.querySelector('[data-kind="minutes"] [tabindex="0"]')?.focus();
                    return;
                }
                if (mode === 'datetime' && !state.selected) {
                    state.selected = new Date(state.cursor);
                }
                state.view = mode === 'time' ? 'time' : 'days';
                render();
                emit();
            }
        });

        root.addEventListener('keydown', (event) => {
            const day = event.target.closest('.calendar__day');
            const item = event.target.closest('.calendar__item');
            if (day) {
                const keys = {
                    ArrowLeft: [-1], ArrowRight: [1], ArrowUp: [-7], ArrowDown: [7],
                    PageUp: [0, event.shiftKey ? -12 : -1], PageDown: [0, event.shiftKey ? 12 : 1],
                };
                if (event.key in keys) {
                    event.preventDefault();
                    moveCursor(...keys[event.key]);
                } else if (event.key === 'Home' || event.key === 'End') {
                    event.preventDefault();
                    const weekday = (state.cursor.getDay() + 6) % 7;
                    moveCursor(event.key === 'Home' ? -weekday : 6 - weekday);
                }
                return;
            }
            if (item && ['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(event.key)) {
                event.preventDefault();
                const items = [...item.parentElement.children];
                const columns = state.view === 'time' ? 1 : 4;
                const shift = {ArrowLeft: -1, ArrowRight: 1, ArrowUp: -columns, ArrowDown: columns}[event.key];
                const next = items[Math.max(0, Math.min(items.length - 1, items.indexOf(item) + shift))];
                items.forEach((entry) => {
                    entry.tabIndex = entry === next ? 0 : -1;
                });
                next.focus();
            }
        });

        root.sfCalendar = {setValue, getValue, focus: focusCurrent};
        setValue(root.dataset.value);
        return root.sfCalendar;
    };

    /* ---------- поле даты ---------- */

    const FORMATS = {
        date: {mask: '##.##.####', toIso: (text) => {
            const match = /^(\d{2})\.(\d{2})\.(\d{4})$/.exec(text);
            return match ? `${match[3]}-${match[2]}-${match[1]}` : '';
        }, fromIso: (value) => {
            const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value);
            return match ? `${match[3]}.${match[2]}.${match[1]}` : '';
        }},
        datetime: {mask: '##.##.#### ##:##', toIso: (text) => {
            const match = /^(\d{2})\.(\d{2})\.(\d{4}) (\d{2}):(\d{2})$/.exec(text);
            return match ? `${match[3]}-${match[2]}-${match[1]} ${match[4]}:${match[5]}` : '';
        }, fromIso: (value) => {
            const match = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})/.exec(value);
            return match ? `${match[3]}.${match[2]}.${match[1]} ${match[4]}:${match[5]}` : '';
        }},
        time: {mask: '##:##', toIso: (text) => (/^\d{2}:\d{2}/.test(text) ? text.slice(0, 5) : ''),
            fromIso: (value) => value.slice(0, 5)},
    };

    /** Маска: цифры по шаблону, разделители подставляются сами */
    const applyMask = (input) => {
        const mask = input.dataset.dateMask;
        const digits = input.value.replace(/\D/g, '');
        let result = '';
        let index = 0;
        for (const char of mask) {
            if (index >= digits.length) {
                break;
            }
            result += char === '#' ? digits[index++] : char;
        }
        input.value = result;
    };

    const getParts = (control) => {
        const root = control.closest('.text-input');
        return {
            root,
            input: root.querySelector('[data-sf-date]'),
            toggle: root.querySelector('[data-sf-date-toggle]'),
            popup: root.querySelector('.text-input__calendar'),
        };
    };

    const closePopup = (parts, isFocusToggle = false) => {
        if (!parts.popup || parts.popup.hidden) {
            return;
        }
        parts.popup.hidden = true;
        parts.toggle.setAttribute('aria-expanded', 'false');
        if (isFocusToggle) {
            parts.toggle.focus();
        }
    };

    const openPopup = (parts) => {
        document.querySelectorAll('.text-input__calendar:not([hidden])').forEach((popup) => {
            if (popup !== parts.popup) {
                closePopup(getParts(popup));
            }
        });
        const calendar = parts.popup.querySelector('[data-sf-calendar]');
        const api = calendar.sfCalendar ?? create(calendar);
        const format = FORMATS[parts.input.dataset.sfDate];
        api.setValue(format.toIso(parts.input.value));
        parts.popup.hidden = false;
        parts.toggle.setAttribute('aria-expanded', 'true');
        // сверху, если снизу не хватает места
        parts.popup.classList.remove('text-input__calendar_top');
        if (parts.popup.getBoundingClientRect().bottom > window.innerHeight) {
            parts.popup.classList.add('text-input__calendar_top');
        }
        api.focus();
    };

    document.addEventListener('click', (event) => {
        const toggle = event.target.closest('[data-sf-date-toggle]');
        if (toggle) {
            const parts = getParts(toggle);
            parts.popup.hidden ? openPopup(parts) : closePopup(parts);
            return;
        }
        // путь события — на момент нажатия: кнопка вида перерисовывается и выпадает из DOM раньше этой проверки
        const path = event.composedPath();
        document.querySelectorAll('.text-input__calendar:not([hidden])').forEach((popup) => {
            if (!path.includes(popup.closest('.text-input'))) {
                closePopup(getParts(popup));
            }
        });
    });

    document.addEventListener('keydown', (event) => {
        const popup = event.target.closest?.('.text-input__calendar');
        if (popup && event.key === 'Escape') {
            event.preventDefault();
            event.stopPropagation();
            closePopup(getParts(popup), true);
        }
    }, true);

    document.addEventListener('calendar:select', (event) => {
        const popup = event.target.closest('.text-input__calendar');
        if (!popup) {
            return;
        }
        const parts = getParts(popup);
        parts.input.value = FORMATS[parts.input.dataset.sfDate].fromIso(event.detail.value);
        parts.input.dispatchEvent(new Event('input', {bubbles: true}));
        parts.input.dispatchEvent(new Event('change', {bubbles: true}));
        closePopup(parts, true);
    });

    document.addEventListener('input', (event) => {
        if (event.target.matches?.('[data-sf-date][data-date-mask]') && event.inputType !== undefined) {
            applyMask(event.target);
        }
    });

    // календари без поля (встроенные) — сразу
    const initStatic = () => document.querySelectorAll('[data-sf-calendar]').forEach((calendar) => {
        if (!calendar.sfCalendar && !calendar.closest('.text-input__calendar')) {
            create(calendar);
        }
    });
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', initStatic) : initStatic();

    window.SimflexCalendar = {create};
})();
