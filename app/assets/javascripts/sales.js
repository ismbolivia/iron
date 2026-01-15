$(document).ready(function(){
    $('#sale_client_id').on('blur', function() {
    	data = $('#sale_client_id').val();
        	url = '/clients_get_client';
        	$.ajax({
        		url: url,
        		data: { client_id: data },
        		success: function(res){
        			document.getElementById("discount_client_sales").innerHTML = res["0"].discount+'%';
        			document.getElementById("limit_credit_client").innerHTML = '$'+ res["0"].limit_credit;
        		  document.getElementById("address_client_sale").innerHTML =  res["0"].address;
        		    document.getElementById("phones_clients_sales").innerHTML =  res["0"].telf;
                    document.getElementById("line_credit_client_available").innerHTML =  res["0"].line_credit_available;
                    $('#price_list_id_').val(res["0"].price_list_id);
                    // document.getElementById("price_list_id_").innerHTML =  res["0"].telf;

                    // price_list_id_
        		}
        	});
    	 });
    $('#sale_discount').on('blur', function() {

      document.getElementById("id_devo").innerHTML = $('#sale_discount').val()+"%";


      var subtotal = $('#id_sub_total').text();
      var disc = $('#sale_discount').val();
    
      var disc_amount = subtotal*disc;
      var total =  (disc_amount/100).toFixed(2);  
      document.getElementById("id_amount_discount").innerHTML = total;
      document.getElementById("id_input_currency").innerHTML = (subtotal - total).toFixed(2); 
      document.getElementById("salida").innerHTML = " "           

       });
});

  $(document).ready(function() {
    //When checkboxes/radios checked/unchecked, toggle background color
    $('.form-group').on('click','input[type=radio]',function() {
        $(this).closest('.form-group').find('.radio-inline, .radio').removeClass('checked');
        $(this).closest('.radio-inline, .radio').addClass('checked');
    });
    $('.form-group').on('click','input[type=checkbox]',function() {
        $(this).closest('.checkbox-inline, .checkbox').toggleClass('checked');
    });

    //Show additional info text box when relevant checkbox checked
    $('.additional-info-wrap input[type=checkbox]').click(function() {
        
        if($(this).is(':checked')) {
            $(this).closest('.additional-info-wrap').find('.additional-info').removeClass('hide').find('input,select').removeAttr('disabled');
            $('#id_credit').text('A Credito');
            current_fecha();
             
        }
        else {
            $(this).closest('.additional-info-wrap').find('.additional-info').addClass('hide').find('input,select').val('').attr('disabled','disabled');
            $('#id_credit').text('A Contado');
            current_fecha();             
        }
    });

    //Show additional info text box when relevant radio checked
    $('input[type=radio]').click(function() {
        $(this).closest('.form-group').find('.additional-info-wrap .additional-info').addClass('hide').find('input,select').val('').attr('disabled','disabled');
        if($(this).closest('.additional-info-wrap').length > 0) {
          $(this).closest('.additional-info-wrap').find('.additional-info').removeClass('hide').find('input,select').removeAttr('disabled');
        }
    });
});

function listo(id_sale) {
   alert(id_sale);
}
function current_fecha(){
      var fecha = new Date(); //Fecha actual
      var mes = fecha.getMonth()+1; //obteniendo mes
      var dia = fecha.getDate(); //obteniendo dia
      var ano = fecha.getFullYear(); //obteniendo año
  if(dia<10)
    dia='0'+dia; //agrega cero si el menor de 10
  if(mes<10)
    mes='0'+mes //agrega cero si el menor de 10
    document.getElementById('sale_credit_expiration').value=ano+"-"+mes+"-"+dia;
}


function penalty(id, valor){
  // alert(id);
  data = id;
    url = '/sale_set_penalty';
      $.ajax({
        url: url,
        data: { sale_id: data,
                valor: valor },
        success: function(res){
          if (res["0"].valid) {            
            location.reload();
            toastr.success(res["0"].notice);

          }else{
             toastr.error(res["0"].notice);
          }
         }
     });

}
function canceled(id, valor){
    data = id;
    url = '/sale_set_canceled';
      $.ajax({
        url: url,
        data: { sale_id: data,
                valor: valor },
        success: function(res){
          if (res["0"].valid) {
             location.reload();
             toastr.success(res["0"].notice);
           }else{
            toastr.error(res["0"].notice);
           }
           
         }
     });

}

function edit_discount_item(data, id_col){

  document.getElementById(id_col).innerHTML = "<input type='text' id = 'id_input_discount'  onblur = 'tosave("+id_col+");'  class='form-control' value= "+data +"> ";
  document.getElementById(id_col).focus;
}

function tosave(id_sale_detail){
  var input_d = document.getElementById("id_input_discount").value;
  document.getElementById(id_sale_detail).innerHTML = "<strong>"+ input_d+'%'+"</strong>";  


    url = '/change_discount_sale_detail';
      $.ajax({
        url: url,
        data: { sale_detail_id: id_sale_detail,
                data: input_d },
        success: function(res){
          document.getElementById("label_id_subtotal_"+res[0].id).innerHTML=res[0].subtotal
          document.getElementById("label_id_price_sale_"+res[0].id).innerHTML=res[0].ps
           document.getElementById("id_sub_total").innerHTML=res[0].stotal_sale
           document.getElementById("id_input_currency").innerHTML=res[0].stotal


           
           
         }
     });




}