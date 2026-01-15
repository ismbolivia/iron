

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
			 	$("#price_utility").val(set_round($('#price_utility').val(), 2));
			    
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
 	 		ppp =  parseFloat($('#price_price_purchase').val());
 	 		mu = parseFloat((($('#price_price_purchase').val()*$('#price_utility').val())/100));
 	 		return parseFloat(mu+ppp).toFixed(4);
 	 		}
 	 	function calculate_utility(){
 	 			price_purchase =  parseFloat($('#price_price_purchase').val());
 	 			price_sale =  parseFloat($('#price_price_sale').val());
 	 			utility = (price_sale - price_purchase)/price_purchase
 	 			return parseFloat(utility*100).toFixed(2);
 	 	}
 	 	function set_round(data_n, nd){
 	 		pps =  parseFloat(data_n).toFixed(nd);
 	 		return pps;
 	 	}
	
 	}); 	 
});