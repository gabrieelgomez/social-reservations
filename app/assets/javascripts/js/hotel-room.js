var lodgment_id_radio = null;
var lodgments_json = JSON.stringify(lodgments_ruby);
var room_json = { single: 0, doubles: 0, triples: 0, quadruples: 0, quintuples: 0, sextuples: 0, children: 0 }
var budget = { single: 0, doubles: 0, triples: 0, quadruples: 0, quintuples: 0, sextuples: 0, children: 0 }

// Funcion para clickear o no el cuadro de 3/4/5 Estrellas
$('.js-hotelRoom').not('.disabled-content').on('click', function () {
  debugger;
  lodgment_id_radio = $(this).val();
  // Passing JSON methods
  var filtered_json = find_in_object(JSON.parse(lodgments_json), {
    lodgment_id: lodgment_id_radio
  });
  if ((filtered_json[6][`price_${coin}`] == 0) && (kids != 0)) {
    swal({
      type: 'error',
      title: '¡Disculpe!',
      text: 'El Alojamiento seleccionado, no está disponible para niños'
    })
  } else {

    if ($(this).is(':checked')) {
      $.each(filtered_json, function (i, item) {
        let json_parse = {
          lodgment_id: lodgment_id_radio,
          type: item.type_room
        }
        $(`input[name='room_${item.type_room}']`).val(JSON.stringify(json_parse));
        if (item[`price_${coin}`] == 0) {
          $(`input[name='square_multidestination[][${item.type_room}]']`).attr('disabled', true);
          $('#room_' + item.type_room).text('No Disponible');
          room_json[item.type_room] = 0;
          $('#room_' + item.type_room).parent().addClass('disabled-content');
        } else {
          $(`input[name='square_multidestination[][${item.type_room}]']`).attr('disabled', false);
          $('#room_' + item.type_room).text('$' + formatMoney(item[`price_${coin}`]));
          room_json[item.type_room] = item[`price_${coin}`];
          $('#room_' + item.type_room).parent().removeClass('disabled-content');

        } // end condicion si la habitacion esta disponible

        if (item.type_room == 'children') {
          price_kids = item[`price_${coin}`];
          total_kids = kids * price_kids;
          budget['children'] = total_kids;
          // Format square text (element, price_room, quantity, total_room_or_budget, text)
          formatTextSquare($('#price_children'), price_kids, kids, total_kids, 'Cant. Niños');
        }


      }) // end for each json

      // Calcular el price total del hotel seleccionado
      total_budget();

      // End JSON Methods
      $('.js-hotelRoom').removeClass('js-hotel-active').prop('disabled', 'disabled');
      $('.js-hotel').addClass('disabled-content').removeClass('bg-active');
      $(this).closest($('.js-hotel')).removeClass('disabled-content');
      $(this).removeAttr('disabled')
      $(this).closest('.box_hotel').addClass('bg-active');
      $('.room').css('visibility', 'visible');
      $('.box_type_rooms').removeClass('room-hidden');
      $('.box_type_rooms').removeClass('room-disabled');
      $('.box_type_rooms').addClass('room-show');
      setTimeout(function () {
        $('.box_type_rooms').addClass('room-activated');
      }, 20);

    } else {
      // Remover estilos del room seleccionado
      removeClassTypeRoom($('.js-typeRoom'));
      // Inicializar todos los valores en cero || null || ''
      restoreValuesZero();
      // Calcular el price total del hotel seleccionado
      total_budget();

      $(this).closest($('.btn-room')).removeClass('disabled-content');
      $('.js-hotel').removeClass('disabled-content')
      $('.room').css('visibility', 'hidden');
      $(this).closest('.box_hotel').removeClass('bg-active');
      $('.box_type_rooms').removeClass('room-show');
      $('.box_type_rooms').removeClass('room-activated');
      $('.box_type_rooms').addClass('room-hidden');
      setTimeout(function () {
        $('.box_type_rooms').addClass('room-disabled');
      }, 20);

    } // END --- Si no está checkeado

  }

}); // END --- Seleccion de un Alojamiento u hotel


