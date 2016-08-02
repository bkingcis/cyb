<cfparam name="FNAME" DEFAULT="">
<cfparam name="LNAME" DEFAULT="">
<cfparam name="EMAIL" DEFAULT="">
<cfparam name="PGUEST" DEFAULT="NO">

<cfoutput>
	<cftry>
		<cfparam name="number_of_guests" default="1">
		<cfparam name="form.dashpass1" default="0">
		<script>
			$('form').validator().on('submit', function (e) {
			  if (e.isDefaultPrevented()) {
				alert('no go');
			  } else {
				// everything looks good!
			  }
			});
			$("form:not(.filter) :input:visible:enabled:first").focus();
		</script>
		<form action="/residents/popup/permguest3.cfm" method="post" data-toggle="validator">
		<input type="hidden" name="number_of_guests" value=#number_of_guests#>
		<fieldset>
		<cfloop from="1" to="#number_of_guests#" index="i">
		  <cfif i EQ 1>
		  	<cfset LNAME = "#LNAME#" & "LNAME#i#"> 		  
		  <cfelse>
			<cfset LNAME = "#LNAME#" & "," & "LNAME#i#"> 
		  </cfif>
		  
		 <div class="form-group">
				<label for="LName#i#" class="col-sm-4 col-md-4 control-label">Visitor Name:</label>
				<div class="col-sm-6 col-md-6">
				<input type="text" class="form-control inp-sm" id="LName#i#Inp" name="LName#i#" value="" placeholder="Last Name or Company Name" required data-error="Required" />
				</div>
				<div class="col-md-2 help-block with-errors"></div>
			</div>
			
			<div class="form-group">
				<label for="FName#i#" class="col-sm-4 col-md-4 control-label"> &nbsp;</label>
				<div class="col-sm-6 col-md-6">
				<input type="text" class="form-control inp-sm" id="FName#i#Inp" name="FName#i#" value="" placeholder="First Name" />
				</div>
				<div class="col-md-2 help-block with-errors"></div>
			</div>
			
				<!---
			<cfinclude template="../announce_prefs.cfm">
			    --->
			
			<cfif GetCommunity.DashPass IS 'YES'>
				<div class="form-group">
					<label class="col-sm-4 col-md-4 control-label" for="dashpass#i#">DashPass:</label>
					<div class="col-sm-6 col-md-6">
						<select id="dashpass#i#a" name="dashpass#i#" class="form-control inp-sm">
							<option class="list-group-item" value="gate">Pickup at Check-In</option>
							<option class="list-group-item" value="email">Email to Visitor</option>
						</select>
					</div>
					<div class="col-sm-2 col-md-2 help-block with-errors"></div>
				</div>
				<div class="form-group email-form-grp" id="email-form-grp#i#">
					<label for="Email#i#" class="col-sm-4 col-md-4 control-label"></label>
					<div class="col-sm-6 col-md-6">
						<input type="text" class="form-control inp-sm" id="Email#i#Inp" name="Email#i#" placeholder="Visitor's Email Address" required data-error="Required">
					</div>
					<div class="col-sm-2 col-md-2 help-block with-errors"></div>
				</div>
			<cfelse>
				<input type="hidden" name="Email#i#">
			</cfif>
		  
		  <cfif i EQ 1>
		  	<cfset EMAIL = "#EMAIL#" & "EMAIL#i#"> 		  
		  <cfelse>
		  	<cfset EMAIL = "#EMAIL#" & "," & "EMAIL#i#"> 
		  </cfif>  
		  
		  <input  type="hidden" name="pguest#i#" value="YES">
		  <cfif i EQ 1>
		  	<cfset pguest = pguest & "pguest#i#"> 		  
		  <cfelse>
		  	<cfset pguest = pguest & "," & "pguest#i#"> 
		  </cfif>
		 </cfloop>
			<input type=hidden name=FNAME value="#FNAME#">
			<input type=hidden name=LNAME value="#LNAME#">
			<input type=hidden name=EMAIL value="#EMAIL#">		
		
		</fieldset>	
		</form>
		<cfcatch><cfdump var="#cfcatch#"></cfcatch>
		</cftry>
	</cfoutput>