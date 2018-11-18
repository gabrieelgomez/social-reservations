$(document).ready(function () {
  var map;

  $("#origin_name").focus(function() {
     $(this).select();
  });

  $("#arrival_name").focus(function() {
     $(this).select();
  });


  function initialize() {
    var options = {
      // type: ['city', 'locality', 'political'],
      // types: ['geocode'],
      // types: ['(cities)'],
      // types: ['(regions)'],
      // types: ['establishment'],
      componentRestrictions: {
        country: "col"
      },
    };

    inputSearchWidget('origin_name');
    inputSearchWidget('arrival_name');

    function inputSearchWidget(id_input) {
      var input = document.getElementById(id_input);
      var autocomplete = new google.maps.places.Autocomplete(input, options);
      autocomplete.addListener('place_changed', onPlaceChanged);
      function onPlaceChanged() {
        var place = autocomplete.getPlace();
        var latitude = place.geometry.location.lat();
        var longitude = place.geometry.location.lng();

        // Get each component of the address from the place details
        // and fill the corresponding field on the form.
        var locality;
        var departament;

        // For each address administrative_area_level_1 in hash
        for (var i = 0; i < place.address_components.length; i++) {
          var addressType = place.address_components[i].types;
          if (addressType.includes('administrative_area_level_1')){
            departament = place.address_components[i].long_name;
            if (id_input == 'origin_name'){
              exception = validateExceptions(departament);
              let field = $('#origin_departament').val(departament);
              // departament = exception;
              // $('.origin_name').text(`Desde: Localidad, ${departament}`);
            }
            else{
              exception = validateExceptions(departament);
              let field = $('#arrival_departament').val(departament);
              // departament = exception;
              // $('.arrival_name').text(`Hasta: Localidad, ${departament}`);
            }
            // alert(departament);
            break;
          }
        }

        function validateExceptions(exception){
          switch (exception) {
            case 'Bogotá':
              exception = 'Cundinamarca';
              break;
            case 1:
              exception = "Monexception";
              break;
            case 2:
              exception = "Tuesday";
              break;
          }
          return exception;
        }

        // For each address administrative_area_level_1 in hash

        // For each address locality in hash
        for (var i = 0; i < place.address_components.length; i++) {
          var addressType = place.address_components[i].types;
          if (addressType.includes('locality')){
            locality = place.address_components[i].long_name;
            if (id_input == 'origin_name'){
              let field = $('#origin_locality').val(locality);
              $('.origin_name').text(`Desde: Departamento, ${exception}, Localidad, ${locality}`);
            }
            else{
              let field = $('#arrival_locality').val(locality);
              $('.arrival_name').text(`Hasta: Departamento, ${exception}, Localidad, ${locality}`);
            }
            // alert(val);
            break;
          }
        }
        // For each address locality in hash


        // For each address political in hash
        if (!locality){
          for (var i = 0; i < place.address_components.length; i++) {
            var addressType = place.address_components[i].types;
            if (addressType.includes('political')){
              // debugger;
              locality = place.address_components[i].long_name;
              if (id_input == 'origin_name'){
                let field = $('#origin_locality').val(locality);
                $('.origin_name').text(`Desde: Departamento, ${exception}, Localidad, ${locality}`);
              }
              else{
                let field = $('#arrival_locality').val(locality);
                $('.arrival_name').text(`Hasta: Departamento, ${exception}, Localidad, ${locality}`);
              }
              break;
            }
          }
        }
        // For each address political in hash


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


// var latlng 	 = new google.maps.LatLng(latitude, longitude);
// var geocoder = new google.maps.Geocoder();
// geocoder.geocode({'latLng': latlng}, function(results, status) {
//
//   var findResult = function(results, name){
//       var result =  _.find(results, function(obj){
//           return obj.types[0] == name && obj.types[1] == "political";
//       });
//       return result ? result.short_name : null;
//   };
//
//   if (status == google.maps.GeocoderStatus.OK && results.length) {
//       debugger
//       results = results[0].address_components;
//       var city = findResult(results, "locality");
//       var state = findResult(results, "administrative_area_level_1");
//       var country = findResult(results, "country");
//   }
// });
// debugger;
