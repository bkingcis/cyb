<CFIF ParameterExists(session.staff_id) AND session.staff_id GT 0>
	<cfparam name="passedInspection" default="NO">
<cfif passedInspection IS "NO">
<cfinclude template="../header5.cfm">	
	<cfinclude template="residentsinfo.cfm">
	<cfquery name="getEmail" datasource="#datasource#">
		select * from guests 
		where g_barcode = '#form.g_barcode#'
	</cfquery>
	<table width="90%" style="font-size:11px;background-color:##f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;margin-bottom:10px;" cellpadding="0" cellspacing="3" border="0" align="center">
	<tr>
		<td width="65%" valign="top" align="center">
	<form action="reissuedashpass.cfm" method="post">
	<div style="font-size:14px;padding-bottom:5px;font-weight:bold">DashPass Re-Issue Delivery Method</div><br>
	<input type="radio" name="reissueMethod" value="Gate">&nbsp;Gate&nbsp;&nbsp;&nbsp;<input type="radio" name="reissueMethod" value="Email">&nbsp;Email (<cfoutput>#getEmail.g_email#</cfoutput>)
	<cfloop INDEX="i" list="#form.FieldNames#">
	<cfoutput>
	<input type="hidden" name="#i#" value="#Evaluate(i)#">
	</cfoutput>
	</cfloop>
	<input type="hidden" name="passedInspection" value="YES">

	<input type="submit" value=" : re-issue : "
	</form>
		</td>
	</tr>
	</table>
	<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">	

<cfelse>
``				<cfquery name="getNextBarcode" datasource="#datasource#">
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
						(#form.g_id#,'#gid#',#form.r_id#,#session.user_community#)
				</cfquery>
				<cfquery name="updateGuestVisits" datasource=#datasource#>
					UPDATE guestvisits
						SET g_barcode = '#gid#'
					WHERE v_id = #v_id#
				</cfquery>
				<cfquery name="updateGuestVisits" datasource=#datasource#>
					UPDATE guests
						SET g_barcode = '#gid#'
					WHERE g_id = #g_id#
				</cfquery>
			<cfif #reissueMethod# IS "email">
				<cfquery name="getGuestemail" datasource="#datasource#">
					select * from guests
					where g_id = #g_id#
				</cfquery>		
				<cfinclude template="reissue_emailpass.cfm">					
			</cfif> 

	<cfinclude template="../header5.cfm">
	<cfinclude template="residentsinfo.cfm">
	<strong><div align="center">DashPass Has been successfully Re-Issued</div></strong>
	<cfinclude template="actionlist.cfm">
	<cfinclude template="../footer.cfm">
</cfif>
	
	
<CFELSE>


	<cflocation URL="../staff.cfm">	

</CFIF>
