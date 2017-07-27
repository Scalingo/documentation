define(['jquery'], function ($){
    // Stick the #menu to the top of the window
    if (window.location.pathname !== '/404.html' && document.title.indexOf('404 Not found') == -1) {
        var menu = $('.menu');
        var menuHomeY = 111;
        var $w = $(window);
        $(document).ready(function(){
            menu.css({
                'position': 'absolute',
                'top': 'auto',
                'height': $(window).height()-80
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
                    'height': '100%'
                });
                isFixed = true;
            }
            else if (!shouldBeFixed && isFixed)
            {
                menu.css({
                    'position': 'absolute',
                    'top': 'auto',
                    'height': $(window).height()-80
                });
                isFixed = false;
            }
        });
        $(document).ready(function() {
            if ( $(".currentsection").offset() ){
                if ( $(".currentsection > ul").offset() ) {
                    $(".currentsection > ul > li:first-child").addClass("currentlink");
                    $(".currentsection > ul").css({'display': 'block'});
                }
                else {
                    $(".currentsection > a").addClass("currentlink");
                }
            }
            else if ( $(".currentsection1").offset() ){
                if ( $(".currentsection1 > ul").offset() ) {
                    $(".currentsection1 > ul > li:first-child").addClass("currentlink");
                    $(".currentsection1 > ul").css({'display': 'block'});
                }
                else {
                    $(".currentsection1 > a").addClass("currentlink");
                }
                $(".currentsection1").parent().css({'display': 'block'});
                $(".currentsection1").parent().parent().addClass("currentsection");
            }
            else if ( $(".currentsection2").offset() ){
                if ( $(".currentsection2 > ul").offset() ) {
                    $(".currentsection2 > ul > li:first-child").addClass("currentlink");
                    $(".currentsection2 > ul").css({'display': 'block'});
                }
                else {
                    $(".currentsection2 > a").addClass("currentlink");
                }
                $(".currentsection2").parent().css({'display': 'block'});
                $(".currentsection2").parent().parent().addClass("currentsection1");
                $(".currentsection1").parent().css({'display': 'block'});
                $(".currentsection1").parent().parent().addClass("currentsection");
            }
            if ( $(".currentsection span") ){
                $(".currentsection > a > p > span").removeClass("fa-chevron-right");
                $(".currentsection > a > p > span").addClass("fa-chevron-down");
            }
            if ( $(".currentsection1 span") ){
                $(".currentsection1 > a > p > span").removeClass("fa-chevron-right");
                $(".currentsection1 > a > p > span").addClass("fa-chevron-down");
            }
            if ( $(".currentsection").offset() ){
                $(".menu").scrollTop($(".currentsection").offset().top-140);
            }
        });
    }
});
