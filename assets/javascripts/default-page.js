define(['jquery'], function ($){
    var $w = $(window);
    $w.on('load resize', function() {
        if ($w.width() >= 755) {
            $('.main-content').css({
                'width': 'calc(100% - 315px)',
                'position': 'absolute',
                'right': '0',
                'top': '0'  
            })
        }
        else {
            $('.main-content').css({
                'width': '100%',
                'position': 'relative',
                'right': 'auto',
                'top': 'auto'
            })

        }
    });
});
