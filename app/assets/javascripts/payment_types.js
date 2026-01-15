function change_form(a) {
	var elemento = document.getElementById("div_hidden");
    elemento.className = "hidden";

    var deposits = document.getElementById("div-deposits");
    deposits.className = "";


 	var cod = $("#payment_payment_type_id option:selected").text();

 	// 
 	
    alert(cod);
  
 }
