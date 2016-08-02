	<CFIF session.user_id EQ 0>
	    <cflocation URL="../residents.cfm">
	<CFELSE>
		<cfinclude template="header.cfm">
	    <!--- <cfinclude template="residentsinfo.cfm"> --->
		<cfquery name="getAbook" datasource="#datasource#">
			select * from guests
			where g_id = #url.id#
		</cfquery>
		<div class="modal-body row-fluid">
	
	<h1>Guest Book</h1>
	<h2>Guest Details</h2>
		<table cellspacing="3" border="0" align="center" width="400">
		<form method="post" action="abookedit2.cfm">
		<cfoutput>
		<tr>
		<td>Name (Last/First):</td>
		<td><strong>#ucase(getAbook.g_lname)#, #ucase(getAbook.g_fname)#</strong>
		<input type="hidden" name="g_lname" value="#ucase(getAbook.g_lname)#" size="20"><input type="hidden" name="g_fname" value="#ucase(getAbook.g_fname)#" size="20"></td>
		</tr>
		<!--- <tr>
		<td>First Name</td>
		<td>#ucase(getAbook.g_fname)#</td>
		</tr> --->
		<cfif GetCommunity.DashPass IS 'YES'><tr>
		<td>Guest Email:</td>
		<td><input type="text" name="g_email" value="#getAbook.g_email#" size="20"></td>
		</tr>
		<cfelse><input type="hidden" name="g_email" value="#getAbook.g_email#" size="20">
		</cfif>
		<tr>
		<td>Display Guest in Pop-Up Guest Book:</td>
		<td><input type="radio" name="showin_abook" <cfif getAbook.showin_abook IS "TRUE">checked</cfif> value="YES"> YES <input type="radio" name="showin_abook" <cfif #getAbook.showin_abook# IS "FALSE">checked</cfif> value="NO"> NO</td>
		</tr>
		
		</table>
		<br>
		<br>
		<input type="hidden" name="g_id" value="#getAbook.g_id#">
		</cfoutput>
		<div class="modal-footer">
			<input type="button" value="GO BACK" class="btn btn-default" onclick="self.location='addressbook2.cfm';"> 
			<input type="submit" value="SAVE" class="btn btn-primary">
		</div>
		
		</form>
		</div>
	</CFIF>