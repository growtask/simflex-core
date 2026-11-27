/* Аудиоплеер (PlayerAudio): кнопка воспроизведения, заполнение волны по прогрессу, перемотка нажатием и перетаскиванием по волне,
 * клавиатура (пробел — пуск/пауза, на волне ← → — 5 с, PageUp/PageDown — 10 %, Home/End), время.
 * Кнопка пуска — подпись меняется («Воспроизвести» / «Пауза»), без aria-pressed (иначе состояние озвучивалось бы дважды).
 * Проигранная часть — слой .player-wave__played (те же столбики с __bar_played) поверх ряда,
 * обрезанный clip-path по --wave-progress (доля ширины волны; столбики не перекрашиваются). */
(() => {
    const fmt = (s) => {
        s = Math.max(0, Math.floor(Number.isFinite(s) ? s : 0));
        const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), sec = String(s % 60).padStart(2, '0');
        return h ? `${h}:${String(m).padStart(2, '0')}:${sec}` : `${m}:${sec}`;
    };

    const init = (player) => {
        if (player.dataset.sfPlayerReady) {
            return;
        }
        player.dataset.sfPlayerReady = '1';
        const audio = player.querySelector('[data-sf-player-audio]');
        const button = player.querySelector('[data-sf-player-play]');
        const wave = player.querySelector('[data-sf-player-wave]');
        // столбики ряда (без слоя проигранной части)
        const bars = [...wave.querySelectorAll(':scope > .player-wave__bar')];
        const current = player.querySelector('[data-sf-player-current]');
        const total = player.querySelector('[data-sf-player-total]');
        let frame = 0;

        const render = () => {
            const d = audio.duration || 0, t = audio.currentTime || 0;
            // видимые столбики (лишние обрезаны overflow) — по ширине волны
            const visible = Math.min(bars.length, Math.floor((wave.clientWidth + 2) / 4)) || bars.length;
            // доля проигранного — от видимых столбиков (лишние обрезаны), clip-path слоя — от ширины волны
            const share = d ? Math.min(1, t / d) : 0;
            const width = wave.clientWidth || 1;
            wave.style.setProperty('--wave-progress', String(Math.min(1, share * Math.min(width, visible * 4 - 2) / width)));
            wave.setAttribute('aria-valuenow', String(d ? Math.round((t / d) * 100) : 0));
            wave.setAttribute('aria-valuetext', `${fmt(t)} из ${fmt(d)}`);
            if (current) current.textContent = fmt(t);
            if (total && d) total.textContent = fmt(d);
        };
        const loop = () => {
            render();
            frame = audio.paused ? 0 : requestAnimationFrame(loop);
        };
        const seek = (s) => {
            if (!audio.duration) return;
            audio.currentTime = Math.min(audio.duration, Math.max(0, s));
            render();
        };
        const toggle = () => (audio.paused ? audio.play().catch(() => {}) : audio.pause());
        const setIcon = (name) => button.querySelector('use')?.setAttribute('href',
            button.querySelector('use').getAttribute('href').replace(/#icon-.*$/, '#icon-' + name));

        audio.addEventListener('play', () => {
            button.setAttribute('aria-label', 'Пауза');
            setIcon('pause');
            if (!frame) frame = requestAnimationFrame(loop);
        });
        audio.addEventListener('pause', () => {
            button.setAttribute('aria-label', 'Воспроизвести');
            setIcon('play-fill');
        });
        audio.addEventListener('loadedmetadata', render);
        audio.addEventListener('timeupdate', render);
        button.addEventListener('click', toggle);

        const fraction = (e) => {
            const r = wave.getBoundingClientRect();
            const visible = Math.min(bars.length, Math.floor((wave.clientWidth + 2) / 4)) * 4 - 2;
            return Math.min(1, Math.max(0, (e.clientX - r.left) / (visible || r.width)));
        };
        let dragging = false;
        wave.addEventListener('pointerdown', (e) => {
            dragging = true;
            try { wave.setPointerCapture(e.pointerId); } catch (err) { /* указатель уже отпущен */ }
            seek(fraction(e) * audio.duration);
        });
        wave.addEventListener('pointermove', (e) => dragging && seek(fraction(e) * audio.duration));
        wave.addEventListener('pointerup', () => { dragging = false; });
        wave.addEventListener('keydown', (e) => {
            const d = audio.duration || 0;
            const map = { ArrowLeft: -5, ArrowDown: -5, ArrowRight: 5, ArrowUp: 5, PageDown: -d / 10, PageUp: d / 10 };
            if (e.key in map) seek(audio.currentTime + map[e.key]);
            else if (e.key === 'Home') seek(0);
            else if (e.key === 'End') seek(d);
            else return;
            e.preventDefault();
            e.stopPropagation();
        });
        player.addEventListener('keydown', (e) => {
            if (e.key === ' ' && !['button', 'input', 'a'].includes(e.target.localName)) {
                e.preventDefault();
                toggle();
            }
        });
    };

    const run = () => document.querySelectorAll('[data-sf-player]').forEach(init);
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', run);
    } else {
        run();
    }
})();
