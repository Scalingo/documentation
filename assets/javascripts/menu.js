define(['jquery'], function ($){
    // Stick the #menu to the top of the window
    if (window.location.pathname !== '/404.html' && document.title.indexOf('404 Not found') == -1) {
        var menu = $('.menu');
        var menuHomeY = menu.scrollTop();
        var isFixed = false;
        var $w = $(window);
        $w.scroll(function() {
            var scrollTop = $w.scrollTop();
            var shouldBeFixed = scrollTop > menuHomeY;
            if (shouldBeFixed && !isFixed) {
                menu.css({
                    'position': 'fixed',
                    'top': '0',
                    'max-height': '100%',
                    'width': '13%'
                });
                isFixed = true;
            }
            else if (!shouldBeFixed && isFixed)
            {
                menu.css({
                    'position': 'absolute',
                    'top': 'auto',
                    'max-height': $(window).height()-20,
                    'width': '86%'
                });
                isFixed = false;
            }
        })
        $(".menu").scrollTop($("#currentpage").offset().top-70)
    }
});
