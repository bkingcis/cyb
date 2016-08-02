<cfif not structKeyExists(session.signup,"homesite_count") or NOT val(session.signup.homesite_count)>
	<div class="panel panel-default">
	  <div class="panel-heading">There has been an issue</div>
	  <div class="panel-body">
		Please return to <a href="/signup/">step 1</a> and correct the Number of units/residents.
	  </div>
	</div>
<cfelse>
 <!--- 	<cfset monthly_fee = session.signup.homesite_count * 1.99>
					 1 - 49 units  $79 per month
					50 - 99 units  $89 per month
					100 - 249 units  $99 per month
					250 - 499 units  $149 per month
					500 - 749 units  $199 per month
					750 - 999 units  $249 per month
					1000 - 1999 units  $299 per month
					2000 - 2999 units  $349 per month
					 --->
					 <cfif session.signup.homesite_count lt 50>
					 	<cfset monthly_fee = 79>
					<cfelseif session.signup.homesite_count lt 100>
					 	<cfset monthly_fee = 89>
					<cfelseif session.signup.homesite_count lt 250>
					 	<cfset monthly_fee = 99>
					<cfelseif session.signup.homesite_count lt 500>
					 	<cfset monthly_fee = 149>
					<cfelseif session.signup.homesite_count lt 750>
					 	<cfset monthly_fee = 199>
					<cfelseif session.signup.homesite_count lt 1000>
					 	<cfset monthly_fee = 249>
					<cfelseif session.signup.homesite_count lt 2000>
					 	<cfset monthly_fee = 299>
					<cfelseif session.signup.homesite_count lt 3000>
					 	<cfset monthly_fee = 349>
					<cfelse>
					 	<cfset monthly_fee = 0>
					</cfif>

<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<fieldset>
			 <p class="lead"><!--- No payment is required at this time. --->Please enjoy your customized visitor management system FREE for 30 days.<br />
			 After the trial period you will be billed the following:</p>
			
			<cfif monthly_fee eq 0>
				Contact us directly for pricing.
			<cfelse>
			<div class="form-group">
				<label for="PaymentOption"></label>
				<div class="col-sm-6">
					<ul class="list-group">
						<li class="list-group-item">
						 <input type="radio" value="monthly" name="PaymentOption" id="chk_PaymentOption_monthly">  <strong>#dollarFormat(monthly_fee)# / Month</strong>
							<em>Monthly Service Charge</em>
						</li>
					</ul>
				</div>
			</div>
			<div class="form-group">
				<label for="PaymentOption2"></label>
				<div class="col-sm-6">
					<ul class="list-group">
						<li class="list-group-item">
						<cfset yearly_fee = monthly_fee * 12 * 0.9>
						 <input type="radio" value="yearly" name="PaymentOption" id="chk_PaymentOption_yearly" checked="checked">  <strong>#dollarFormat(yearly_fee)# / Year</strong>
						 <em>Annual Service Charge (10% discount)</em>
						</li>
					</ul>
				</div>
			</div>
			</cfif>
	
		</fieldset>
		<fieldset>
			<legend>Agreement:</legend>
			<p style="display:inline-block;max-width:720px;margin-bottom:25px;">
			Please review our "Terms & Conditions" and
			"Privacy Policy."  We respect and protect the privacy of ALL users. Information provided will not be sold or shared.  
			If you have any questions or concerns, please do not hesitate to contact us.</p>
			 <div class="form-group">
			  <label for="PaymentOption2"></label>
				<div class="col-sm-6">
					<ul class="list-group">
						<li class="list-group-item">
							<input type="checkbox" value="1" name="chk_Agree" id="chk_Agree_terms">  I Agree to the <a href="TermsandConditions-Website-Cybatrol.doc" target="_blank">Terms & Conditions <i class="glyphicon glyphicon-file
"></i></a>
						</li>
					</ul>
				</div>	
			</div>
			<div class="form-group">
			 <label for="PaymentOption2"></label>
				<div class="col-sm-6">
					<ul class="list-group">
						<li class="list-group-item">	 
							<input type="checkbox" value="1" name="chk_Agree" id="chk_Agree_privacy">  I Agree to the <a href="PrivacyPolicy-Website-Cybatrol.docx" target="_blank">Privacy Policy <i class="glyphicon glyphicon-file
"></i></a>
						</li>
					</ul>
				</div> 
			</div>
		  <fieldset/>		
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		 <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" id="btn_continue" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>
<script>
	$(function() {
		$('#btn_continue').prop({
			  disabled: true
			});
		$('input[name="chk_Agree"]').on( "click", function() {
		  if ($('#chk_Agree_terms').prop('checked') && $('#chk_Agree_privacy').prop('checked') ) {
				$('#btn_continue').prop({
					disabled: false
				});
			} else {
				$('#btn_continue').prop({
					disabled: true
				});
			}
		});
	});
</script>

</cfif>