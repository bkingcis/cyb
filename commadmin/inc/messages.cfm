<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
		<cfquery datasource="#request.dsn#" name="qNotifications">
	        select * from adminMessageContent m join adminMessageRecipients r
			on m.messageid = r.messageid
			where r.c_id =  #session.user_community#
	        order by insertdate desc
	    </cfquery>	
		<cfoutput>
		<div class="accordion">
		<div >
			<h3><a href="##">Messages</a></h3>
			<div style="height:320px;overflow:auto;">
		<table width="100%">
			<tr>
				<th class="community">Date</th>
				<th class="community">Subject</th>
			</tr>
			<cfloop query="qNotifications">
			<tr class="#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#" onclick="viewMessage(#qNotifications.messageid#)" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#'">
				<td align="center" width="180" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>">#dateFormat(qNotifications.insertDate,"m/d/yyyy")# - #TimeFormat(qNotifications.insertDate,"h:mm tt")#</td>
				<td align="center" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>"><a href="forms/readMessage.cfm?messageid=#qNotifications.messageid#&height=440&width=440" class="thickbox" style="font-weight:600;">#qNotifications.messageSubject#</a></td>						
			</tr>
			</cfloop>
		</table>
		</cfoutput></div>
		</div>
		</div>