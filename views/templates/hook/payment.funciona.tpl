<p class="payment_module">
	<div class="row">
		Pague con tarjeta de crédito/debito.
    
    <button id="btn_pago" class="btn btn-primary center-block">Realizar Pago</button><br/>
    <p class="hide" id="showresult">
        <b id="showresultcontent"></b>
    </p>

	</div>
</p>
{literal}
<script>

      Culqi.publicKey = '{/literal}{$llave_publica|escape:'htmlall':'UTF-8'}{literal}';

      Culqi.settings({
  			title: 'Venta',
  			currency: 'PEN',
  			description: '{/literal}{$descripcion|escape:'htmlall':'UTF-8'}{literal}',
  			amount: ({/literal}{$total|escape:'htmlall':'UTF-8'}{literal})*100
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
              url: fnReplace("http://{/literal}{$smarty.server.HTTP_HOST}{literal}/es/module/culqi/chargeajax"),
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
          var url = fnReplace("http://localhost:8080/es/module/culqi/postpayment");
          location.href = url;
      }

      function fnReplace(url) {
          return url.replace(/&amp;/g, '&');
      }

</script>
{/literal}