// $(document).on('turbolinks:load', function(){
//
// });

function validateForm(id_form){
  $(id_form).validate({
   event: "blur",
   errorClass: "error-class",
   validClass: "valid-class",
   rules: {
     'transfer[title][es]': { required: true},
     'transfer[title][en]': { required: true},
     'transfer[title][pt]': { required: true},
     'transfer[quantity_kids]': { required: true},
     'transfer[quantity_adults]': { required: true},
     'transfer[price][cop]': { required: true},
     'transfer[price][usd]': { required: true},
     'transfer[time]': { required: true},
     'transfer[date]': { required: true},
     },
   messages: {
     'transfer[title][es]': 'No puede estar en blanco',
     'transfer[title][en]': 'No puede estar en blanco',
     'transfer[title][pt]': 'No puede estar en blanco',
     'transfer[quantity_kids]': 'No puede estar en blanco',
     'transfer[quantity_adults]': 'No puede estar en blanco',
     'transfer[price][cop]': 'No puede estar en blanco',
     'transfer[price][usd]': 'No puede estar en blanco',
     'transfer[time]': 'No puede estar en blanco',
     'transfer[date]': 'No puede estar en blanco',
     },
   debug: true,errorElement: "label",
   submitHandler: function(form){
     // var data = $('#destinations_transfers').val();
     // $('form').append(`<input type="hidden" name="transfer[destination_ids]" value="${data}" /> `);
     form.submit();

   }
  });
}
