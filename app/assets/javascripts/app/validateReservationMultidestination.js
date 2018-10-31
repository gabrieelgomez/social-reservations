function validateReservationMultidestination(id_form) {
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
     'invoice[][address]': { required: true},
     'travellers[][name]': { required: true},
     'travellers[][dni]': { required: true, digits: true, number: true},
     'user[][name]': { required: true},
     'user[][phone]': { required: true, digits: true, number: true},
     'user[][dni]': { required: true, digits: true, number: true},
     'user[][email]': { required: true, email: true},
     'privacy_policy': {required: true},
     'terms_conditions': {required: true},
     'cancellations_policy': {required: true}
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
     'invoice[][address]': 'No puede estar en blanco',
     'travellers[][name]': 'No puede estar en blanco',
     'travellers[][dni]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][name]': 'No puede estar en blanco',
     'user[][phone]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][dni]': {required: 'No puede estar en blanco', digits: 'Sólo números válidos', number: 'Sólo números'},
     'user[][email]': {required: 'No puede estar en blanco', email: 'E-mail inválido'},
     'privacy_policy': 'Debes aceptar',
     'terms_conditions': 'Debes aceptar',
     'cancellations_policy': 'Debes aceptar'
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){
    let lodgment =  lodgment_id_radio;
    json_parse = JSON.parse(lodgment_id_radio);

     $('form').append(`<input type="hidden" name="square_multidestination[][lodgment_id]" value=${json_parse['lodgment_id']} /> `);
     // debugger;
     form.submit();
   }

  });

}
