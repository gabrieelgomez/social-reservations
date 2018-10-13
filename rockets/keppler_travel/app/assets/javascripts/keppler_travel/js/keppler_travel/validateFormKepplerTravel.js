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


function validateCircuit(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'circuit[price]': { required: true},
     'circuit[quantity_days]': { required: true, digits: true, number: true},
     'circuit[destination_ids]': { required: true}
     },
   messages: {
     'circuit[destination_ids]': 'No puede estar en blanco'
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){

     var circuit_files = $('#circuit_files').val();
     var destinations = $('#destinations_circuits').val();

     $('form').append(`<input type="hidden" name="circuit[destination_ids]" value=${destinations} /> `);

     if (circuit_files  == ''){
       alert('Agregue mínimo una imagen');
     }
     else{
       form.submit();
     }

   }
  });
}


function validateMultidestination(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'multidestination[price]': { required: true},
     'multidestination[quantity_days]': { required: true, digits: true, number: true},
     'multidestination[destination_ids]': { required: true}
     },
   messages: {
     'multidestination[destination_ids]': 'No puede estar en blanco'
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){

     var multidestination_files = $('#multidestination_files').val();
     var destinations = $('#destinations_multidestinations').val();

     $('form').append(`<input type="hidden" name="multidestination[destination_ids]" value=${destinations} /> `);

     if (multidestination_files  == ''){
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


function validateLodgment(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'lodgment[title]': { required: true}
     },
   messages: {
     'lodgment[title]': 'No puede estar en blanco'
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){

     var destinations = $('#destinations_lodgments').val();
     var rankings = $('#rankings_lodgments').val();
     var rooms = $('#lodgments_rooms').val();

     $('form').append(`<input type="hidden" name="lodgment[room_ids]" value=${rooms} /> `);


     if (destinations == null || rankings == null){
       alert('Agregue mínimo un destino');
     }
     else{
       form.submit();
     }

   }
  });
}
