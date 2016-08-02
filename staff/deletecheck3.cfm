<cfoutput>
<table cellpadding="2" border="0" align="center">
	<tr>
	<FORM ACTION="deleteguest.cfm" METHOD="POST">
	<td align="center">
	Are you sure you want to delete this Visitor?
	<br /><br />
	<INPUT TYPE="hidden" NAME="v_id" VALUE="#url.v_id#">
	<INPUT TYPE="submit" VALUE=" : yes - delete this visitor : " style="color:green;">
	</td>
	</FORM>
	</tr>
	<tr>
	<FORM ACTION="permguest1.cfm" METHOD="POST">
	<td align="center">
	<INPUT TYPE="button" VALUE=" : no - go back : " onclick="history.go(-1);" style="color:red;">
	</td>
	</FORM>
	</tr>
</table>
</cfoutput>
