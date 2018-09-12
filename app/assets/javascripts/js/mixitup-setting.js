$(document).ready(function () {
  $('#mix-wrapper').mixItUp({
    load: {
      sort: 'order:asc'
    },
    animation: {

      duration: 700
    },
    selectors: {
      target: '.mix-target',
      filter: '.filter-btn',
      sort: '.sort-btn'
    },
    callbacks: {
      onMixEnd: function (state) {
        console.log(state)
      }
    }
  });
});