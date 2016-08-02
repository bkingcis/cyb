<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfparam name="session.signup.SEL_ENTRYPOINTS" default="">
<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<h4>What type of community is #session.signup.c_name#?</h4>
		<fieldset>
			<legend><small>Select One:</small></legend>
			  <div class="form-group">
				<label for="inputF_NAME" class="col-sm-2 control-label"></label>
				<div class="col-sm-5 col-med-5">
				<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="0" name="chk_showunitonlyoption" id="chk_proptype_condo">  Condominium/Apartment Building <br />
						 &nbsp; &nbsp; (common mailing address with individual unit numbers)
					</li>
					<li class="list-group-item">
					 <input type="radio" value="1" name="chk_showunitonlyoption" id="chk_proptype_multi">  Gated Community
					 <br />  &nbsp; &nbsp; (individual mailing addresses without unit numbers)
					</li>
				</ul>
				</div>
			  </div>
		  <fieldset/>	
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-primary" id="btn_continue">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>

<script>
	$(function() {
		$('#btn_continue').prop({
			  disabled: true
			});
		$('input[name="chk_showunitonlyoption"]').on( "click", function() {
		  $('#btn_continue').prop({
					disabled: false
			});
		});
	});
</script>
