<cfswitch expression="#caller.qCommunity.timezone#">
	<cfcase value="Pacific">
		<cfset timeadjuster = -3>
	</cfcase>
	<cfcase value="Mountain">
		<cfset timeadjuster = -2>
	</cfcase>
	<cfcase value="Central">
		<cfset timeadjuster = -1>
	</cfcase>
	<cfcase value="Eastern">
		<cfset timeadjuster = 0>
	</cfcase>
	<cfcase value="EasternPlus3">
		<cfset timeadjuster = 3>
	</cfcase>
</cfswitch>

<cfoutput>
	<table width="92%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="2"><span style="font-size: 16px;color:black;">#caller.qCommunity.c_name# Administrative Console</span></td>
			<td width="140" align="right">#timeFormat(dateAdd("h",timeadjuster,now()))# #caller.qCommunity.timezone# time<br>
			<br>
			<!--- <a href="admin.cfm?fa=capturehome">Download Capture Software</a><br /> --->
			<img src="/admin/img/CybatrolLogwurl.gif">
			<a href="index.cfm">log out</a></td>
		</tr>
		<!--- <tr>
			<td width="140"><cfif IsDefined("caller.qCommunity.c_crest") and caller.qCommunity.c_crest IS NOT "">
				<img src="/uploadimages/#caller.qCommunity.c_crest#" width="100" hspace="2"><br /></cfif></td>
			<td align="center" valign="bottom"><h3 style="font-family:Arial;font-size:20px;">#caller.qCommunity.c_name# - #caller.qcommunity.c_city#</h3></td>
			<td width="140" align="right"><cfif IsDefined("caller.qCommunity.c_crest") and caller.qCommunity.c_crest IS NOT "">
				<img src="/uploadimages/#caller.qCommunity.c_crest#" width="100" hspace="2"><br /></cfif></td>
		</tr> --->
		<cfif fileExists(expandPath('/uploadimages/#caller.qCommunity.c_crest#')) and 1 eq 2>
		<tr>
			<td colspan="3" align="center"><img src="/uploadimages/#caller.qCommunity.c_crest#" width="200" hspace="2"></td>
		</tr>
		</cfif>
	</table>
</cfoutput>