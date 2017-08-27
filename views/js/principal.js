
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
        display_progress();
    });
    $(document).ajaxComplete(function(){
        $('body').waitMe('hide');
        hide_progress();
        
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
            hide_progress();
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
            hide_progress();
            showResult('green',result.outcome.user_message);
            redirect();
            }
            if(result.object === 'error'){
            $('body').waitMe('hide');
            hide_progress();
            showResult('red',result.user_message + "esto no pasa");

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


function display_progress() {
    
  $('#supercheckout_confirm_order').attr('disabled', true);

 /*     $('#submission_progress_overlay').css('height', $('#supercheckout-fieldset').height());
    $('#supercheckout_order_progress_status_text').html(value + '%');*/
    $('#submission_progress_overlay').show();
    $('#supercheckout_order_progress_bar').show();
}

function hide_progress() {
    $('#supercheckout_confirm_order').removeAttr('disabled');
    $('#submission_progress_overlay').hide();
    $('#supercheckout_order_progress_bar').hide();
    $('#supercheckout_order_progress_status_text').html('0%');
}

function run_waitMe() {
    display_progress();
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


