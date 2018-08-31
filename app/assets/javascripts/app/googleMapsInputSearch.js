$(document).ready(function() {
  var map;
  function initialize() {
    var options = {
      types: ['(cities)'],
      componentRestrictions: {country: "col"},
    };

    inputSearchTransfer('origin_transfer')

    inputSearchTransfer('arrival_transfer');

    function inputSearchTransfer(id_input) {
      var input = document.getElementById(id_input);
      var autocomplete = new google.maps.places.Autocomplete(input, options);
      autocomplete.addListener('place_changed', onPlaceChanged);
      // When the user selects a city on input search, get the place details for the city and
      // zoom the map in on the city.
      function onPlaceChanged() {
        var place = autocomplete.getPlace();
        var latitude = place.geometry.location.lat();
        var longitude = place.geometry.location.lng();
        console.log('Latitude', latitude);
        console.log('Longitude', longitude);
         // $('form').append(`<input type="hidden" name="destination[latitude]" value="${latitude}" /> `);
         // $('form').append(`<input type="hidden" name="destination[longitude]" value="${longitude}" /> `);
      }
    }

  }

  google.maps.event.addDomListener(window, 'load', initialize);
});
