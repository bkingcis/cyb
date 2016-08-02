<cfquery name="GetCommunity" datasource="#datasource#">
	select * from communities
	WHERE c_id = #session.user_community#
</cfquery>

<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_fname,residents.r_lname,homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode 
	from residents INNER JOIN homesite ON residents.h_id = homesite.h_id
	WHERE r_id = #r_id#
</cfquery>
<cfquery name="GetExpiry" datasource="#datasource#">
	select * from schedule
	WHERE g_id = #g_id#
	AND v_id = #v_id#
	Order By visit_date DESC
</cfquery>
<cfoutput>
<cfset #expiry# = #DateFormat(GetExpiry.visit_date,"MM/DD/YYYY")#>
<CFMAIL TO="#getGuestemail.g_email#" FROM="dashpass@cybatrol.com" SUBJECT="Cybatrol DashPass" TYPE="html" server = "mail.cybatrol.com"  spoolenable = "no">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Cybatrol DashPass</title>
	<style>
	.maintable {border-top:thin solid ##336699;border-bottom:thin solid ##336699;border-left:thin solid ##336699;border-right:thin solid ##336699;}
	.boldunderline {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
	.bigbold {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
	.bottomleft {font-family:Verdana,Arial;border-top:4px solid ##336699;border-bottom:4px solid ##336699;border-left:4px solid ##336699;border-right:4px solid ##336699;font-size:16px;font-weight:bold;}
	.bottomcenter {font-family:Verdana,Arial;border-top:1px solid ##336699;border-bottom:1px solid ##336699;border-left:1px solid ##336699;border-right:1px solid ##336699;font-size:18px;font-weight:bold;}
	</style>
</head>

<body>
<table class="maintable" cellpadding="5" cellspacing="5" width="800" align="center">
				<tr>
				<td align="center" width="33%" valign="top"><div class="boldunderline"><strong><u>GUEST:</u></strong><br>#getGuestemail.g_fname# #getGuestemail.g_lname#<br><br><strong style="color:Red;"><u>EXPIRES:</u><br><cfif #expiry# IS "">PERMANENT GUEST<cfelse>#expiry#</cfif></strong></div></td>
				<td align="center" width="33%"><!--- <img src="#BaseUrl#/uploadimages/#GetCommunity.c_crest#" width="250"> ---></td>
				<td align="center" width="33%" valign="top"><div class="boldunderline"><strong><u>RESIDENT:</u></strong><br>#GetResident.r_fname# #GetResident.r_lname#<br><br>#GetResident.h_address#<br>#GetResident.h_city#,#GetResident.h_state#&nbsp;#GetResident.h_zipcode#</div></td>
				</tr>
				<tr>
				<td align="center" colspan="3"><CF_BarcodeGenerator BarCodeType="1" Barcode="#gid#" Height="50"><br>#gid#</td>
				</tr>
				<tr>
				<td align="center" colspan="3"><div class="bigbold">Please present your "Driver's Permit" at the<br>gatehouse upon your initial visit into the community.</div><br><br>
<div class="boldunderline">~ POSITIVE I.D. IS REQUIRED ~</div></td>
				</tr>
				<tr>
				<td align="center" class="bottomleft"><p>Community Information</p><p>(Speed Limit, Construction, Hazzards, etc.)</p></td>
				<td align="center" class="bottomcenter"><img src="http://secure.cybatrol.com/images/cybadash.jpg" height="120"></td>
				<td align="center" class="bottomleft"><p>Cybatrol<br>DashPass<br>Instructions</p></td>
				</tr>
				</table>

</body>
</html>
</cfmail>
</cfoutput>
