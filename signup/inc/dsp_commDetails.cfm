<cfparam name="session.signup.F_NAME" default="">
<cfparam name="session.signup.L_NAME" default="">
<cfparam name="session.signup.email" default="">
<cfparam name="session.signup.phone" default="">
<cfparam name="session.signup.c_name" default="">
<cfparam name="session.signup.homesite_count" default="">
<cfparam name="session.signup.c_address1" default="">
<cfparam name="session.signup.c_address2" default="">
<cfparam name="session.signup.c_address3" default="">
<cfparam name="session.signup.c_city" default="">
<cfparam name="session.signup.c_state" default="">
<cfparam name="session.signup.c_postalcode" default="">
<cfparam name="session.signup.timezone" default="">

<cfquery name="qStateLst" datasource="cybatrol">
	select * from states
</cfquery>

<cfoutput>
	<form class="form-horizontal" id="step1" method="post" action="?action=#xfa.submit#" role="form">	
	<p><!-- In a few easy steps, your community will be utilizing the most cost-effective visitor announcement system available today.--></p>
		<fieldset>
			<legend>Community Administrator:</legend>
			  <div class="form-group">
				<label for="inputF_NAME" class="col-sm-2 control-label">Administrator Name</label>
				<div class="col-sm-3">
				  <input type="text" class="form-control req" id="inputF_NAME" name="F_NAME" placeholder="First Name" value="#session.signup.F_NAME#"
				  data-toggle="tooltip" data-placement="right" title="Community Administrator is generally a property manager or homeowner's association member.  A
					person responsible for managing the property's personnel (employees).">
				</div>
				<div class="col-sm-3">
				  <input type="text" class="form-control req" id="inputL_NAME" name="L_NAME" placeholder="Last Name" value="#session.signup.L_NAME#">
				</div>
			  </div>
			  <div class="form-group">
				<label for="inputEMAIL" class="col-sm-2 control-label">Email</label>
				<div class="col-sm-6">
				  <input type="email" class="form-control req" name="email" id="inputEMAIL" placeholder="Email" value="#session.signup.email#">
				</div>
			  </div>
			  <div class="form-group">
				<label for="inputPassword" class="col-sm-2 control-label">Password</label>
				<div class="col-sm-3">
				  <input type="password" class="form-control inp-sm req-pass" id="inputPassword" name="newUser_password">
				</div>
			  </div>
			  <div class="form-group">
				<label for="inputPasswordConfirm" class="col-sm-2 control-label">Confirm Password</label>
				<div class="col-sm-3">
				  <input type="password" class="form-control inp-sm req-pass" id="inputPasswordConfirm">
				</div>
			  </div>
			  <div class="form-group">
				<label for="inputPHONE" class="col-sm-2 control-label">Phone</label>
				<div class="col-sm-3">
				  <input type="phone" class="form-control req" id="inputPHONE" placeholder="999-999-9999" name="phone" value="#session.signup.phone#">
				</div>
			  </div>
		  <fieldset/>
		  <fieldset>
			<legend>Community Details:</legend>
		    <div class="form-group">
				<label for="inputC_NAME" class="col-sm-2 control-label">Community Name</label>
				<div class="col-sm-10">
				  <input type="text" class="form-control req" id="inputC_NAME" placeholder="Community/Condominium Name" name="c_name" value="#session.signup.c_name#">
				</div>
		    </div>
			<!--- TODD Says go ahead and leave this off for now 1/29/2015
			<div class="form-group">
				<label for="chk_PropertyHasUnits" class="col-sm-2 control-label">Property Type</label>
				<div class="col-sm-3">
				 <ul class="list-group">
					<li class="list-group-item"><input type="checkbox" value="0" name="chk_PropertyHasUnits" id="chk_PropertyType_hasUnits" checked="checked"> Single Address w/ Multiple Unit Numbers (ex: Condominium Building)</li>
				 	<li class="list-group-item"><input type="checkbox" value="1" name="chk_PropertyHasUnits" id="chk_PropertyType_NoUnits"> Multiple Addresses (ex: Country Club Community)</li>
				 </ul>
				</div>
			</div> --->
			<div class="form-group">
				<label for="inputC_homesite_count" class="col-sm-2 control-label">Property Size</label>
				<div class="col-sm-10">
				  <div class="row">
				  	<div class="col-sm-4">
				  		<input type="text" class="form-control req" id="inputC_homesite_count" maxlength="5" placeholder="example: 250" name="homesite_count" value="#session.signup.homesite_count#" id="homesite_count"
						data-toggle="tooltip" data-placement="right" title="Total number of physical addresses or condo units within the property (Not individual resident users).">
				  	</div>
				  </div>
				</div>
		    </div>
			<div class="form-group">
				<label for="inputC_ADDRESS1" class="col-sm-2 control-label">Community Address</label>
				<div class="col-sm-8">
				  <input type="text" class="form-control req" id="inputC_ADDRESS1" placeholder="Street Address" name="c_address1" value="#session.signup.c_address1#"	
				    data-toggle="tooltip" data-placement="right" title="Mailing address or management office location">
				</div>				
			</div>			
			<div class="form-group">
				<label for="c_address2" class="col-sm-2 control-label"> </label>
				<div class="col-sm-8">
				  <input type="text" class="form-control" id="inputC_ADDRESS2" placeholder="Line 2" name="c_address2" value="#session.signup.c_address2#">
				</div>
			</div>			
			<div class="form-group">
				<label for="c_city" class="col-sm-2 control-label"> </label>
				<div class="col-sm-3 req">
			  	<input type="text" class="form-control" id="inputC_CITY" placeholder="CITY" name="c_city" value="#session.signup.c_city#">
				</div>
				<cftry>
				<div class="col-sm-3">
			  		<select type="text" class="form-control req" id="inputC_state" name="c_state">
						<option value="">Choose</option>
						<cfloop query="qStateLst"><option<cfif session.signup.c_state is qStateLst.abbreviation> selected="selected"</cfif> value="#qStateLst.abbreviation#">#qStateLst.state#</option></cfloop>
					</select>
				</div>
					<cfcatch><cfdump var="#cfcatch#"></cfcatch>
				</cftry>
				<div class="col-sm-2">
			  	  <input type="text" class="form-control req" id="inputC_ZIP" maxlength="5" placeholder="ZIP/Postal Code"name="c_postalcode" value="#session.signup.c_postalcode#">
				</div>
			</div>
			 <div class="form-group">
			  <label for="inputtimezone" class="col-sm-2 control-label">Community Timezone:</label>
				<div class="col-sm-3 req">
			  		<select name="timezone" type="text" class="form-control">
						<option value="">Choose...</option>
						<option value="hawaii"<cfif session.signup.timezone is 'hawaii'> selected="true"</cfif>>Hawaii-Aleutian Time Zone (UTC-10:00)</option>
						<option value="alaska"<cfif session.signup.timezone is 'alaska'> selected="true"</cfif>>Alaska Time Zone (UTC-09:00)</option>
						<option value="pacific"<cfif session.signup.timezone is 'pacific'> selected="true"</cfif>>Pacific Time Zone (UTC-08:00)</option>
						<option value="mountain"<cfif session.signup.timezone is 'mountain'> selected="true"</cfif>>Mountain Time Zone (UTC-07:00)</option>	
						<option value="central"<cfif session.signup.timezone is 'central'> selected="true"</cfif>>Central Time Zone (UTC-06:00)</option>	
						<option value="eastern"<cfif session.signup.timezone is 'eastern'> selected="true"</cfif>>Eastern Time Zone (UTC-05:00)</option>
						<option value="atlantic"<cfif session.signup.timezone is 'atlantic'> selected="true"</cfif>>Atlantic Time Zone (UTC-04:00)</option>
				  	</select>
				</div>
			  
			  </div>
		</fieldset>
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>

