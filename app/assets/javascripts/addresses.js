 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-address-modal", function() { 
 	 		 $('#address_country_id').on('blur', function() {
			 	data =  $('#address_country_id').val();
			 	 url = '/country_departamentos';
			 	 $.ajax({
			            url: url,
			            data: { country_id: data },
			            success: function(res){
			                if (res["0"].valid == false){
			                	$("#address_departamento_id").html(" ");
			                	$("#btn-depa").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/departamentos/new?country_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 }else{
			                 	$("#address_departamento_id").html("");
			                 	$("#btn-depa").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/departamentos/new?country_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 	for (var k in res["0"].dep) {
			        			$("#address_departamento_id").append(" <option value= '"+res["0"].dep[k].id+"'>"+res["0"].dep[k].name+"</option> ");	
								}
			                 }
			                 $("#panel_departamento").removeClass("hidden"); 
			                 $("#address_province_id").html("");
			                 $("#btn-province").html(" ");
			                 $("#panel_province").addClass("hidden"); 

			                 $("#address_zona_id").html("");
			                 $("#btn-zona").html(" ");
			                 $("#panel_zona").addClass("hidden"); 

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
