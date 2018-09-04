$(document).ready(function () {
  $(window).on("scroll", function () {
    var scrollTop = $(window).scrollTop();
    if (scrollTop > 50) {
      $('.navigation-front').removeClass('background-hide');
      $('.navigation-front').addClass('background-show');
      $('.logo-nav').removeClass('svg-yellow');
      $('.logo-nav').addClass('svg-white');
    } else {
      $('.navigation-front').removeClass('background-show');
      $('.navigation-front').addClass('background-hide');
      $('.logo-nav').removeClass('svg-white');
      $('.logo-nav').addClass('svg-yellow');
    }
  });
});