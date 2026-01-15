 $(document).ready(function(){ 
 	 $(document).on("shown.bs.modal", "#new-address-modal", function() { 
 	 		 $('#address_zona_id').on('blur', function() {
			 	data =  $('#address_zona_id').val();
			 	 url = '/zona_avenidas';
			 	 $.ajax({
			            url: url,
			            data: { zona_id: data },
			            success: function(res){
			                if (res["0"].valid == false){
			                	$("#address_avenida_id").html(" ");
			                	$("#btn-avenida").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/avenidas/new?zona_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 }else{
			                 	$("#address_avenida_id").html("");
			                 	$("#btn-avenida").html("<a class='btn waves-effect waves-light btn-info' data-remote='true' data-method='get' href='/avenidas/new?zona_id="+res['0'].id+"'><span class='fas fa-plus' aria-hidden='true'> </span></a> ");
			                 	for (var k in res["0"].ave) {
			        			$("#address_avenida_id").append(" <option value= '"+res["0"].ave[k].id+"'>"+res["0"].ave[k].name+"</option> ");	
								}
			                 }
			                 $("#panel_avenida").removeClass("hidden"); 
			                  $("#address_calle_id").val(" ");
			                 $("#panel_calles").addClass("hidden"); 
			            
			            }
			        });
 				});
 	 	});
 	});
