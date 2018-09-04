$(document).ready(function () {
  var map;

  function initialize() {
    var options = {
      types: [],
      componentRestrictions: {
        country: "col"
      },
    };

    inputSearchTransfer('origin_transfer');
    inputSearchTransfer('arrival_transfer');

    function inputSearchTransfer(id_input) {
      var input = document.getElementById(id_input);
      var autocomplete = new google.maps.places.Autocomplete(input, options);
      autocomplete.addListener('place_changed', onPlaceChanged);
      function onPlaceChanged() {
        var place = autocomplete.getPlace();
        var latitude = place.geometry.location.lat();
        var longitude = place.geometry.location.lng();

        if (id_input == 'origin_transfer'){
          let field = $('#origin_hidden');
          field.val([latitude, latitude]);
        }else if(id_input == 'arrival_transfer'){
          let field = $('#arrival_hidden');
          field.val([latitude, latitude]);
        }

      }
    }

  }

  google.maps.event.addDomListener(window, 'load', initialize);
});
