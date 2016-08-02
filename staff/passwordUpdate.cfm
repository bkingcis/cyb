<cfparam name="passiton" default="NO">

<cfinclude template="../header3.cfm">
	
<cfif passiton IS "NO">
	<div align="center">
	<strong>Your password must be changed to continue.</strong><br><br>	
	Enter your new password and confirmation and click submit.
	<table>
	<form action="passwordUpdate.cfm" method="Post">
	<tr><td><input type="password" size="20" name="password"></td> <td>Password</td>	</tr>
	
	<tr><td><input type="password" size="20" name="password_confirm"></td> <td>Confirm Password</td>	</tr>
	<br>
	<tr><td></td><td><input type="hidden" name="passiton" value="yes">	<input type="submit" value="submit"></td></tr>
	</form>
	</table>
	</div>
<cfelse>
	<cfif NOT form.password is form.password_confirm>	
		<div align="center">Passwords did not match. Please use your browser's back button and try again.</div>
	<cfelse>
		<cfquery name="getPass" datasource="#datasource#">
			update staff
			set staff_password = '#form.password#', s_passReset = 1
			where staff_id = #session.staff_id#			
		</cfquery>
		<div align="center">Your password has been updated successfully.<br>
		<br>
		<a href="index.cfm">Click here to continue</a>.</div>
	</cfif>	
</cfif>

<cfinclude template="../footer.cfm">