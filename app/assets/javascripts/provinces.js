 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-address-modal", function() { 
 	 		 $('#address_province_id').on('blur', function() {
			 	data =  $('#address_province_id').val();
			 	 url = '/provincia_zonas';
			 	 $.ajax({
			            url: url,
			            data: { province_id: data },
			            success: function(res){
			                if (res["0"].valid == false){
			                	$("#address_zona_id").html(" ");
			                	$("#btn-zona").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/zonas/new?province_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 }else{
			                 	$("#address_zona_id").html("");
			                 	$("#btn-zona").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/zonas/new?province_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 	for (var k in res["0"].zon) {
			        			$("#address_zona_id").append(" <option value= '"+res["0"].zon[k].id+"'>"+res["0"].zon[k].name+"</option> ");	
								}
			                 }
			                 $("#panel_zona").removeClass("hidden"); 
			                 
			                 $("#address_avenida_id").html("");
			                 $("#btn-avenida").html(" ");
			                 $("#panel_avenida").addClass("hidden"); 

			                 $("#address_calle_id").val(" ");
			                 $("#panel_calles").addClass("hidden"); 
			            }
			        });
 				});
 	 	});
 	});
