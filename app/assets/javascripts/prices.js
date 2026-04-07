

 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-price-modal", function() { 
 	 		 //$('#price_price_list_id').on('blur', function() {
			 	//data = $('#price_price_list_id').val();
        		//url = '/prices_get_price_list';
		        	//$.ajax({
		        	//	url: url,
		        	//	data: { price_list_id: data },
		        	//	success: function(res){
		        	//		  $("#price_utility").val(res["0"].utility);
		        	//		  $("#price_price_sale").val(get_prise_sale);
		        	//	}
		        	//});       
			    
 				//});

 	 		 $('#price_utility').on('blur', function() {
			 	$("#price_price_sale").val(get_prise_sale());
 			 	$("#price_utility").val(set_round($('#price_utility').val(), 4));
			    
 				});
 	 		 $('#price_opex_margin').on('blur', function() {
			 	$("#price_price_sale").val(get_prise_sale());
 			 	$("#price_opex_margin").val(set_round($('#price_opex_margin').val(), 4));
 				});
 	 		 $('#price_price_purchase').on('blur', function() {
			 	$("#price_price_sale").val(get_prise_sale());
			 	$("#price_price_purchase").val(set_round($('#price_price_purchase').val(), 4));
			    
 				});
 	 		 
 	 		  $('#price_price_sale').on('blur', function() {
			 	$("#price_utility").val(calculate_utility());
			 	$("#price_price_sale").val(set_round($('#price_price_sale').val(), 4));

			    
 				});



 	 	function get_prise_sale() {
            let ppp =  parseFloat($('#price_price_purchase').val()) || 0;
            let opex = parseFloat($('#price_opex_margin').val()) || 0;
            let costo_operativo = ppp;
            
            if (opex > 0 && opex <= 100) {
              costo_operativo = ppp * (1 + (opex / 100));
            } else if (opex > 100) {
              costo_operativo = ppp + opex;
            }

            let utility = parseFloat($('#price_utility').val()) || 0;
            let mu = parseFloat((costo_operativo * utility) / 100);
            return parseFloat(costo_operativo + mu).toFixed(4);
 	 		}
 	 	function calculate_utility(){
            let price_purchase =  parseFloat($('#price_price_purchase').val()) || 0;
            let opex = parseFloat($('#price_opex_margin').val()) || 0;
            let costo_operativo = price_purchase;
            
            if (opex > 0 && opex <= 100) {
              costo_operativo = price_purchase * (1 + (opex / 100));
            } else if (opex > 100) {
              costo_operativo = price_purchase + opex;
            }

            let price_sale =  parseFloat($('#price_price_sale').val()) || 0;
            let utility = 0;
            if (costo_operativo > 0) {
               utility = (price_sale - costo_operativo) / costo_operativo;
            }
            return parseFloat(utility*100).toFixed(4);
 	 	}
 	 	function set_round(data_n, nd){
 	 		pps =  parseFloat(data_n).toFixed(nd);
 	 		return pps;
 	 	}
	
 	}); 	 
});