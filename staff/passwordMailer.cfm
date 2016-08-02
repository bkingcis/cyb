<cfinclude template="../header.cfm">
<cfparam name="form.user_email" default="">

<cfif form.user_email GT 0>
	<cfquery name="get" datasource="#datasource#">
		SELECT	user_name, user_password, user_email
		FROM	users
		WHERE	user_email = '#form.user_email#'
	</cfquery>
	<cfif get.RecordCount eq 1>
		<cfif mode EQ "test"><cfset tmpEmail = emailAddress>
			<cfelse><cfset tmpEmail = get.user_email></cfif>
		<cfmail from="webmaster@interservent.com" to="#tmpEmail#" subject="InterServe - Lost Password Recovery System">
		Here is your login info for admin section of your web page:
		
		USERNAME:	#get.user_name#
		PASSWORD:	#get.user_password#
		
		Regards,
		</cfmail>
		
		<center><font color="navy" size="-1">
			<b>THANK YOU, YOUR LOGIN INFO WILL BE MAILED TO YOU</b>
			<br><br>If you wont receive your login info within 1 hr please contact <a href="mailto:lamar@citymind.com?subject=Lost Password">webmaster</a>.
		</font></center>
		<cfinclude template="../footer.cfm">
		<cfexit method="EXITTEMPLATE">
	<cfelse>
		<center><font color="navy" size="-2">
			<b>UNABLE TO LOCATE SPECIFIED EMAIL ADDRESS IN THE DATABASE</b>
			<br>If you think you shouldnt get this message please contact <a href="mailto:lamar@citymind.com?subject=Lost Password">webmaster</a>.
		</font></center>
	</cfif>
</cfif>

<form action="passwordMailer.cfm" method="post">
<table align="center" bgcolor="navy" cellpadding="3" cellspacing="1">
	<tr><th colspan="2" class="menu">Password Recovery System</th></tr>
	<tr><td align="right"><font color="navy">Please enter your Email:</font></td><td align="left"><input type="text" name="user_email" size="30" value="<cfset zz=writeoutput(form.user_email)>"></td></tr>
	<tr><td align="center" colspan="2"><input type="submit" value=" SUBMIT "></td></tr>
</table>
</form>
<script language="JavaScript">document.forms[0].elements[0].focus();</script>

<cfinclude template="../footer.cfm">