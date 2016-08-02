<cfinclude template="popup/header.cfm">
<cfparam name="form.fieldnames" default="g_barcode">
<cfparam name="passedInspection" default="NO">
<cfif passedInspection IS "NO">	
	<cfinclude template="residentsinfo.cfm">
	<cfquery name="getvisit" datasource="#datasource#">
		select * from guestvisits
		where v_id = '#url.v_id#'
	</cfquery>
	<cfquery name="getEmail" datasource="#datasource#">
		select * from guests
		where g_id = '#getvisit.g_id#'
	</cfquery>
	<cfset form.g_barcode = getemail.g_barcode>
	
	<table width="90%" style="font-size:11px;background-color:##f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;margin-bottom:10px;" cellpadding="0" cellspacing="3" border="0" align="center">
	<tr>
		<td width="65%" valign="top" align="center"><cfoutput><strong>#ucase(getEmail.g_lname)#<cfif len(getEmail.g_fname)>, #ucase(getEmail.g_fname)#</cfif></cfoutput><br /><br /></strong>
	<form action="reissuedashpass.cfm" method="post">
	DashPass Re-Issue Delivery Method<br>
	<input type="radio" name="reissueMethod" value="Gate">&nbsp;Gate&nbsp;&nbsp;&nbsp;<input type="radio" name="reissueMethod" value="Email">&nbsp;Email (<cfoutput>#getEmail.g_email#</cfoutput>)
	<cfoutput>
	<input type="hidden" name="v_id" value="#getvisit.v_id#">
	<input type="hidden" name="g_id" value="#getvisit.g_id#">
	<input type="hidden" name="g_barcode" value="#getEmail.g_barcode#">
	</cfoutput>
	<input type="hidden" name="passedInspection" value="YES">
	<input type="submit" value=" : re-issue : "
	</form>
		</td>
	</tr>
	</table>

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

	<cfinclude template="popup/header.cfm">
	<div class="alert alert-success"> DashPass Has been successfully Re-Issued</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
	<!--- <cfinclude template="actionlist.cfm"> --->
</cfif></div>

