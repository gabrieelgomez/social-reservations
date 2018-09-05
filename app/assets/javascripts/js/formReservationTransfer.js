$('#new_reservation').validate({
 event: "blur",
 errorClass: "error-class",
 validClass: "valid-class",
 rules: {
   'reservation[origin]': { required: true},
   'reservation[arrival]': { required: true},
   'reservation[flight_origin]': { required: true},
   'flight_origin_picker': { required: true},
   // 'reservation[flight_arrival]': { required: true},
   // 'flight_arrival_picker': { required: true},
   'reservation[quantity_adults]': { required: true},
   'reservation[quantity_kids]': { required: true},
   'reservation[quantity_kit]': { required: true},
   // 'reservation[airline]': { required: true},
   // 'reservation[flight_number]': { required: true},
   'reservation[description]': { required: true}

   },
 messages: {
   'reservation[origin]': 'No puede estar en blanco',
   'reservation[arrival]': 'No puede estar en blanco',
   'reservation[flight_origin]': 'No puede estar en blanco',
   'flight_origin_picker': 'No puede estar en blanco',
   // 'reservation[flight_arrival]': 'No puede estar en blanco',
   // 'flight_arrival_picker': 'No puede estar en blanco',
   'reservation[quantity_adults]': 'No puede estar en blanco',
   'reservation[quantity_kids]': 'No puede estar en blanco',
   'reservation[quantity_kit]': 'No puede estar en blanco',
   // 'reservation[airline]': 'No puede estar en blanco',
   // 'reservation[flight_number]': 'No puede estar en blanco',
   'reservation[description]': 'No puede estar en blanco'
   },
 debug: true,errorElement: "label",
 submitHandler: function(form){

  swal({
  type: 'success',
  title: '¡Listo!',
  text: '¡Tu reservación ha sido enviada exitosamente!'
  })

  form.submit();
 }
});


$( function() {

  var origin = $("#flight_origin_picker");

  origin.datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      changeYear: true,
      yearRange: "c-10:c+20",
      numberOfMonths: 1
    }).on( "change", function() {
      console.log('La fecha inicio a cambiado', origin.datepicker('getDate') * 1)
      let date = origin.datepicker('getDate') * 1
      $('#reservation_flight_origin').val(date)
    })


  var arrival = $("#flight_arrival_picker");

  arrival.datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      changeYear: true,
      yearRange: "c-10:c+20",
      numberOfMonths: 1
    }).on( "change", function() {
      console.log('La fecha inicio a cambiado', arrival.datepicker('getDate') * 1)
      let date = arrival.datepicker('getDate') * 1
      $('#reservation_flight_arrival').val(date)
    })

} );