// Funcion de habilitar o no el tipo de habitacion room
$('.js-typeRoom').on('click', function () {
  lodgment_id_radio = $(this).val();
  json_parse = JSON.parse(lodgment_id_radio);
  that = $(this);
  // Passing JSON methods
  var filtered_json = find_in_object(JSON.parse(lodgments_json), {
    lodgment_id: json_parse['lodgment_id']
  });
  $.each(filtered_json, function (i, item) {
    if (item[`price_${coin}`] > 0 && item.type_room == json_parse['type']) {
      if (that.is(':checked')) {
        $('.js-square').hide();
        $(`input[name='square_multidestination[][${this.type_room}]']`).val(1);
        budget[this.type_room] = room_json[this.type_room];
        // Format square text (element, price_room, quantity, total_room_or_budget, text)
        formatTextSquare($(`#price_${this.type_room}`), room_json[this.type_room], 1, budget[this.type_room], `Hab. ${this.type_room}`);
        total_budget();
        that.addClass('js-room-active');
        that.closest('label').addClass('bg-active');
        that.closest('label').parent().find('.quantity-type-room').removeClass('quantity-disabled').addClass('quantity-active');
      } else {
        restoreValuesRoomZero(this.type_room);
        removeClassTypeRoom(that);
      }
    }

  }) // end for each json
  // End JSON Methods
});
// END --- Funcion de habilitar o no el tipo de habitacion room




// --------------------- FUNCTIONS ----------------------------------

// Method to calculate the total price
function total_budget() {
  var total_budget = 0;
  $.each(budget, function () {
    total_budget += this;
  });
  $('#price_total').text(`${currency} $ ${formatMoney(total_budget)}`);
}

//
function restoreValuesRoomZero(type_room) {
  budget[type_room] = 0;
  $(`#select_${type_room}`).val('1');
  $(`input[name='square_multidestination[][${type_room}]']`).val('');
  formatTextSquare($(`#price_${type_room}`), 0, 0, 0, `Hab. ${type_room}`);
  total_budget();
}

// Method to format everything to zero
function restoreValuesZero() {
  let array = ['single', 'doubles', 'triples', 'quadruples', 'quintuples', 'sextuples', 'children'];
  let inputs = $('.js-hotelRoom');
  let lodgment_id_radio = null;
  // Format square text (element, price_room, quantity, total_room_or_budget, text)
  for (let i = 0; i < array.length; i++) {
    budget[array[i]] = 0;
    $(`input[name='square_multidestination[][${array[i]}]']`).val('');
    $(`#select_${this.type_room}`).val('');
    if (array[i] != 'children') {
      formatTextSquare($(`#price_${array[i]}`), 0, 0, 0, `Hab. ${array[i]}`);
    } else if (array[i] == 'children') {
      // Format square text (element, price_room, quantity, total_room_or_budget, text)
      formatTextSquare($('#price_children'), 0, kids, 0, 'Cant. Niños');
    }
  }
  for (var i = 0; i < inputs.length; i++) {
    inputs[i].disabled = false;
  }
}

// Method to remove classes of room type
function removeClassTypeRoom(element) {
  element.closest('label').removeClass('bg-active');
  element.removeClass('js-room-active');
  element.closest('label').parent().find('.quantity-type-room').removeClass('quantity-active').addClass('quantity-disabled');
}

// Method to format summary text
function formatTextSquare(element, price, quantity, total, text) {
  element.text(`${text} (${quantity}) x $ ${formatMoney(price)} = $ ${formatMoney(total)}`);
}

// Method to change the price by the select
$('select').change(function (e) {
  let id = e.target.id.split('select_')[1];
  let value = parseInt(e.target.selectedOptions[0].value);
  let price_room = room_json[id];
  let total_price_room = price_room * value;
  $(`input[name='square_multidestination[][${id}]']`).val(value);
  $(`#price_${id}`).val(value);
  budget[id] = (total_price_room);// + budget[id];
  total_budget();
  // Format square text (element, price_room, quantity, total_room_or_budget, text)
  formatTextSquare($(`#price_${id}`), price_room, value, total_price_room, `Hab. ${id}`);
});

// Method to iterate the JSON, filter by parameter
function find_in_object(my_object, my_criteria) {
  return my_object.filter(function (obj) {
    return Object.keys(my_criteria).every(function (c) {
      return obj[c] == my_criteria[c];
    });
  });
}
