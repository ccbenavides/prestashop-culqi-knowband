
Culqi.publicKey = document.getElementById('space_llave_publica').value;

Culqi.settings({
    title: 'Venta',
    currency: 'PEN',
    description: document.getElementById('space_descripcion').value,
    amount: document.getElementById('space_total').value*100
});

$('#btn_pago').on('click', function(e) {
    e.preventDefault();
    console.log("estoy aqui");
    $('#showresult').addClass('hide');
    Culqi.open();
});

// Process to Pay
function culqi() {
if(Culqi.token) {
    $(document).ajaxStart(function(){
        run_waitMe();
    });
    $(document).ajaxComplete(function(){
        $('body').waitMe('hide');
    });
    var installments = (Culqi.token.metadata.installments == undefined) ? 1 : Culqi.token.metadata.installments;
    $.ajax({
        url: fnReplace(document.getElementById('space_charge').value),
        data: {
        ajax: true,
        action: 'displayAjax',
        token_id: Culqi.token.id,
        installments: installments
        },
        type: "POST",
        dataType: 'json',
        success: function(data) {
        if(data === "Error de autenticación") {
            $('body').waitMe('hide');
            showResult('red',data + ": verificar si su Llave Secreta es la correcta");
        } else {
            var result = "";
            if(data.constructor == String){
                result = JSON.parse(data);
            }
            if(data.constructor == Object){
                result = JSON.parse(JSON.stringify(data));
            }
            if(result.object === 'charge'){
            $('body').waitMe('hide');
            showResult('green',result.outcome.user_message);
            redirect();
            }
            if(result.object === 'error'){
            $('body').waitMe('hide');
            showResult('red',result.user_message);

            }
        }
        }
    });
} else {
    $('body').waitMe('hide');
            if(Culqi.error != undefined) {
                showResult('red',Culqi.error.user_message);
            }
}
}

function run_waitMe() {
$('body').waitMe({
    effect: 'orbit',
    text: 'Procesando pago...',
    bg: 'rgba(255,255,255,0.7)',
    color:'#28d2c8'
});
}

function showResult(style,message) {
$('#showresult').removeClass('hide');
$('#showresultcontent').attr('class', '');
$('#showresultcontent').addClass(style);
$('#showresultcontent').html(message);
}

function redirect() {
    var url = fnReplace(document.getElementById('space_link').value);
    location.href = url;
}

function fnReplace(url) {
    return url.replace(/&amp;/g, '&');
}


