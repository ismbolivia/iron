$(document).ready(function(){
     $(document).on("shown.bs.modal", "#new-payment-modal-current", function() {
        $('#payment_account_id').on('click', function() {         
                // get_suggesstion_sale_for_number(); rode_id_label
                data = $('#payment_account_id').val();
                     $(this).trigger('typeahead:_propia', data)
                    url = '/validate_account_currency';
                    $.ajax({
                        url: url,
                        data: { account_id: data },
                        success: function(res){
                          if(res["0"].valid == true){
                          document.getElementById("rode_id_label").innerHTML = 'Monto('+res["0"].symbol+')';
                          document.getElementById("cambio_id_label").innerHTML = 'Cambio('+res["0"].symbol+')';
                          document.getElementById("payment_rode").disabled = false;
                          $('#payment_rode').focus();
                       
                          }else{
                             toastr.error('¡Algo salio mal reintente nuevamente por favor!')
                          }
                        }
                    });

         });
        document.getElementById("payment_rode").addEventListener("keyup", myFunction);        
         function myFunction() { 
          saldo = document.getElementById('label_saldo_id').innerHTML;
          data = $('#payment_rode').val();
          // alert(saldo);
            $('#payment_cambio').val('');
           $('#payment_cambio').val(data - saldo);
                    

         }

     });

    $(document).on("shown.bs.modal", "#new-payment-modal", function() {

    	var sales_suggested = new Bloodhound({
    	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace("number"),
    	  queryTokenizer: Bloodhound.tokenizers.whitespace,
          prefetch: window.location.origin + '/sales_suggestion',
    	  remote: {
            url: window.location.origin + '/sales_suggestion?query=%QUERY',
        	wildcard: '%QUERY'
    	  }
    	});
    	$('#payment_sale').typeahead({
    		  hint: true,
    		  highlight: true,
    		  minLength: 1
    	},
    	{
    	  displayKey: 'number',
    	  source: sales_suggested,
          templates: {
            suggestion: function (sale) {
                return '<p>' + sale.number + '</p>';
            }
          }
    	});

    	 $('#payment_sale').focus();
    	  //$('#payment_sale').typeahead('val', $('#payment_sale_numeber').val() );

    	 $('#payment_sale').on('typeahead:select', function(object, datum){
            $('#payment_sale_id').val(datum.id);

        });
    	  $('#payment_sale').on('typeahead:change', function(event, data){
            $('#payment_sale_id').val(data);
              $(this).trigger('typeahead:_propia', data)
        });

    	 $('#payment_sale').on('blur', function() {         
                get_suggesstion_sale_for_number();
                // alert('vamos bien');    	 	
    	 });
         
       $('#payment_sale').on('typeahead:_propia', function(evt, datum){ });

       function get_suggesstion_sale_for_number(){

        data = $('#payment_sale').val();
                     $(this).trigger('typeahead:_propia', data)
                    url = '/validate_suggested_sale';
                    $.ajax({
                        url: url,
                        data: { payment_sale: data },
                        success: function(res){

                            if (res["0"].valid == false || data ==""){
                                // Marca no válida
                                $('#payment_sale').css('border-color', 'red');

                            }else{
                                // Marca correcta
                               $('#payment_sale_id').val(res["0"].id.toString());
                               $('#payment_sale').css('border-color', '#ccc');
                                document.getElementById("client_id").innerHTML =  res["0"].ex;
                                document.getElementById("client_dir").innerHTML =  res["0"].dir;
                                document.getElementById("client_saldo").innerHTML =  res["0"].saldo;
                                document.getElementById("payment_sale").disabled = true;

                            }
                        }
                    });
       }
      
    });
});
