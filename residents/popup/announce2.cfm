<cfsilent>
<cfquery name="getAddressbook" datasource="#datasource#">
	select * from guests
	where r_id = #session.user_id#
	AND showin_abook = 'TRUE'
	AND g_id not in (select g_id from guestvisits where g_permanent = 'True')
	order by g_lname
</cfquery>
<cfparam name="FNAME" DEFAULT="">
<cfparam name="LNAME" DEFAULT="">
<cfparam name="EMAIL" DEFAULT="">
<cfparam name="number_of_guests" default="1">

<cfloop from="1" to="#val(number_of_guests)#" index="i">
	<cfparam name="form.FNAME#i#" DEFAULT="">
	<cfparam name="form.LNAME#i#" DEFAULT="">
	<cfparam name="form.EMAIL#i#" DEFAULT="">
	<cfparam name="form.notify#i#" DEFAULT="">
	<cfparam name="form.DashPass#i#" DEFAULT="">
	<cfparam name="form.email_map#i#" DEFAULT="">
</cfloop></cfsilent><cfinclude template="header.cfm">
	
	
	<script>	
	function showDataPop(id) {			
		popBox = document.getElementById('popBox');
		addressFrame.location.href = '/residents/addressbook.cfm?number='+id;
		popBox.style.left = '270px';
		popBox.style.top = '188px';
		popBox.style.width = '212px';
		popBox.style.height = '320px';
		popBox.style.display = 'block';
		popBox.style.padding = '0px';
	}
	<cfoutput>
	function repeatRadios() {
		<cfif GetCommunity.DashPass IS 'YES'>
		if (document.ann2.dashpass1[0].checked == true){
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.dashpass#cf_i#[0].checked = true;	
			</cfloop>
			}
		else{
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.dashpass#cf_i#[1].checked = true;	
			</cfloop>
		}
		</cfif>
		
		<!--- <cfif GetCommunity.DashPass_Map IS 'YES'> --->
		if (document.ann2.email_map1[0].checked == true){
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.email_map#cf_i#[0].checked = true;	
			</cfloop>
			}
		else{
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.email_map#cf_i#[1].checked = true;	
			</cfloop>
		}
		<!--- </cfif> --->
		
		<cfif GetCommunity.Entry_Notify IS 'YES'>
		if (document.ann2.notify1[0].checked == true){
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.notify#cf_i#[0].checked = true;	
			</cfloop>
			}
		else if(document.ann2.notify1[1].checked == true) {
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.notify#cf_i#[1].checked = true;	
			</cfloop>
		}
		
		else {
			<cfloop from="2" to="#number_of_guests#" index="cf_i">
			document.ann2.notify#cf_i#[2].checked = true;	
			</cfloop>
		}</cfif>
		
	}</cfoutput>
	
	function toggleMyPhoneNumber(elem,phonefieldid) {
		if (elem.checked){
			document.getElementById(phonefieldid).disabled=false;
		}
		else document.getElementById(phonefieldid).disabled=true;
	}
	
	 $(document).ready(function(){
			$('#LName1Inp').blur(function(e){
				$('#FName1Inp').removeAttr('disabled');
				$('#Email1Inp').removeAttr('disabled');				
				//$('#LName2Inp').removeAttr('disabled');				
			});
			/*
			$('#LName2Inp').blur(function(e){
				$('#FName2Inp').removeAttr('disabled');
				$('#Email2Inp').removeAttr('disabled');				
				$('#LName3Inp').removeAttr('disabled');				
			});
			
			$('#LName3Inp').blur(function(e){
				$('#FName3Inp').removeAttr('disabled');
				$('#Email3Inp').removeAttr('disabled');			
			}); */
		});
