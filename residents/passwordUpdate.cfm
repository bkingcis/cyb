<cfparam name="passiton" default="NO">
<div class="Container">
<cfif passiton IS "NO">
	<h3>Your password must be changed to continue.</h3>	<!--- 
	Enter your new password and confirmation and click submit. --->
	<div style="text-align:left; margin: 0px 20px;">
	<form id="passwordupdateFrm" action="/residents/passwordUpdate.cfm" method="Post">
		<div class="form-group row">
			<label for="password" class="col-sm-4 col-md-4 control-label">Password:</label>
			<div class="col-sm-6 col-md-6">
			<input type="password" class="form-control" name="password" required="required" placeholder="new password">
			</div>
		</div>
		<div class="form-group row">
			<label for="password" class="col-sm-2 col-md-4 control-label">Password Confirm:</label>
			<div class="col-sm-6 col-md-6">
			<input type="password" class="form-control" size="20" name="Confirm_Password" required="required" placeholder="confirm" />
			</div>
		</div>	
		<input type="hidden" name="passiton" value="yes" />
		<div class="form-group row">
		<input id="passwordupdateBtn" type="submit" value="Save & Continue" class="btn btn-primary" />
	</form></div>
<cfelse>
	<cfif form.password neq form.Confirm_Password>	
		<h2>Passwords did not match. Please use your browser's back button and try again.</h2>
	<cfelse>
		<cftry><cfquery name="getPass" datasource="#datasource#">
			update residents
			set r_password = '#form.password#', r_passReset = 1
			where r_id = #session.user_id#			
		</cfquery>Your password has been updated successfully.<br>
		<br>
		<a href="/residents/index.cfm">Click here to continue</a>.
		<cfcatch type="Any">There was a problem updating your password<br>
	
		<br>
		<br>
		<br>
		<br>
		<cfdump var="#cfcatch#"></cfcatch>
		</cftry>
		
	</cfif>	
</cfif></div>

<script>
	 $(document).ready(function(){
		$("#passwordupdateFrm").ajaxForm({
		   	success: function(responseText){
		            $.fancybox({
		                'content' : responseText,
						'height':290,
						'width':500,
						'autoDimensions':false
		            });
		        }
		})
	});
</script>