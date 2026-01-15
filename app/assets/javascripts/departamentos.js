 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-address-modal", function() { 
 	 		 $('#address_departamento_id').on('blur', function() {
			 	data =  $('#address_departamento_id').val();
			 	 url = '/departamento_provincias';
			 	 $.ajax({
			            url: url,
			            data: { departamento_id: data },
			            success: function(res){
			                if (res["0"].valid == false){
			                	$("#address_province_id").html(" ");
			                	$("#btn-province").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/provinces/new?departamento_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 }else{
			                 	$("#address_province_id").html("");
			                 	$("#btn-province").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/provinces/new?departamento_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 	for (var k in res["0"].pro) {
			        			$("#address_province_id").append(" <option value= '"+res["0"].pro[k].id+"'>"+res["0"].pro[k].name+"</option> ");	
								}
			                 }
			                 $("#panel_province").removeClass("hidden"); 
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
