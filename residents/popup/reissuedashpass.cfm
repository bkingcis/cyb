
<cfinclude template="header.cfm">
<div role="tabpanel">
<CFIF session.user_id EQ 0>
	<h1>Your session has been closed due to inactivity.  Close this window to login</h1>
<CFELSE>
<cfsilent>
<cfparam name="form.fieldnames" default="g_barcode">
<cfparam name="passedInspection" default="NO">

</cfsilent>
	<cfif passedInspection IS "NO">
		<script language="JavaScript">
		$('.email-form-grp').hide();
		$("form").on('change','#dashpass-reissue',function(){
			if ( this.value === 'email'){
				$('.email-form-grp').show();
			} else {
				$('.email-form-grp').hide();
			}
		});
		</script>
		<cfquery name="getvisit" datasource="#datasource#">
			select * from guestvisits
			where v_id = '#url.v_id#'
		</cfquery>
		<cfquery name="getEmail" datasource="#datasource#">
			select g_fname,g_lname,g_email,g_barcode from guests
			where g_id = '#getvisit.g_id#'
		</cfquery>
		<cfset form.g_barcode = getemail.g_barcode>
		<cfoutput>
			<h4>Issue New DashPass for <cfif len(getEmail.g_fname)>#getEmail.g_fname#</cfif> #getEmail.g_lname#
			</h4>	
			<form action="reissuedashpass.cfm" method="post" data-toggle="validator">
				<fieldset>
				<div class="form-group">
					<label class="control-label" for="reissueMethod">DashPass Delivery Method:</label>
					<div class="">
						<select id="dashpass-reissue" name="reissueMethod" class="form-control inp-sm">
							<option class="list-group-item" value="gate">Pickup at Check-In</option>
							<option class="list-group-item" value="email">Email to Visitor</option>
						</select>
					</div>
					<div class="help-block with-errors"> &nbsp;</div>
				</div>
				<div class="form-group email-form-grp">
					<label for="g_email" class="control-label"></label>
					<div class="">
						<input type="text" class="form-control inp-sm" id="Email-Inp" name="g_email" 
						value="#getEmail.g_email#" placeholder="Visitor's Email Address" required data-error="Required">
					</div>
					<div class="col-md-2 help-block with-errors"></div>
				</div>
				<input type="hidden" name="v_id" value="#getvisit.v_id#">
				<input type="hidden" name="g_id" value="#getvisit.g_id#">
				<input type="hidden" name="g_barcode" value="#getEmail.g_barcode#">
				<input type="hidden" name="passedInspection" value="YES">
			</fieldset>
			</form>
		</cfoutput>
	<cfelse>
		<cfquery name="getNextBarcode" datasource="#datasource#">
			select * from barcodes
			Where c_id = #session.user_community#
			Order by bc_id
		</cfquery>
		<cfoutput query="getNextBarcode" startrow="#getNextBarcode.RecordCount#">
			<cfset #nextBarcode# = #Evaluate(Right(getNextBarcode.barcode,7)+1)#>
		</cfoutput>
			<cfset #zeroes# = "">
			<cfloop from="1" to="#evaluate(7-Len(nextBarcode))#" index="i">
			<cfset #zeroes# = "#zeroes#" & "0">
			</cfloop>
			<cfset #zeroes1# = "">
			<cfloop from="1" to="#evaluate(5-Len(session.user_community))#" index="i">
			<cfset #zeroes1# = "#zeroes1#" & "0">
			</cfloop>
			<cfset #gid# = "#zeroes1#" & "#session.user_community#" & "#zeroes#" & "#nextBarcode#">
			<cfquery name="getNewBarcode" datasource=#datasource#>
				UPDATE barcodes
					SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
					where barcode = '#form.g_barcode#'
			</cfquery>		
			<cfquery name="updateBarcodes" datasource="#datasource#">
				INSERT INTO barcodes
					(g_id,barcode,r_id,c_id)
					VALUES
					(#form.g_id#,'#gid#',#session.user_id#,#session.user_community#)
			</cfquery>
			<cfquery name="updateGuestVisits" datasource=#datasource#>
				UPDATE guestvisits
					SET g_barcode = '#gid#',dashpass='#reissueMethod#'
				WHERE v_id = #v_id#
			</cfquery>
			<cfquery name="updateGuestVisits" datasource=#datasource#>
				UPDATE guests
					SET g_barcode = '#gid#'
				WHERE g_id = #g_id#
			</cfquery>
		<cfif reissueMethod IS "email">
			<cfquery name="getGuestemail" datasource="#datasource#">
				select * from guests
				where g_id = #g_id#
			</cfquery>		
			<cfinclude template="reissue_emailpass.cfm">					
		</cfif> 

	<div class="alert alert-success">DashPass Has been successfully Re-Issued</div>

	</cfif>
</cfif>

</div>