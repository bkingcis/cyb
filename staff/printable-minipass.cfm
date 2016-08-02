<cfset timezoneadj = session.timezoneadj>
<cfset request.dsn = datasource>
<cfparam name="attributes.v_id" default="0">
<cfquery datasource="#datasource#" name="GetGV">
	select * from guestvisits where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>
<cfset attributes.g_id = val(getGV.g_id)>
<cfquery datasource="#datasource#" name="qStaff">
	select staff_fname,staff_lname from staff where staff_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetSchedule">
	select * from schedule where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetGuest">
	select * from guests 
	where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetGV.g_id)#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetResident">
	select residents.r_id, residents.h_id, residents.c_id, residents.r_fname, 
	residents.r_lname, residents.r_altphone, residents.r_email, homesite.h_id, 
	homesite.h_lname, homesite.h_address, homesite.h_UNITNUMBER, homesite.h_city, 
	homesite.h_state, homesite.h_zipcode, homesite.h_phone
		from residents, homesite
		where residents.h_id = homesite.h_id AND residents.r_id  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetGuest.r_id)#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetCommunity">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="qDashPassMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
</cfquery>
<cfquery datasource="#datasource#" name="qDashPassMessage2">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage2'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>
<cfoutput>

<div id="printableBox" style="margin: 10px auto 0px auto;width: 400px; height:275px;border:1px dashed black">
	<table cellpadding="5" cellspacing="0" width="100%" align="center">
		<tr>
			<td valign="top" width="50"><img height="50" src="http://www.cybatrol.com/images/cybadash.png"></td>
			<td align="center" valign="top" style="font-size:0.9em;font-family:arial;" nowrap>
			<strong style="font-size: 1.1em;margin-top:5px;">VISITOR: #ucase(GetGuest.g_fname)# #ucase(GetGuest.g_lname)#</strong><br />
			RESIDENT: #ucase(GetResident.r_fname)# #ucase(GetResident.r_lname)#
			</td>
			<td valign="top" align="right" width="50"><img height="50" src="http://www.cybatrol.com/images/cybadash.png"></td>
		</tr>
	</table>				
	<table border="0" width="100%">	
		<tr>
			<td style="text-align: center;color:red; font-family: Arial;">
				<cfif getschedule.g_singleentry eq 1>Single Entry Pass<cfelseif GetGV.g_permanent eq 1>#label.permanent_visitor# Authorized #label.Visitor#</cfif>
			</td>
			<td style="text-align: center;">
			<cfif val(attributes.v_id) and isNumeric(GetGV.g_barcode)>
				<cfhttp url="http://chart.apis.google.com/chart?chs=130x130&cht=qr&chl=#GetGV.g_barcode#&chld=H|0" result="qrcode" getasbinary="yes">
	     		<cfimage  action = "writeToBrowser" source = "#qrcode.filecontent#">						
				<strong>#GetGV.g_barcode#</strong>
			</cfif>
			</td>
			<td style="text-align: center;color:red;font-family: Arial;">
				<cfif getschedule.g_singleentry eq 1>Single Entry Pass<cfelseif GetGV.g_permanent eq 1>#label.permanent_visitor# Authorized #label.Visitor#</cfif>
			</td>
		</tr>
	</table>			
	<table cellpadding="4" cellspacing="0" width="100%" align="center">
		<tr>
			<td valign="bottom" width="50"><img height="50" src="http://www.cybatrol.com/images/cybadash.jppngg"></td>
			<td align="center" style="font-family:arial;font-size:16px;">		
			#GetResident.h_address#
					<cfif len(GetResident.h_unitnumber)><br />Unit: #GetResident.h_unitnumber#</cfif>
			</td>
			<td valign="bottom" align="right" width="50"><img height="50" src="http://secure.cybatrol.com/images/cybadash.png"></td>
		</tr>
	</table>	
</div>

</cfoutput>