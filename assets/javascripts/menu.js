define(['jquery'], function ($){
    // Stick the #menu to the top of the window
    if (window.location.pathname !== '/404.html' && document.title.indexOf('404 Not found') == -1) {
        var menu = $('.menu');
        var menuHomeY = menu.scrollTop();
        var $w = $(window);
        $(document).ready(function(){
            menu.css({
                'position': 'absolute',
                'top': 'auto',
                'height': $(window).height()-40,
                'width': '86%'
            });
            isFixed = false;
        });
        $w.scroll(function() {
            var scrollTop = $w.scrollTop();
            var shouldBeFixed = scrollTop > menuHomeY;
            if (shouldBeFixed && !isFixed) {
                menu.css({
                    'position': 'fixed',
                    'top': '0',
                    'height': '100%',
                    'width': '13%'
                });
                isFixed = true;
            }
            else if (!shouldBeFixed && isFixed)
            {
                menu.css({
                    'position': 'absolute',
                    'top': 'auto',
                    'height': $(window).height()-40,
                    'width': '86%'
                });
                isFixed = false;
            }
        });
        if ( $("#currentpage").offset() ){
            $(".menu").scrollTop($("#currentpage").offset().top-70);
        }
    }
});
