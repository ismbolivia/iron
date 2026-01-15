 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-brand-modal", function() { 
 	 		 $('#brand_name').focus();

			$('#brand_name').on('typeahead:change', function(event, data){
            $('#brand_name').val(data);
        		});
			 $('#brand_name').on('blur', function() {
			        data = $('#brand_name').val();
			        
			        url = '/validate_suggested_brand';
			        $.ajax({
			            url: url,
			            data: { brand_name: data },
			            success: function(res){
			            	
			                if (res["0"].valid == true || data ==""){
			                    // Marca no válida
			                    $('#brand_name').css('border-color', 'red');

			                }else{
			                    // Marca correcta
			                   $('#brand_name_id').val(res["0"].id.toString());
			                   $('#brand_name').css('border-color', '#ccc');
			                   $('#brand_country_id').focus();
			                }
			            }
			        });
			    });

			  $('#brand_country_id').click('blur', function() {
			        data = $('#brand_country_id').val();
			      if(data == ""){
			      	 $('#brand_country_id').css('border-color', 'red');
			      }else{
			      	$('#brand_country_id').css('border-color', '#ccc');
			      }
			        
			    });
 	 		
 	 	});
	

 	});