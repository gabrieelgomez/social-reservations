function validateReservationVehicle(id_form, kit_quantity) {
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'reservation[origin]': { required: true},
     'reservation[arrival]': { required: true},
     'reservation[flight_origin]': { required: true},
     'flight_origin_picker': { required: true},
     'reservation[flight_arrival]': { required: true},
     'flight_arrival_picker': { required: true},
     'reservation[quantity_adults]': { required: true},
     'reservation[quantity_kids]': { required: true},
     'reservation[quantity_kit]': { required: true, digits: true, number: true, max: kit_quantity},
     'invoice[][address]': { required: true},
     'travellers[][name]': { required: true},
     'travellers[][dni]': { required: true, digits: true, number: true},
     'user[][name]': { required: true},
     'user[][phone]': { required: true, digits: true, number: true},
     'user[][dni]': { required: true, digits: true, number: true},
     'user[][email]': { required: true, email: true},
     'privacy_policy': {required: true},
     'terms_conditions': {required: true}
     },
   messages: {
     'reservation[origin]': 'No puede estar en blanco',
     'reservation[arrival]': 'No puede estar en blanco',
     'reservation[flight_origin]': 'No puede estar en blanco',
     'flight_origin_picker': 'No puede estar en blanco',
     'reservation[flight_arrival]': 'No puede estar en blanco',
     'flight_arrival_picker': 'No puede estar en blanco',
     'reservation[quantity_adults]': 'No puede estar en blanco',
     'reservation[quantity_kids]': 'No puede estar en blanco',
     'reservation[quantity_kit]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números', max: `Máximo equipaje es de ${kit_quantity}`},
     'invoice[][address]': 'No puede estar en blanco',
     'travellers[][name]': 'No puede estar en blanco',
     'travellers[][dni]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][name]': 'No puede estar en blanco',
     'user[][phone]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][dni]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][email]': {required: 'No puede estar en blanco', email: 'E-mail inválido'},
     'privacy_policy': 'Debes aceptar',
     'terms_conditions': 'Debes aceptar'
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){
    form.submit();
   }

  });


  // $(function() {
  //   $( "#datepicker" ).datepicker( $.datepicker.regional[ "es" ] );
  //
  //   // Datapicker from Fecha Origen ( Ida / Origin)
  //   var origin = $("#flight_origin_picker");
  //   origin.datepicker({
  //     // defaultDate: "+1w",
  //     // changeMonth: true,
  //     numberOfMonths: 1,
  //     timepicker : false,
  //     format : 'd.m.Y',
  //     minDate : 1,
  //     onClose: function( selectedDate ) {
  //       console.log('La fecha inicio a cambiado', origin.datepicker('getDate') * 1);
  //       let date = origin.datepicker('getDate') * 1;
  //       $('#reservation_flight_origin').val(date);
  //       $( "#flight_arrival_picker" ).datepicker( "option", "minDate", selectedDate );
  //     }
  //   }).on( "change", function() {
  //   });
  //
  //   // Datapicker from Fecha Destino ( Vuelta / Arrival)
  //   var arrival = $("#flight_arrival_picker");
  //   arrival.datepicker({
  //     defaultDate: "+1w",
  //     changeMonth: true,
  //     numberOfMonths: 1,
  //     minDate: 1,
  //     onClose: function( selectedDate ) {
  //       console.log('La fecha inicio a cambiado', arrival.datepicker('getDate') * 1);
  //       let date = arrival.datepicker('getDate') * 1;
  //       $('#reservation_flight_arrival').val(date);
  //       // $( "#flight_origin_picker" ).datepicker( "option", "maxDate", selectedDate );
  //     }
  //   }).on( "change", function() {
  //   });
  //
  // });

}
