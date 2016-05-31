function slideShow() {
    var timer,obj;

    obj = {}
    obj.resume = function() {
        timerOn = true;
        timer =
            setInterval(obj.step, 7000);
    };
    obj.pause = function() {
        clearInterval(timer);
    };

    obj.step = function() {
        $('#slideshow > div:first')
            .fadeOut(100)
            .next()
            .fadeIn(100)
            .end()
            .appendTo('#slideshow');
    };
    obj.resume();
    return obj;

}

$("#slideshow > div:gt(0)").hide();

var slideShow = slideShow();

$("#forward").click(function() {

    $('#slideshow > div:first')
        .fadeOut(100)
        .next()
        .fadeIn(100)
        .end()
        .appendTo('#slideshow');

});

$("#back").click(function() {

    $('#slideshow > div').filter(":last")
        .fadeOut(100)
        .next()
        .fadeIn(100)
        .end()
        .prependTo('#slideshow');

    $("#slideshow > div").filter(":eq(0)").show();

    $("#slideshow > div").filter(":gt(0)").hide();

});

$("#pause").click(function() {

    if ($("#pause").text() == "ll") {

        console.log('ll');
        slideShow.pause();
        $("#pause").html(">");
    } else {
        console.log('>');
        slideShow.resume();
        $("#pause").html("ll");
    }
});
