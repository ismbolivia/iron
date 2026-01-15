 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-country-modal", function() { 
 	 		$('#country_name').focus();
 	 		$('#country_name').on('blur', function() {
			 	data = $('#country_name').val();
			       
			      
 				});
 	 	});
	

 	});