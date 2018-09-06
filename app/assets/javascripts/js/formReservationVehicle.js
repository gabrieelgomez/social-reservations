$('#new_reservation').validate({
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
   'reservation[quantity_kit]': { required: true},
   'reservation[invoice_address]': { required: true},
   'travellers[][name]': { required: true},
   'travellers[][dni]': { required: true}
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
   'reservation[quantity_kit]': 'No puede estar en blanco',
   'reservation[invoice_address]': 'No puede estar en blanco',
   'travellers[][name]': 'No puede estar en blanco',
   'travellers[][dni]': 'No puede estar en blanco'
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


$(function() {
  $( "#datepicker" ).datepicker( $.datepicker.regional[ "es" ] );

  // Datapicker from Fecha Origen ( Ida / Origin)
  var origin = $("#flight_origin_picker");
  origin.datepicker({
    // defaultDate: "+1w",
    // changeMonth: true,
    numberOfMonths: 1,
    timepicker : false,
    format : 'd.m.Y',
    minDate : 1,
    onClose: function( selectedDate ) {
      console.log('La fecha inicio a cambiado', origin.datepicker('getDate') * 1);
      let date = origin.datepicker('getDate') * 1;
      $('#reservation_flight_origin').val(date);
      $( "#flight_arrival_picker" ).datepicker( "option", "minDate", selectedDate );
    }
  }).on( "change", function() {
  });

  // Datapicker from Fecha Destino ( Vuelta / Arrival)
  var arrival = $("#flight_arrival_picker");
  arrival.datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 1,
    minDate: 1,
    onClose: function( selectedDate ) {
      console.log('La fecha inicio a cambiado', arrival.datepicker('getDate') * 1);
      let date = arrival.datepicker('getDate') * 1;
      $('#reservation_flight_arrival').val(date);
      // $( "#flight_origin_picker" ).datepicker( "option", "maxDate", selectedDate );
    }
  }).on( "change", function() {
  });

});

// $( function() {
//
//   var origin = $("#flight_origin_picker");
//
//   origin.datepicker({
//       defaultDate: "+1w",
//       changeMonth: true,
//       changeYear: true,
//       yearRange: "c-10:c+20",
//       numberOfMonths: 1
//     }).on( "change", function() {
//       console.log('La fecha inicio a cambiado', origin.datepicker('getDate') * 1)
//       let date = origin.datepicker('getDate') * 1
//       $('#reservation_flight_origin').val(date)
//     })
//
//
//   var arrival = $("#flight_arrival_picker");
//
//   arrival.datepicker({
//       defaultDate: "+1w",
//       changeMonth: true,
//       changeYear: true,
//       yearRange: "c-10:c+20",
//       numberOfMonths: 1
//     }).on( "change", function() {
//       console.log('La fecha inicio a cambiado', arrival.datepicker('getDate') * 1)
//       let date = arrival.datepicker('getDate') * 1
//       $('#reservation_flight_arrival').val(date)
//     })
//
// } );



// :javascript
//   $( function() {
//   	var dateFormat = "mm/dd/yy",
//   		from = $( "#from" )
//   			.datepicker({
//   				defaultDate: "+1w",
//   				changeMonth: true,
//   				numberOfMonths: 1,
//           minDate: 1
//   			})
//   			.on( "change", function() {
//   				to.datepicker( "option", "minDate", getDate( this ));
//   			}),
//   		to = $( "#to" ).datepicker({
//   			defaultDate: "+1w",
//   			changeMonth: true,
//   			numberOfMonths: 1
//   		})
//   		.on( "change", function() {
//   			from.datepicker( "option", "maxDate", getDate( this ));
//   		});
//
//   	function getDate( element ) {
//   		var date;
//   		try {
//   			date = $.datepicker.parseDate( dateFormat, element.value );
//   		} catch( error ) {
//   			date = null;
//   		}
//
//   		return date;
//   	}
//   } );
