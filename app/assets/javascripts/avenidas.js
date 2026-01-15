 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-address-modal", function() { 
 	 		 $('#address_avenida_id').on('blur', function() {
			 		 $('#panel_calles').removeClass("hidden");
 				});
 	 	});
 	});
