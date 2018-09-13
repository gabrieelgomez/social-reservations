function validateWidgetForm(id_form) {
  $(id_form).validate({
    event: "blur",
    errorClass: "error-class",
    validClass: "valid-class",
    rules: {
      'quantity_adults': {
        required: true,
        min: 1
      },
      'origin_vehicle': {
        required: true
      },
      'origin_hidden': {
        required: true
      },
      'arrival_vehicle': {
        required: true
      },
      'arrival_hidden': {
        required: true
      },
      'flight_origin_picker': {
        required: true
      },
      'flight_arrival_picker': {
        required: true
      }
    },
    messages: {
      'quantity_adults': {
        required: 'No puede estar en blanco',
        min: 'Introduce un valor mayor que 1'
      },
      'origin_vehicle': 'No puede estar en blanco',
      'arrival_vehicle': 'No puede estar en blanco',
      'origin_hidden': 'No puede estar en blanco',
      'arrival_hidden': 'No puede estar en blanco',
      'flight_origin_picker': 'No puede estar en blanco',
      'flight_arrival_picker': 'No puede estar en blanco'
    },
    debug: true,
    errorElement: "label",
    submitHandler: function (form) {
      let origin = $('#origin_hidden');
      let arrival = $('#arrival_hidden');
      if (arrival.val() == '' || origin.val() == ''){
        alert('Origen o Destino inválidos')
      }else{
        form.submit();
      }
    }
  });
}
