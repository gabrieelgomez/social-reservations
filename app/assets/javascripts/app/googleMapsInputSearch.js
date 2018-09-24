$(document).ready(function () {
  var map;

  function initialize() {
    var options = {
      types: [],
      componentRestrictions: {
        country: "col"
      },
    };

    inputSearchVehicle('origin_name');
    inputSearchVehicle('arrival_name');

    function inputSearchVehicle(id_input) {
      var input = document.getElementById(id_input);
      var autocomplete = new google.maps.places.Autocomplete(input, options);
      autocomplete.addListener('place_changed', onPlaceChanged);
      function onPlaceChanged() {
        var place = autocomplete.getPlace();
        var latitude = place.geometry.location.lat();
        var longitude = place.geometry.location.lng();
        // debugger

        if (id_input == 'origin_name'){
          let field = $('#origin_location');
          field.val([latitude, latitude]);
        }else if(id_input == 'arrival_name'){
          let field = $('#arrival_location');
          field.val([latitude, latitude]);
        }

      }
    }

  }

  google.maps.event.addDomListener(window, 'load', initialize);
});
