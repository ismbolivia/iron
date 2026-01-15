

function set_list_client(id, client, price) {	
	if(document.getElementById(id).checked){ 		 			
        	url = '/client_price_lists';

        	$.ajax({
        	    type: "POST",
        		url: url,
        		data: { client_id: client, price_list_id: price},
        		success: function(res){
                    toastr.success('¡Lista de precio asignado con exito!');

                    // alert("exito...!");
        			// $("#item_supplier").html("<%= escape_javascript(render(partial: 'items_suppliers/index', locals: { item: @item, show_actions: true })) %>");
        			
        		}
        	});   	 
	}else{		
        alert('checkbox esta deseleccionado lista de precios');
	}    
}

function add_item(id, item, supplier){
	if(document.getElementById(id).checked){
  		url = '/items_suppliers';
        	$.ajax({
        	    type: "POST",
        		url: url,
        		data: { supplier_id: supplier, item_id: item, is_item: 1 },
        		success: function(res){
        			
        			
        		}
        	});
	}else{
              
		 alert('checkbox esta deseleccionado proveedor');
	}    
}


 