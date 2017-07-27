define(['jquery'], function ($){
    var $w = $(window);
    $w.on('load resize', function() {
        if ($w.width() >= 768) {
            $('.main-content').css({
                'width': 'calc(100% - 315px)',
                'position': 'absolute',
                'right': '0',
                'top': '0'  
            })
            $('.column').css({
                'column-count': 2,
                '-webkit-column-count': 2,
                '-moz-column-count': 2,

                '-webkit-column-gap': '40px',
                '-moz-column-gap': '40px',
                'column-gap': '40px'
            })
        }
        else {
            $('.main-content').css({
                'width': '100%',
                'position': 'relative',
                'right': 'auto',
                'top': 'auto'
            })
            $('.column').css({
                'column-count': 1,
                '-webkit-column-count': 1,
                '-moz-column-count': 1
            })

        }
    });
});