</script><!--- 
 <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Announce <cfoutput>#labels.visitor#</cfoutput></h4>
      </div>
      <div class="modal-body">
        
		 #########  START BODY ######### --->
		<div role="tabpanel">

				  <!-- Nav tabs -->
				  <ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="#new" aria-controls="new" role="tab" data-toggle="tab"><cfoutput>#labels.visitor#</cfoutput> Details:</a></li>
					<li role="presentation"><a href="#old" aria-controls="old" role="tab" data-toggle="tab">Recent <cfoutput>#labels.visitor#</cfoutput>s:</a></li>
				  </ul>

				  <!-- Tab panes -->
				  <div class="tab-content">
					<div role="tabpanel" class="tab-pane" id="old">
					<cfinclude template="addressbook2.cfm">
					</div>
					<div role="tabpanel" class="tab-pane active" id="new" style="min-height: 230px;">
					<p> &nbsp; </p>
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
					<cfoutput>
						<form action="/residents/popup/announce3.cfm" method="Post" name="ann2" data-toggle="validator">
							<fieldset>
							<!--<legend>Arriving Guest Information</legend>-->
							<input type="hidden" name="number_of_guests" value="#number_of_guests#">
							<input type="hidden" name="f_ABUsed">
							<cfloop from="1" to="#number_of_guests#" index="i">
							  <cfif i EQ 1>
								  <cfset LNAME = "#LNAME#" & "LNAME#i#">
								  <cfelse>
								  <cfset LNAME = "#LNAME#" & "," & "LNAME#i#"> 
								</cfif>
								<cfif number_of_guests gt 1>
									<cfset headerRowspan = 2>
									<cfif GetCommunity.DashPass IS 'YES'>
										<cfset headerRowspan = headerRowspan + 1>
									</cfif>
									<cfif GetCommunity.guestcompanionOption eq 1>
										<cfset headerRowspan = headerRowspan + 1>
									</cfif>
									<div class="form-group">
										<label for="LName#i#" class="col-sm-2 control-label"><cfoutput>#labels.visitor#</cfoutput>: #i#</label>
										<div class="col-sm-5">
										<input type="text" class="form-control inp-sm" id="LName#i#Inp" name="LName#i#"<cfif i gt 1> disabled="disabled"</cfif> value="#evaluate('form.lname'&i)#"<cfif getAddressbook.recordcount> onclick="return showDataPop(#i#);"</cfif> style="color:Black;" required><!---  <span style="color:##666;"> (required)</span> --->
										</div>
									</div>
								</cfif>
								<div class="form-group">
									<label for="LName#i#" class="col-sm-4 col-md-4 control-label"><cfoutput>#labels.visitor#</cfoutput> Name:</label>
									<div class="col-sm-6 col-md-6">
									<input type="text" class="form-control inp-sm" id="LName#i#Inp" name="LName#i#" value="#evaluate('form.lname'&i)#" placeholder="Last Name or Company Name" required data-error="Required" />
									</div>
									<div class="col-md-2 help-block with-errors"> &nbsp;</div>
								</div>

								<div class="form-group">
									<label for="FName#i#" class="col-sm-4 col-md-4 control-label"> &nbsp;</label>
									<div class="col-sm-6 col-md-6">
									<input type="text" class="form-control inp-sm" id="FName#i#Inp" name="FName#i#" value="#evaluate('form.fname'&i)#" placeholder="First Name" />
									</div>
									<div class="col-md-2 help-block with-errors"> &nbsp;</div>
								</div>
			<cfif i EQ 1>
				<cfset FNAME = "#FNAME#" & "FNAME#i#"> 		  
			<cfelse>
				<cfset FNAME = "#FNAME#" & "," & "FNAME#i#"> 
			</cfif>
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
										<div class="help-block with-errors"> &nbsp;</div>
									</div>
									<div class="form-group email-form-grp" id="email-form-grp#i#">
										<label for="Email#i#" class="col-sm-4 col-md-4 control-label"></label>
										<div class="col-sm-6 col-md-6">
											<input type="text" class="form-control inp-sm" id="Email#i#Inp" name="Email#i#" placeholder="Visitor's Email Address" value="#evaluate('form.email'&i)#" required data-error="Required">
										</div>
										<div class="col-md-2 help-block with-errors"></div>
									</div>
								<cfelse>
									<input type="hidden" name="Email#i#">
								</cfif>
								<cfif GetCommunity.guestcompanionOption eq 1>
									<div class="form-group">
										<label for="guestcompanioncount#i#" class="col-sm-2 control-label">Plus Guests</label>
										<select name="guestcompanioncount#i#">
											<option>0</option>
											<option>1</option>
											<option>2</option>
											<option>3</option>
											<option>4</option><!--- 
											<option>5</option>
											<option>6 or more</option> --->
										</select>
									</div>
								</cfif>
								<cfif i EQ 1>
									<cfset EMAIL = "#EMAIL#" & "EMAIL#i#"> 		  
								<cfelse>
									<cfset EMAIL = "#EMAIL#" & "," & "EMAIL#i#"> 
								</cfif>
							</cfloop>
							<input type=hidden name=FNAME value="#FNAME#">
							<input type=hidden name=LNAME value="#LNAME#">
							<input type=hidden name=EMAIL value="#EMAIL#">		
						</cfoutput>
						
						
						<cfquery name="getperms" datasource="#datasource#">
							select guests.g_id
							FROM guests INNER JOIN guestvisits ON guests.g_id = guestvisits.g_id
							WHERE guests.r_id = #session.user_id#
							AND guestvisits.g_permanent = TRUE
							AND guests.g_cancelled IS NULL
							ORDER BY g_lname, g_fname
						</cfquery>
						
						<cfif getCommunity.permanantguests AND (getperms.recordcount lt maxPermGuests OR maxPermGuests eq 999)>
							<div class="form-group"><!-- spacer --> </div>
							<div class="form-group">
								<label for="permanantguest" class="col-sm-offset-4 col-sm-8 control-label">
								<input type="checkbox" name="permanantguest" id="permguest_chk"> <cfoutput>#labels.permanent_visitor# #labels.visitor#</cfoutput>
								</label>
							</div>
						</cfif>
						</fieldset>	


						</form>
						</div>
				  </div>

				</div>