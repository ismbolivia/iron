$(document).on('turbolinks:load', function () {
    if (!$('#pos-interface').length) return;

    const searchInput = $('#pos-product-search');
    const resultsDropdown = $('#search-results');
    const itemsList = $('#pos-items-list');

    // Foco inicial en buscador
    searchInput.focus();

    // Atajos de teclado
    $(document).keydown(function (e) {
        if (e.which === 113) { // F2
            searchInput.focus();
            return false;
        }
    });

    // Búsqueda AJAX
    searchInput.on('keyup', function () {
        let query = $(this).val();
        if (query.length < 2) {
            resultsDropdown.hide();
            return;
        }

        $.ajax({
            url: '/items_suggestion',
            data: { query: query },
            success: function (items) {
                renderSearchResults(items);
            }
        });
    });

    function renderSearchResults(items) {
        if (items.length === 0) {
            resultsDropdown.hide();
            return;
        }

        let html = '';
        items.forEach(item => {
            html += `
        <div class="search-item" data-id="${item.id}">
          <div class="row align-items-center">
            <div class="col-xs-8">
              <div class="font-bold">${item.name}</div>
              <small class="text-muted">${item.code} - ${item.description}</small>
            </div>
            <div class="col-xs-4 text-right">
              <span class="badge badge-success">${item.price_sale_unit}</span>
            </div>
          </div>
        </div>
      `;
        });

        resultsDropdown.html(html).show();
    }

    // Seleccionar producto de búsqueda
    $(document).on('click', '.search-item', function () {
        const itemId = $(this).data('id');
        const saleId = $('#premium-sale-form').attr('action').split('/').pop();

        addItemToSale(itemId, saleId);
        resultsDropdown.hide();
        searchInput.val('').focus();
    });

    function addItemToSale(itemId, saleId) {
        // Aquí implementaremos la llamada al controlador para añadir el item
        $.ajax({
            url: `/premium_sales/${saleId}/add_item`,
            method: 'POST',
            data: { item_id: itemId },
            success: function (response) {
                updatePOSView(response);
                toastr.success('Producto añadido');
            }
        });
    }

    // Eliminar producto
    $(document).on('click', '.btn-delete-item', function () {
        const detailId = $(this).data('id');
        const saleId = $('#premium-sale-form').attr('action').split('/').pop();

        if (confirm('¿Eliminar este producto?')) {
            $.ajax({
                url: `/premium_sales/${saleId}/remove_item`,
                method: 'POST',
                data: { detail_id: detailId },
                success: function (response) {
                    updatePOSView(response);
                    toastr.info('Producto eliminado');
                }
            });
        }
    });

    function updatePOSView(data) {
        itemsList.html(data.html);
        $('#pos-subtotal').text(data.subtotal);
        $('#pos-total-big').text(data.total);
        $('#empty-state').toggleClass('hidden', data.count > 0);
    }

    // Manejo del switch de crédito
    $('#pos-credit-switch').on('change', function () {
        const isCredit = $(this).is(':checked');
        $('#credit-label-status').text(isCredit ? 'Venta a Crédito' : 'Venta al Contado');
        $('#credit-label-status').toggleClass('text-primary', isCredit);
    });
});

// Estilos extra para el dropdown de búsqueda (inyectados si es necesario o en el CSS)
