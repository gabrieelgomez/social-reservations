function validateForm(id_form) {
  $(id_form).validate({
    event: "blur",
    errorClass: "error-class",
    validClass: "valid-class",
    rules: {
      'quantity_adults': {
        required: true,
        min: 1
      },
      'origin_transfer': {
        required: true
      },
      'arrival_transfer': {
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
      'origin_transfer': 'No puede estar en blanco',
      'arrival_transfer': 'No puede estar en blanco',
      'flight_origin_picker': 'No puede estar en blanco',
      'flight_arrival_picker': 'No puede estar en blanco'
    },
    debug: true,
    errorElement: "label",
    submitHandler: function (form) {
      form.submit();
    }
  });
}
