<!--- called exclusively by staff/guestdetails.cfm --->
<cfif isDefined("checkinreturncode") and len(trim(checkinreturncode))>
	<h2 style="font-weight:bold;color:#000;font-size:16px;border-bottom:1px solid silver;">Check-in Results:</h2>
	<cfoutput>
	<table border="0" cellpadding="1" style="margin-left:20px;" width="700">
		<tr>
			<td>
			<strong style="color:green;font-size:14px;">
				#checkinreturncode# 
			</strong></td>
		</tr>
	</table>
	</cfoutput>
</cfif>