 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-purchase-order-payment-modal", function() { 
 	 		 $('#box_purchase_order_payment_purchase_order_id').on('blur', function() {			 		

			 		  data = $('#box_purchase_order_payment_purchase_order_id').val();
			        
			        url = '/getpurchase_order';
			        $.ajax({
			            url: url,
			            data: { purchase_order_id: data },
			            success: function(res){
			            	
			                if (res["0"].valid == true){
			                 
			                    $('#box_purchase_order_payment_amount').val(res["0"].qty.toString());

			                }else{
			                    // Marca correcta
			                   // $('#brand_name_id').val(res["0"].id.toString());
			                   // $('#brand_name').css('border-color', '#ccc');
			                   // $('#brand_country_id').focus();
			                }
			            }
			        });


 				});
 	 	});
 	});
