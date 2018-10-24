var $burguer = document.getElementById('js-menu-mobile');
var $menu = document.getElementById('js-mobile');

function toggleMenu() {
  $menu.classList.toggle('nav-open');
};

$burguer.addEventListener('click', toggleMenu);