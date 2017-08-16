<input type="text" id="space_llave_publica" value="{$llave_publica}">
<input type="text" id="space_descripcion" value="{$descripcion}">
<input type="text" id="space_total" value="{$total}">
{*
<input type="text" id="space_link" value="{$link->getModuleLink('culqi', 'postpayment', [], true)|escape:'htmlall':'UTF-8'}">
<input type="text" id="space_charge" value="{$link->getModuleLink('culqi', 'postpayment', [], true)|escape:'htmlall':'UTF-8'}">
*}
<p class="payment_module">
	<div class="row">
		<link rel="stylesheet" href="{$module_dir|escape:'htmlall':'UTF-8'}views/css/culqi.css" type="text/css" media="all">
    <link rel="stylesheet" href="{$module_dir|escape:'htmlall':'UTF-8'}views/css/waitMe.min.css" type="text/css" media="all">
    <script type="text/javascript" src="{$module_dir|escape:'htmlall':'UTF-8'}views/js/waitMe.min.js"></script>
    <script type="text/javascript" src="{$module_dir|escape:'htmlall':'UTF-8'}views/js/principal.js"></script>
   

		Pague con tarjeta de crédito/debito.


    <button id="btn_pago" class="btn btn-primary center-block">Realizar Pago</button><br/>
    <p class="hide" id="showresult">
        <b id="showresultcontent"></b>
    </p>

	</div>
</p>

