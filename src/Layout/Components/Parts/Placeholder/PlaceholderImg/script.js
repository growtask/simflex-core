/**
 * Отложенные картинки PlaceholderImg (параметр deferred): файлы лежат в data-srcset и data-src, пока блок скрыт.
 * При показе блока (окно, вкладка, слайдер) вызови sfPlaceholderImg.reveal(блок) - браузер начнёт загрузку
 */
(function () {
    'use strict';

    function reveal(root) {
        var scope = root || document;
        scope.querySelectorAll('picture.placeholder-img [data-srcset]').forEach(function (source) {
            source.setAttribute('srcset', source.getAttribute('data-srcset'));
            source.removeAttribute('data-srcset');
        });
        scope.querySelectorAll('picture.placeholder-img img[data-src]').forEach(function (img) {
            img.setAttribute('src', img.getAttribute('data-src'));
            img.removeAttribute('data-src');
        });
    }

    window.sfPlaceholderImg = {reveal: reveal};
})();
