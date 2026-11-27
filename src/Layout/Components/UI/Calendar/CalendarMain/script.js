/*
 * Календарь (Calendar): виды days (сетка дней, неделя с понедельника, дни других месяцев приглушены), months,
 * years (по 20 лет), time (часы и минуты с шагом data-step). Заголовок переключает виды, стрелки листают месяц,
 * год, страницу лет. Клавиатура в днях: стрелки — день и неделя, PageUp/PageDown — месяц (с Shift — год),
 * Home/End — начало и конец недели, Enter/Space — выбор. Даты вне data-min/data-max недоступны: курсор не выходит
 * за диапазон, месяцы и годы вне него недоступны (disabled), стрелка к странице вне диапазона — aria-disabled.
 * Кнопки шапки озвучивают значение («Март, выбрать месяц»). Колонки времени прокручиваются сами (не страница).
 * Выбор — событие calendar:select ({detail: {value}}): дата 'Y-m-d', дата и время 'Y-m-d H:i', время 'H:i';
 * в режиме datetime день открывает вид time. Метод: element.sfCalendar.setValue(value).
 * data-selection: none (только показ), single, range — диапазон двумя кликами, значение 'Y-m-d/Y-m-d'.
 * data-format="12h": в виде time часы 12, 1–11 и колонка AM/PM, в значении по-прежнему 24 часа.
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
        const selection = root.dataset.selection || 'single';
        const is12h = root.dataset.format === '12h';
        const today = new Date();

        const state = {
            view: mode === 'time' ? 'time' : 'days',
            selected: null,
            range: {start: null, end: null},
            time: null,
            cursor: new Date(today.getFullYear(), today.getMonth(), today.getDate()),
        };

        const isDisabled = (date) => (min && date < min) || (max && date > max);
        // курсор (день с tabindex=0) — всегда внутри min/max
        const clamp = (date) => (min && date < min ? new Date(min) : (max && date > max ? new Date(max) : date));
        // пересекается ли отрезок дат [from, to] с min/max
        const inRange = (from, to) => !(min && to < min) && !(max && from > max);
        // страница, на которую ведёт стрелка: месяц (days), год (months), 20 лет (years)
        const pageRange = (direction) => {
            const year = state.cursor.getFullYear();
            if (state.view === 'days') {
                const month = state.cursor.getMonth() + direction;
                return [new Date(year, month, 1), new Date(year, month + 1, 0)];
            }
            const span = state.view === 'years' ? YEARS_PAGE : 1;
            const start = (state.view === 'years' ? year - (year % YEARS_PAGE) : year) + direction * span;
            return [new Date(start, 0, 1), new Date(start + span - 1, 11, 31)];
        };

        const formatTime = (time) => {
            if (!is12h) {
                return `${pad(time.hours)}:${pad(time.minutes)}`;
            }
            return `${pad(time.hours % 12 || 12)}:${pad(time.minutes)} ${time.hours >= 12 ? 'PM' : 'AM'}`;
        };

        const setValue = (value) => {
            if (selection === 'range') {
                const [start, end] = String(value ?? '').split('/');
                state.range = {start: parseIso(start), end: parseIso(end)};
            }
            state.selected = mode === 'time' ? null : parseIso(value);
            state.time = parseTime(mode === 'date' ? '' : value);
            state.cursor = clamp(state.selected ? new Date(state.selected) : new Date(today.getFullYear(), today.getMonth(), today.getDate()));
            state.view = mode === 'time' ? 'time' : 'days';
            render();
        };

        const getValue = () => {
            const time = state.time ?? {hours: 0, minutes: 0};
            const timeText = `${pad(time.hours)}:${pad(time.minutes)}`;
            if (mode === 'time') {
                return timeText;
            }
            if (selection === 'range') {
                const {start, end} = state.range;
                return start ? isoDate(start) + (end ? `/${isoDate(end)}` : '') : '';
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
            // подпись кнопки содержит значение: aria-label заменяет видимый текст целиком
            month.setAttribute('aria-label', `${month.textContent}, ${isTime ? 'к дням' : 'выбрать месяц'}`);
            const startYear = state.cursor.getFullYear() - (state.cursor.getFullYear() % YEARS_PAGE);
            year.textContent = state.view === 'years' ? `${startYear}–${startYear + YEARS_PAGE - 1}` : String(state.cursor.getFullYear());
            year.setAttribute('aria-label', `${year.textContent}, выбрать год`);
            const hasTime = mode !== 'date' && state.time !== null;
            timeButton.hidden = !hasTime;
            line.hidden = !hasTime || (isTime && mode === 'time');
            if (hasTime) {
                timeButton.textContent = formatTime(state.time);
                timeButton.setAttribute('aria-label', `${timeButton.textContent}, выбрать время`);
            }
            // в виде time стрелок нет: часы и минуты прокручиваются
            root.querySelectorAll('[data-sf-calendar-step]').forEach((button) => {
                button.hidden = isTime;
                // страница вне min/max: кнопка остаётся фокусируемой (не disabled — фокус не уходит в body)
                const off = !isTime && !inRange(...pageRange(Number(button.dataset.sfCalendarStep)));
                off ? button.setAttribute('aria-disabled', 'true') : button.removeAttribute('aria-disabled');
            });
            const field = root.querySelector('.calendar__time-field');
            if (field) {
                field.textContent = hasTime ? formatTime(state.time) : '—:—';
                field.setAttribute('aria-label', `${hasTime ? field.textContent : 'не выбрано'}, выбрать время`);
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
                    let isSelected = sameDay(date, state.selected);
                    if (selection === 'none') {
                        isSelected = false;
                    } else if (selection === 'range') {
                        const {start, end} = state.range;
                        const isStart = sameDay(date, start);
                        const isEnd = sameDay(date, end);
                        isSelected = isStart || isEnd;
                        cell.classList.toggle('calendar__day_range-start', isStart && end !== null);
                        cell.classList.toggle('calendar__day_range-end', isEnd);
                        cell.classList.toggle('calendar__day_range', Boolean(start && end && date > start && date < end));
                    }
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
            items.forEach(({text, value, isSelected, isCurrent, label, isOut}) => {
                const item = element('button', 'calendar__item', text);
                item.type = 'button';
                item.setAttribute('role', 'option');
                item.dataset.value = String(value);
                item.setAttribute('aria-selected', String(isSelected));
                item.classList.toggle('calendar__item_current', isCurrent);
                if (label) {
                    item.setAttribute('aria-label', label);
                }
                // месяц или год вне min/max
                item.disabled = Boolean(isOut);
                const hasSelected = items.some((entry) => entry.isSelected && !entry.isOut);
                item.tabIndex = !isOut && (isSelected || (!hasSelected && isCurrent)) ? 0 : -1;
                grid.append(item);
            });
            if (!grid.querySelector('[tabindex="0"]')) {
                const first = grid.querySelector('.calendar__item:not(:disabled)') ?? grid.firstChild;
                first.tabIndex = 0;
            }
            return grid;
        };

        const renderTime = () => {
            const columns = element('div', 'calendar__columns');
            const time = state.time ?? {hours: today.getHours(), minutes: Math.floor(today.getMinutes() / step) * step};
            const column = (title, kind, values, current, text = pad) => {
                const wrap = element('div', 'calendar__column');
                wrap.append(element('span', 'calendar__column-title', title));
                const list = element('div', 'calendar__column-list');
                list.setAttribute('role', 'listbox');
                list.setAttribute('aria-label', title);
                list.dataset.kind = kind;
                values.forEach((value) => {
                    const item = element('button', 'calendar__item', text(value));
                    item.type = 'button';
                    item.setAttribute('role', 'option');
                    item.dataset.value = String(value);
                    const isSelected = state.time !== null && value === current;
                    item.setAttribute('aria-selected', String(isSelected));
                    item.tabIndex = value === current ? 0 : -1;
                    list.append(item);
                });
                // прокрутка — у своей колонки высотой 5 строк, не у страницы
                const scroll = element('div', 'calendar__column-scroll');
                scroll.append(list);
                wrap.append(scroll);
                return wrap;
            };
            const minutes = [];
            for (let minute = 0; minute < 60; minute += step) {
                minutes.push(minute);
            }
            const minute = minutes.reduce((best, value) => (Math.abs(value - time.minutes) < Math.abs(best - time.minutes) ? value : best), 0);
            if (is12h) {
                // 12-часовой формат: часы 12, 1–11 и колонка AM/PM; в значении остаются 24 часа
                columns.classList.add('calendar__columns_12h');
                columns.append(
                    column('Часы', 'hours', [12, ...Array.from({length: 11}, (_, index) => index + 1)], time.hours % 12 || 12),
                    column('Минуты', 'minutes', minutes, minute),
                    column('Период', 'period', [0, 1], time.hours >= 12 ? 1 : 0, (value) => (value ? 'PM' : 'AM')),
                );
                return columns;
            }
            columns.append(
                column('Часы', 'hours', [...Array(24).keys()], time.hours),
                column('Минуты', 'minutes', minutes, minute),
            );
            return columns;
        };

        // Переходы (style.scss): смена экрана — calendar-zoom-in (глубже: годы → месяцы → дни → время) или
        // calendar-zoom-out, смена страницы того же экрана — calendar-slide (--calendar-dir: 1 вперёд, -1 назад).
        // Уходящий экран — absolute на своём месте; высота карточки на время перехода плавно меняется (transition height)
        const DEPTH = {years: 0, months: 1, days: 2, time: 3};
        let shown = null;
        const pageOf = () => {
            const year = state.cursor.getFullYear();
            if (state.view === 'days') {
                return year * 12 + state.cursor.getMonth();
            }
            if (state.view === 'months') {
                return year;
            }
            return state.view === 'years' ? Math.floor(year / YEARS_PAGE) : 0;
        };
        const swap = (content) => {
            const page = pageOf();
            const old = body.firstElementChild;
            const prev = shown;
            shown = {view: state.view, page};
            let kind = '';
            if (old && prev && window.SfUi?.transition && !window.SfUi.reduced() && root.offsetParent !== null) {
                if (prev.view !== state.view) {
                    kind = DEPTH[state.view] > DEPTH[prev.view] ? 'calendar-zoom-in' : 'calendar-zoom-out';
                } else if (prev.page !== page) {
                    kind = 'calendar-slide';
                    root.style.setProperty('--calendar-dir', page > prev.page ? '1' : '-1');
                }
            }
            if (!kind) {
                body.replaceChildren(content);
                return;
            }
            const from = root.offsetHeight;
            old.style.top = `${old.offsetTop}px`;
            old.style.left = `${old.offsetLeft}px`;
            old.style.width = `${old.offsetWidth}px`;
            [...body.children].filter((child) => child !== old).forEach((child) => child.remove());
            content.hidden = true;
            // новый экран - первым: поиск фокуса и выбранного (body.querySelector) находит его, а не уходящий
            old.inert = true;
            body.prepend(content);
            window.SfUi.transition(old, kind, false).then(() => old.remove());
            window.SfUi.transition(content, kind, true);
            const to = root.offsetHeight;
            if (Math.abs(to - from) >= 1) {
                root.style.height = `${from}px`;
                root.getBoundingClientRect();
                root.style.height = `${to}px`;
                clearTimeout(root.sfCalendarHeight);
                root.sfCalendarHeight = setTimeout(() => root.style.removeProperty('height'),
                    (window.SfUi.motionMs(root, '--motion-slow', 240)) + 60);
            }
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
                    isOut: !inRange(new Date(state.cursor.getFullYear(), index, 1), new Date(state.cursor.getFullYear(), index + 1, 0)),
                })));
            } else if (state.view === 'years') {
                const startYear = state.cursor.getFullYear() - (state.cursor.getFullYear() % YEARS_PAGE);
                content = renderItems([...Array(YEARS_PAGE).keys()].map((index) => ({
                    text: String(startYear + index),
                    value: startYear + index,
                    isSelected: state.selected?.getFullYear() === startYear + index,
                    isCurrent: today.getFullYear() === startYear + index,
                    isOut: !inRange(new Date(startYear + index, 0, 1), new Date(startYear + index, 11, 31)),
                })));
            } else if (state.view === 'time') {
                content = renderTime();
            } else {
                content = renderDays();
            }
            swap(content);
            scrollColumns();
        };

        // выбранное время — на средней строке своей колонки; scrollIntoView прокручивал бы и страницу.
        // В скрытом календаре (поле даты до открытия) размеров нет — повтор в focusCurrent после показа
        const scrollColumns = () => body.querySelectorAll('.calendar__column-scroll').forEach((scroll) => {
            const item = scroll.querySelector('[tabindex="0"]');
            if (item && scroll.clientHeight) {
                const offset = item.getBoundingClientRect().top - scroll.getBoundingClientRect().top + scroll.scrollTop;
                scroll.scrollTop = offset - (scroll.clientHeight - item.offsetHeight) / 2;
            }
        });

        const focusCurrent = () => {
            scrollColumns();
            body.querySelector('[tabindex="0"]')?.focus({preventScroll: true});
        };

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
            state.cursor = clamp(next);
            render();
            focusCurrent();
        };

        const selectDay = (date) => {
            if (isDisabled(date) || selection === 'none') {
                return;
            }
            if (selection === 'range') {
                // первый клик — начало, второй — конец (раньше начала — меняются местами), третий начинает заново
                const {start, end} = state.range;
                if (!start || end) {
                    state.range = {start: date, end: null};
                } else {
                    state.range = date < start ? {start: date, end: start} : {start, end: date};
                }
                state.selected = date;
                state.cursor = new Date(date);
                render();
                if (state.range.end) {
                    emit();
                }
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
                if (stepButton.getAttribute('aria-disabled') === 'true') {
                    return;
                }
                const direction = Number(stepButton.dataset.sfCalendarStep);
                if (state.view === 'days') {
                    moveCursor(0, direction);
                } else {
                    state.cursor = clamp(new Date(state.cursor.getFullYear() + direction * (state.view === 'years' ? YEARS_PAGE : 1), state.cursor.getMonth(), 1));
                    render();
                }
            } else if (day && !day.disabled) {
                selectDay(parseIso(day.dataset.date));
            } else if (item && item.disabled) {
                // месяц или год вне min/max
            } else if (item && state.view === 'months') {
                state.cursor = clamp(new Date(state.cursor.getFullYear(), Number(item.dataset.value), 1));
                state.view = 'days';
                render();
                focusCurrent();
            } else if (item && state.view === 'years') {
                state.cursor = clamp(new Date(Number(item.dataset.value), state.cursor.getMonth(), 1));
                state.view = 'months';
                render();
                focusCurrent();
            } else if (item && state.view === 'time') {
                const kind = item.closest('[data-kind]').dataset.kind;
                const time = state.time ?? {hours: today.getHours(), minutes: 0};
                const value = Number(item.dataset.value);
                if (kind === 'hours' && is12h) {
                    state.time = {...time, hours: (value % 12) + (time.hours >= 12 ? 12 : 0)};
                } else if (kind === 'period') {
                    // AM/PM только меняет полдень, выбор времени не завершает
                    state.time = {...time, hours: (time.hours % 12) + value * 12};
                    render();
                    body.querySelector('[data-kind="period"] [tabindex="0"]')?.focus();
                    if (mode === 'time' || state.selected) {
                        emit();
                    }
                    return;
                } else {
                    state.time = {...time, [kind]: value};
                }
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
                // недоступные (вне min/max) пропускаются; дальше края — остаёмся на месте
                let index = items.indexOf(item) + shift;
                while (items[index]?.disabled) {
                    index += shift;
                }
                const next = items[index] ?? item;
                items.forEach((entry) => {
                    entry.tabIndex = entry === next ? 0 : -1;
                });
                next.focus();
                scrollColumns();
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
