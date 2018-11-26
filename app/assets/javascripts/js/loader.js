/* $(window).load(function () {
  setTimeout(function () {
    //$(".load-fixed").fadeOut(500);
    $('.loader').fadeOut(500, function () {
      $(this).remove();
    });
    $('body').css('overflow-y', 'auto');
    //$('#front-navbar').css('display', 'block');
    //$('.button-shared').css('display', 'block');
    //$('.responsive-container').css("display", "block")
  }, 1000);
});
 */


$(window).on("load", function (e) {
  setTimeout(function () {
    $('.loader').fadeOut(500, function () {
      $(this).remove();
    });
    $('body').css('overflow-y', 'auto');
  }, 1000);
});