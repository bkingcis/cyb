	<CFIF session.user_id EQ 0>
	    <cflocation URL="../residents.cfm">
	<CFELSE>
		<!--- <cfinclude template="header.cfm"> --->
		<cfquery name="updateGuests" datasource="#datasource#">
			UPDATE guests
			set g_fname = '#form.g_fname#',
			    g_lname = '#form.g_lname#',
				g_email = '#form.g_email#',
				showin_abook = <cfif showin_abook IS 'YES'>TRUE<cfelse>FALSE</cfif>
			where g_id = #g_id#
		</cfquery>
			
	<!---<CFQUERY name="InsertHistory" datasource="#datasource#">
			insert into guestshistory
			(g_id,r_id,h_id,c_id,g_fname,g_lname,g_email,g_barcode,g_photo,showin_abook,datechanged)
			VALUES
			(#g_id#,#session.user_id#,#val(h_id)#,#session.user_community#,'#g_fname#','#g_lname#','#g_email#','#g_barcode#','#g_photo#',
			<cfif showin_abook IS 'YES'>TRUE<cfelse>FALSE</cfif>,#CreateODBCDateTime(request.timezoneadjustednow)#)
		</CFQUERY>
	 	<table cellspacing="3" border="0" align="center" width="400">
		<tr>
		<td align="center" colspan="2" style="font-size:16px;font-weight:bold;color:#336699;">Guest Has Been Edited</td>
		</tr>			
		</table> --->
		<cflocation url="addressbook2.cfm">
	</CFIF>