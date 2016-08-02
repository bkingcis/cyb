<cfinclude template="../header5.cfm"><cfinclude template="include/staffheaderinfo.cfm">
<cfquery name="getResidents" datasource="#datasource#">select r_lname,r_fname,r_id from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and h_id NOT IN (
		select h_id from homesite 
		where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and (softdelete = 1 or h_lname = 'VACANT')
		)
	order by r_lname, r_fname
</cfquery>
	<div style="clear:both;">
	</div><br/><br/>
	<form action="guestAnnounce2.cfm" method="POST" name="annouce">
		<table align="center" style="font-size:11px;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td colspan="3" align="center">
					<div align="center" class="staffHeader1">GUEST ANNOUNCEMENT</div>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">	&nbsp;
				</td>
			</tr>
			<tr>
				<td align="right" style="padding-right:5px;"><strong>&nbsp;CHOOSE RESIDENT:</strong>
				</td>
				<td>
					<select name="r_id"><cfoutput query="getResidents">
						<option value="#getResidents.r_id#">#ucase(getResidents.r_lname)#, #ucase(getResidents.r_fname)#</option></cfoutput>
					</select>
				</td>
				<td>					
					<input type="submit" value="go">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
	<br /><br />
	<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">