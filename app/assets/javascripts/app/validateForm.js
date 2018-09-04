function validateForm(id_form) {
  $(id_form).validate({
    event: "blur",
    errorClass: "error-class",
    validClass: "valid-class",
    rules: {
      'quantity_kids': {
        required: true
      },
      'quantity_adults': {
        required: true
      },
      'origin_transfer': {
        required: true
      },
      'arrival_transfer': {
        required: true
      }
    },
    messages: {
      'quantity_kids': 'No puede estar en blanco',
      'quantity_adults': 'No puede estar en blanco',
      'origin_transfer': 'No puede estar en blanco',
      'arrival_transfer': 'No puede estar en blanco'
    },
    debug: true,
    errorElement: "label",
    submitHandler: function (form) {
      form.submit();
    }
  });
}