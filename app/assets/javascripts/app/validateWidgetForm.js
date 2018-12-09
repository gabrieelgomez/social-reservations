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
      'origin_name': {
        required: true
      },
      'origin_location': {
        required: true
      },
      'arrival_name': {
        required: true
      },
      'arrival_location': {
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
      'origin_name': 'No puede estar en blanco',
      'arrival_name': 'No puede estar en blanco',
      'origin_location': 'No puede estar en blanco',
      'arrival_location': 'No puede estar en blanco',
      'flight_origin_picker': 'No puede estar en blanco',
      'flight_arrival_picker': 'No puede estar en blanco'
    },
    debug: true,
    errorElement: "label",
    submitHandler: function (form) {
      let origin = $('#origin_location');
      let arrival = $('#arrival_location');
      if (arrival.val() == '' || origin.val() == ''){
        alert('Origen o Destino inválidos')
      }else{
        form.submit();
      }
    }
  });
}


function formatMoney(n, c, d, t) {
  var c = isNaN(c = Math.abs(c)) ? 2 : c,
    d = d == undefined ? "," : d,
    t = t == undefined ? "." : t,
    s = n < 0 ? "-" : "",
    i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
    j = (j = i.length) > 3 ? j % 3 : 0;

  return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};
