var lodgment_id_radio = null;
$('.js-hotelRoom').not('.disabled-content').on('click', function () {
  if ($(this).is(':checked')) {
    lodgment_id_radio = $(this).val();

    // Passing JSON methods
      var filtered_json = find_in_object(JSON.parse(lodgments_json), {lodgment_id: lodgment_id_radio});
      $.each(filtered_json, function(i, item) {
        let json_parse = {lodgment_id: lodgment_id_radio, type:item.type_room}
        $(`input[name='room_${item.type_room}']`).val(JSON.stringify(json_parse));
        if (item.price_cop == 0){
          $(`input[name='square_circuit[][${item.type_room}]']`).attr('disabled', true);
          $('#room_' + item.type_room).text('No Disponible');
        }
        else{
          $(`input[name='square_circuit[][${item.type_room}]']`).attr('disabled', false);
          $('#room_' + item.type_room).text('$' + item.price_cop);
        } // end condicion si la habitacion esta disponible
      }) // end for each json
    // End JSON Methods

    $('.js-hotelRoom').removeClass('js-hotel-active').prop('disabled', 'disabled');
    $('.js-hotel').addClass('disabled-content').removeClass('bg-active');
    $(this).closest($('.js-hotel')).removeClass('disabled-content');
    $(this).removeAttr('disabled')
    $(this).closest('label').addClass('bg-active');
    $('.box_type_rooms').removeClass('room-hidden');
    $('.box_type_rooms').removeClass('room-disabled');
    $('.box_type_rooms').addClass('room-show');
    setTimeout(function () {
      $('.box_type_rooms').addClass('room-activated');
    }, 20);


  } else {

    $('.js-typeRoom').closest('label').removeClass('bg-active');
    $('.js-typeRoom').removeClass('js-room-active');
    $('.js-typeRoom').closest('label').parent().find('.quantity-type-room').removeClass('quantity-active').addClass('quantity-disabled');

    let array = ['single', 'double', 'triples', 'quadruples', 'quintuples', 'sextuples', 'children']
    for (let i = 0; i < array.length; i++) {
      $(`input[name='square_circuit[][${array[i]}]']`).val('');
    }

    lodgment_id_radio = null;
    var inputs = $('.js-hotelRoom');
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].disabled = false;
    }
    $(this).closest($('.btn-room')).removeClass('disabled-content');
    $('.js-hotel').removeClass('disabled-content')
    $(this).closest('label').removeClass('bg-active');
    $('.box_type_rooms').removeClass('room-show');
    $('.box_type_rooms').removeClass('room-activated');
    $('.box_type_rooms').addClass('room-hidden');
    setTimeout(function () {
      $('.box_type_rooms').addClass('room-disabled');
    }, 20);
  }
});

$('.js-typeRoom').on('click', function () {

  lodgment_id_radio = $(this).val();
  json_parse = JSON.parse(lodgment_id_radio);
  that = $(this);
  // Passing JSON methods
    var filtered_json = find_in_object(JSON.parse(lodgments_json), {lodgment_id: json_parse['lodgment_id']});
    $.each(filtered_json, function(i, item) {
      if (item.price_cop > 0 && item.type_room == json_parse['type']) {
        if (that.is(':checked')) {
          that.addClass('js-room-active');
          that.closest('label').addClass('bg-active');
          that.closest('label').parent().find('.quantity-type-room').removeClass('quantity-disabled').addClass('quantity-active');
        } else {
          that.closest('label').removeClass('bg-active');
          that.removeClass('js-room-active');
          that.closest('label').parent().find('.quantity-type-room').removeClass('quantity-active').addClass('quantity-disabled');
        }
      }

    }) // end for each json
  // End JSON Methods

});

function find_in_object(my_object, my_criteria){

  return my_object.filter(function(obj) {
    return Object.keys(my_criteria).every(function(c) {
      return obj[c] == my_criteria[c];
    });
  });

}
