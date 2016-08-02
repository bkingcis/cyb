<cfoutput query="getGuest">
    <table border="0" cellpadding="1" width="90%">
        <tr>
            <td rowspan="4" width="50">&nbsp;&nbsp;</td>
            <td style="font-weight:bold;color:##336699;font-size:13px;">VISITOR:<br><br></td>
            <td style="font-size:14px;font-weight:600;">#getGuest.g_lname#, #getGuest.g_fname#<br><br></td>
			<td rowspan="4" width="50%" valign="top">
				<table border="0" cellpadding="1">
				<tr>
					<td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">Initial Visit:</td>
					<td style="font-size:13px;" valign="top">#DateFormat(qSchedule.g_initialvisit,"m/d/yyyy")# #TimeFormat(qSchedule.g_initialvisit,"hh:mm:ss tt")#</td>
			    </tr>
				<tr>
					<td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">Actual Visit:</td>
					<td style="font-size:13px;" valign="top"><cfif isdate(qSchedule.g_checkedin[1])>#DateFormat(qSchedule.g_checkedin[1],"m/d/yyyy")# #TimeFormat(qSchedule.g_checkedin[1],"hh:mm:ss tt")#<cfelse>No Visit</cfif></td>
			    </tr>  
				</table>
			</td>
        </tr>
        <tr>
            <td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">RESIDENT:</td>
            <td style="font-size:14px;" valign="top">#getGuest.r_lname#, #getGuest.r_fname#<br>
                #getGuest.h_address#<br>
                #getGuest.h_city#,#getGuest.h_state#&nbsp;#getGuest.h_zipcode#<br>
                Main Phone: #getGuest.h_phone#<br>
                <cfif LEN(getGuest.r_altphone) gt 2>Alt Phone: #getGuest.r_altphone#</cfif>
            </td>
        </tr>
        <tr>
            <td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">DASHPASS:</td>
            <td style="font-size:14px;" valign="top">#qschedule.g_barcode#
            </td>
        </tr>
    </table>
</cfoutput>