function test(id, supplier, item) {	
	if(document.getElementById(id).checked){ 		
 			
        	url = '/items_suppliers';
        	$.ajax({
        	    type: "POST",
        		url: url,
        		data: { supplier_id: supplier, item_id: item, is_item: 0},
        		success: function(res){
        			// $("#item_supplier").html("<%= escape_javascript(render(partial: 'items_suppliers/index', locals: { item: @item, show_actions: true })) %>");
        			
        		}
        	});   	 

	}else{
		
        alert('checkbox esta deseleccionado item');
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

 // data: { code: code, userid: userid } 
 