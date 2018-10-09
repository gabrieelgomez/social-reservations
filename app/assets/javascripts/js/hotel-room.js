var lodgment_id_radio = null;
$('.js-hotelRoom').not('.disabled-content').on('click', function () {
  if ($(this).is(':checked')) {
    lodgment_id_radio = $(this).val();
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
  if ($(this).is(':checked')) {
    $(this).addClass('js-room-active');
    $(this).closest('label').addClass('bg-active');
    $(this).closest('label').parent().find('.quantity-type-room').removeClass('quantity-disabled').addClass('quantity-active');
  } else {
    $(this).closest('label').removeClass('bg-active');
    $(this).removeClass('js-room-active');
    $(this).closest('label').parent().find('.quantity-type-room').removeClass('quantity-active').addClass('quantity-disabled');
  }
});
