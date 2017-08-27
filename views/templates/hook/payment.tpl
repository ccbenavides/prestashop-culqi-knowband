<p class="payment_module">
	<div class="row">

		Pague con tarjeta de crédito/debito.
     <p class="hide" id="showresult">
        <b id="showresultcontent"></b>
    </p>
    {*
    <button id="btn_pago" class="btn btn-primary center-block">Realizar Pago</button><br/>
    <p class="hide" id="showresult">
        <b id="showresultcontent"></b>
    </p>
    *}

	</div>
</p>
{literal}
<script>
      /*var method_option = $('input:radio[name="payment_method"]:checked').attr('data-module-name');
      if(method_option === "culqi"){
        alert(culqi);
      }*/
      Culqi.publicKey = '{/literal}{$llave_publica|escape:'htmlall':'UTF-8'}{literal}';

      Culqi.settings({
  			title: 'Venta',
  			currency: 'PEN',
  			description: '{/literal}{$descripcion|escape:'htmlall':'UTF-8'}{literal}',
  			// amount: ({/literal}{$total|escape:'htmlall':'UTF-8'}{literal})*100
         amount : parseInt($("#total_price").text().trim().replace("S/. ", "")*100).toString()
      });


      // Process to Pay
      function culqi() {
        if(Culqi.token) {
          $(document).ajaxStart(function(){
              run_waitMe();
              /*display_progress();*/
          });
          $(document).ajaxComplete(function(){
              $('body').waitMe('hide');
              /*hide_progress();*/
          });
          var installments = (Culqi.token.metadata.installments == undefined) ? 1 : Culqi.token.metadata.installments;
          $.ajax({
              url: fnReplace("http://{/literal}{$smarty.server.HTTP_HOST}{literal}/module/culqi/chargeajax"),
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
                  /*hide_progress();*/
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
                    /*hide_progress();*/
                    showResult('green',result.outcome.user_message);
                    redirect();
                  }
                  if(result.object === 'error'){
                    $('body').waitMe('hide');
                    /*hide_progress();*/
                    showResult('red',result.user_message);
                  }
                }
              }
          });
        } else {
          $('body').waitMe('hide');
          /*hide_progress();*/
					if(Culqi.error != undefined) {
						showResult('red',Culqi.error.user_message);
					}
        }
      }

      function run_waitMe() {
        /*display_progress();*/
        $('body').waitMe({
          effect: 'orbit',
          text: 'Procesando pago...',
          bg: 'rgba(255,255,255,0.7)',
          color:'#28d2c8'
        });
      }
      function display_progress() {
    
          $('#supercheckout_confirm_order').attr('disabled', true);

            $('#submission_progress_overlay').css('height', $('#supercheckout-fieldset').height());
          /*  $('#supercheckout_order_progress_status_text').html(value + '%');*/
            $('#submission_progress_overlay').show();
            $('#supercheckout_order_progress_bar').show();
        }

        function hide_progress() {
            $('#supercheckout_confirm_order').removeAttr('disabled');
            $('#submission_progress_overlay').hide();
            $('#supercheckout_order_progress_bar').hide();
            $('#supercheckout_order_progress_status_text').html('0%');
        }
      function showResult(style,message) {
        $('#showresult').removeClass('hide');
        $('#showresultcontent').attr('class', '');
        $('#showresultcontent').addClass(style);
        $('#showresultcontent').html(message);
      }

      function redirect() {
          var url = fnReplace("http://{/literal}{$smarty.server.HTTP_HOST}{literal}/module/culqi/postpayment");
          location.href = url;
      }

      function fnReplace(url) {
          return url.replace(/&amp;/g, '&');
      }

</script>
{/literal}