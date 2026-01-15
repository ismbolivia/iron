function loadDataPrice(id) {
  price_list_id = document.getElementById("price_price_list_id").value;
  url = '/price_item_add';
  $.ajax({
           url: url,
           data: { price_list_id: price_list_id,
                  item_id: id},
           success: function(res){
               if (res["0"].valid == false){
                document.getElementById("price_price_sale").value="";
                  document.getElementById("price_price_purchase").value=res["0"].price_purchase;
                document.getElementById("price_utility").value="";
                 document.getElementById("price_utility").focus();
              //  alert(res["0"].msm);
                Swal({
                    position: 'center',
                    type: 'error',
                    title: res["0"].msm,
                    showConfirmButton: false,
                    timer: 1500
                  });

               }else{
                  document.getElementById("price_price_sale").value=res["0"].price_sale;
                    document.getElementById("price_price_purchase").value=res["0"].price_purchase;

                  document.getElementById("price_price_sale").focus();
                  Swal({
                      position: 'center',
                      type: 'success',
                      title: res["0"].msm,
                      showConfirmButton: false,
                      timer: 1500
                    });

               }

           }
       });

}
