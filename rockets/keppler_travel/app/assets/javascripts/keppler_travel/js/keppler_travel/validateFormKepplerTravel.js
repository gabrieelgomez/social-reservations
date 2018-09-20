// $(document).on('turbolinks:load', function(){
//
// });

function validateForm(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'vehicle[title][es]': { required: true},
     'vehicle[title][en]': { required: true},
     'vehicle[title][pt]': { required: true},
     'vehicle[quantity_kids]': { required: true},
     'vehicle[quantity_adults]': { required: true},
     'vehicle[price][cop]': { required: true},
     'vehicle[price][usd]': { required: true},
     'vehicle[time]': { required: true},
     'vehicle[date]': { required: true},
     },
   messages: {
     'vehicle[title][es]': 'No puede estar en blanco',
     'vehicle[title][en]': 'No puede estar en blanco',
     'vehicle[title][pt]': 'No puede estar en blanco',
     'vehicle[quantity_kids]': 'No puede estar en blanco',
     'vehicle[quantity_adults]': 'No puede estar en blanco',
     'vehicle[price][cop]': 'No puede estar en blanco',
     'vehicle[price][usd]': 'No puede estar en blanco',
     'vehicle[time]': 'No puede estar en blanco',
     'vehicle[date]': 'No puede estar en blanco',
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){
     form.submit();
   }
  });
}


function validateTour(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'tour[price]': { required: true},
     'tour[destination_ids]': { required: true},
     },
   messages: {
     'tour[price]': 'No puede estar en blanco',
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){

     var tour_files = $('#tour_files').val();
     var destinations = $('#destinations_tours').val();

     $('form').append(`<input type="hidden" name="tour[destination_ids]" value=${destinations} /> `);

     if (tour_files  == ''){
       alert('Agregue mínimo una imagen');
     }
     else if (destinations == null){
       alert('Agregue mínimo un destino');
     }
     else{
       form.submit();
     }

   }
  });
}
