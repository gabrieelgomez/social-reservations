$(document).ready(function () {
  WebFontConfig = {
    google: {
      families: ['Poppins:100,200,300,400,500,600,700,800,900', 'Patua+One']
    }
  };
  (function () {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') + '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
  })();

});