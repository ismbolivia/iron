
$(document).ready(function () {

  $(document).on("shown.bs.modal", "#new-detail-modal", function () {

    var items_suggested = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace("description"),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: window.location.origin + '/items_suggestion',
      remote: {
        url: window.location.origin + '/items_suggestion?query=%QUERY',
        wildcard: '%QUERY'
      }
    });

    $('#sale_details_item').typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
      {
        displayKey: 'name',
        source: items_suggested,
        templates: {
          suggestion: function (item) {
            return '<p>' + item.code + ' ' + item.description + '</p>';
          }
        },
        limit: 8
      });

    $('#sale_details_item').focus();

    $('#sale_details_item').typeahead('val', $('#sale_details_item_description').val());

    $('#sale_details_item').on('typeahead:select', function (object, datum) {
      $('#sale_details_item').val(datum.id);
      $('#qty_presentation_id').focus();
      subtotal();
    });


    $('#sale_details_item').on('typeahead:change', function (event, data) {
      $('#sale_details_item').val(data);
    });

    $('#sale_details_item').on('blur', function () {
      data = $('#sale_details_item').val();
      client_id = $('#sale_client_id').val();
      url = '/validate_suggested_item';
      $('#sale_details_price_id').html('');
      $.ajax({
        url: url,
        data: { item_description: data, current_client_id: client_id },
        success: function (res) {
          if (res["0"].valid == false) {
            // Item no válido
            $('#sale_details_item').css('border-color', 'red');
            $('#sale_details_item_id').val('');
            document.getElementById('stock_current').innerHTML = '';
            $('#sale_details_item_id').val('');
            $('#sale_details_price').val('');
            $('#sale_details_discount').val('');
            $('#sale_details_price_id').val('');
            $('#sale_details_subtotal').val('');
            document.getElementById('stock_current').innerHTML = '';
            if (data == '') {
            } else {
              document.getElementById("sel_presentation_id").value = '';
              document.getElementById("qty_presentation_id").value = '1';
              alert(res["0"].notice);
            }
          } else {
            // Item correcto
            var lotData = res["0"];
            window.currentAvailableLots = lotData.available_lots;
            
            $('#sale_details_item_id').val(lotData.id.toString());
            $('#sale_details_price').val(lotData.price.toString());
            $('#sale_details_discount').val(lotData.discount.toString());
            $('#sale_details_price_id').val(lotData.my_prices);

            $('#sale_details_price_sale').val(parseFloat(lotData.price_sale_unit).toFixed(4))
            document.getElementById('unit_item_id').innerHTML = lotData.my_unidad;
            
            // Stock del Primer Lote
            var firstLot = window.currentAvailableLots[0];
            document.getElementById('stock_current').innerHTML = firstLot ? firstLot.qty_available : '0';

            var prices = JSON.parse(lotData.my_prices);
            var presentations = lotData.presentations;
            var activePriceListId = $('#price_list_id_').val();

            $("#sale_details_price_id").empty();
            for (var i = 0; i < prices.length; i++) {
              var selected = (parseInt(activePriceListId) == parseInt(prices[i].price_list_id)) ? 'selected' : '';
              $("#sale_details_price_id").append('<option ' + selected + ' value=' + prices[i].id + ' >' + prices[i].name + '</option>');
            }

            var $selPres = $('#sel_presentation_id');
            $selPres.empty();
            if (firstLot && firstLot.presentation) {
              $selPres.append('<option value="' + firstLot.presentation.factor + '" selected>' + firstLot.presentation.name + ' (Sugerido Lote)</option>');
            }
            presentations.forEach(function(p) {
              if (!firstLot || !firstLot.presentation || p.id !== firstLot.presentation.id) {
                $selPres.append('<option value=' + p.qty + '>' + p.name + ' (' + p.qty + ' ' + lotData.my_unidad + ')</option>');
              }
            });

            if (presentations.length <= 0 && (!firstLot || !firstLot.presentation)) {
              document.getElementById("sale_details_qty").focus();
              document.getElementById('qty_presentation_id').value = '';
              document.getElementById("sale_details_qty").value = "";
            } else {
              document.getElementById("qty_presentation_id").focus();
              document.getElementById("qty_presentation_id").value = "1";
              document.getElementById("sale_details_qty").value = $selPres.val() || 0;
            }

            $('#sale_details_item').css('border-color', '#ccc');
            update_price();
            subtotal();
          }
        }
      });
    });

    $('#qty_presentation_id').on('input change', function () {
      var qty = (document.getElementById("sel_presentation_id").value || 0) * (document.getElementById("qty_presentation_id").value || 0);
      document.getElementById("sale_details_qty").value = qty;
      validate_lot_coverage(qty);
      update_price();
      subtotal();
    });

    function validate_lot_coverage(requestedQty) {
      if (!window.currentAvailableLots || window.currentAvailableLots.length <= 1) return;
      var firstLot = window.currentAvailableLots[0];
      if (requestedQty > firstLot.qty_available) {
        var nextLot = window.currentAvailableLots[1];
        toastr.info('⚠️ Lote actual agotado ('+firstLot.qty_available+' '+document.getElementById('unit_item_id').innerHTML+'). El resto se tomará del ' + nextLot.lote, 'Despacho Mixto', {timeOut: 5000});
      }
    }

    $('#sale_details_price_id').on('change', function () {
      update_price();
    });
    function subtotal() {
      $('#sale_details_subtotal').val(get_subtotal());
    };

    $('#sale_details_qty').blur(function () {

      if ($('#sale_details_qty').val() > 0) {

        data = $('#sale_details_item_id').val();
        data_qty = $('#sale_details_qty').val();
        url = '/stocks_validate_qty';
        $.ajax({
          url: url,
          data: { item_id: data, qty_item_sale: data_qty },
          success: function (res) {
            // aqui debemos escrivir el script para controlar el redito y precio

            if (res['0'].valid) {
              $('#sale_details_qty').css('border-color', '#ccc');
              subtotal();

            } else {
              toastr.error('¡No hay la cantidad que solicita!');
              $('#sale_details_qty').css('border-color', 'red');
              $('#sale_details_qty').val('');
            }
          }
        });
      } else {
        $('#sale_details_qty').css('border-color', 'red');
        toastr.error('El valor ' + $('#sale_details_qty').val() + ' ' + 'No es aseptable')
        $('#sale_details_qty').val('');
      }

    });

    $('#sale_details_price_sale').blur(function () {
      subtotal();
      $('#sale_details_discount').val(0);

    });
    $('#sale_details_discount').blur(function () {

      update_price();
    });


    function discount_subtotal() {

      return ((get_subtotal() * $('#sale_details_discount').val()) / 100);
    }
    function get_subtotal() {

      return (($('#sale_details_qty').val() * $('#sale_details_price_sale').val()).toFixed(2));

    }

    function update_price() {

      var select = document.getElementById("sale_details_price_id");
      var current_discount = document.getElementById("sale_details_discount").value;
      data = select.value.toString();
      url = '/prices_select';
      $.ajax({
        url: url,
        data: { price_id: data },
        success: function (res) {
          var current_price_sale_unit = parseFloat(res['0'].price_sale) * (1 - parseFloat(current_discount) / 100);
          $('#sale_details_price').val(res['0'].price_sale);
          $('#sale_details_price_sale').val(current_price_sale_unit.toFixed(4));
          subtotal()
        }
      });
    }
  });
});

function change_qty(value) {
  $('#sale_details_qty').val(value * document.getElementById("qty_presentation_id").value);
  //document.getElementById("qty_presentation_id").focus();
}
