
$(document).on('turbolinks:load', function () {
    // Inicializar efectos Premium
    initPremiumSales();

    // Listener para el toggle de crédito
    $('#Checkboxes_Grape').on('change', function () {
        const isChecked = $(this).is(':checked');
        const label = $('#id_credit');

        if (isChecked) {
            label.text('A Crédito').addClass('text-primary');
            $('.additional-info').slideDown();
        } else {
            label.text('A Contado').removeClass('text-primary');
            $('.additional-info').slideUp();
        }
    });

    // Animación suave cuando cambia el total
    const totalObserver = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.type === "characterData" || mutation.type === "childList") {
                const element = $('#id_input_currency');
                element.addClass('pulse-animation');
                setTimeout(() => element.removeClass('pulse-animation'), 500);

                // Actualizar barra de crédito si es necesario
                updateCreditBar();
            }
        });
    });

    const target = document.querySelector('#id_input_currency');
    if (target) {
        totalObserver.observe(target, { childList: true, characterData: true, subtree: true });
    }
});

function initPremiumSales() {
    console.log('Iron Premium Sales Activated');

    // Si el checkbox de crédito no está chequeado al cargar
    if (!$('#Checkboxes_Grape').is(':checked')) {
        $('.additional-info').hide();
        $('#id_credit').text('A Contado');
    }
}

function updateCreditBar() {
    const available = parseFloat($('#line_credit_client_available').text()) || 0;
    const currentTotal = parseFloat($('#id_input_currency').text()) || 0;

    // Aquí podrías restar el total actual del disponible para mostrar una previsualización
    // Pero por ahora solo refrescamos la estética si es necesario
}

// Estilos extra para animaciones JS
$("<style>")
    .prop("type", "text/css")
    .html(`
        .pulse-animation {
            animation: pulse 0.5s ease-in-out;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }
        .m-l-10 { margin-left: 10px; }
        .m-t-10 { margin-top: 10px; }
        .m-b-20 { margin-bottom: 20px; }
        .font-weight-bold { font-weight: 700; }
        .d-block { display: block; }
        .align-items-center { align-items: center; }
        .display-flex { display: flex; }
    `)
    .appendTo("head");