<script>
	$(function(){
		 $("[data-toggle='tooltip']").tooltip({
		 	placement:'top'
		 }); 
		 
		 $('input').first().focus();
		 
		 $('.req').blur(function() {
		 	$this = $(this);
			  if($this.val() == ''){
			  	$this.closest('.form-group').addClass('has-error');
				if ( $this.attr('placeholder').indexOf('required') == -1 ){
					$this.attr('placeholder',$this.attr('placeholder')+' required');
				}
				//$this.focus();
			  } else {
			  	$this.closest('.form-group').removeClass('has-error');
			  }
		 });
		 
		 $('.req-pass').blur(function() {
		 	$this = $(this);
			  if($this.val() == ''){
			  	$this.closest('.form-group').addClass('has-error');
				//$this.val('required');
				$this.focus();
			  } else {
			  	$this.closest('.form-group').removeClass('has-error');
			  }
		 });
		 
		 $('.btn-primary').on('click', function(){
		 	if ( $( '.has-error' ).length ) {
				alert('Please complete all required fields');
			} else {
				if ( $( '.req-pass' ).val() == '' || !($( '#inputPassword' ).val() === $( '#inputPasswordConfirm' ).val())) {
					//console.log($( '.req-pass' ).val() );
					alert('Must be a valid password and passwords must match. ');
				} else {
					$('#step1').submit();
				}
			}
		 });
		 
	});
</script>

<!-- Google Code for 45 Day Trial to Sign-up Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 1021168287;
var google_conversion_language = "en";
var google_conversion_format = "3";
var google_conversion_color = "ffffff";
var google_conversion_label = "ObTJCPD0omMQn5X35gM";
var google_remarketing_only = false;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/1021168287/?label=ObTJCPD0omMQn5X35gM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>