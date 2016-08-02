<cfquery name="getAbook" datasource="#datasource#">
	select * from guests
	where r_id = #url.residentid#
	AND showin_abook = 'TRUE'
	AND g_id not in (select g_id from guestvisits where g_permanent = 'True')
	order by g_lname
</cfquery>
<h2 style="border-bottom:1px solid #666;font-size:16px;font-family: Arial;text-align:center;">GUEST BOOK</h2>
<div style="font-weight:600;font-size:11px;font-family: Arial; margin-left:27px;">LAST, FIRST</div>
<!--- <cfset #nameListv#='<script language="javascript" type="text/javascript">document.write(nameList);</script>'> --->
<!--- <cfset nameListv ="<script language='javascript' type='text/javascript'>document.write(nameList);</script>">
<cfoutput>#nameListv#</cfoutput> --->
<form method=post>
<cfoutput query="getAbook">
	<div style="font-size:11px;font-family: Arial;">
		<input type="radio" name="use" onClick="parent.document.ann2.FName#Number#.value='#jsstringformat(g_fname)#';parent.document.ann2.LName#Number#.value='#jsstringformat(g_lname)#';parent.document.ann2.Email#Number#.value='#g_email#';parent.document.ann2.f_ABUsed.value=parent.document.ann2.f_ABUsed.value + '#g_id#' + ',';parent.document.getElementById('popBox').style.display='none';" <!--- <cfloop list=#nameListv# index=i><cfif #trim(g_id)# EQ #i#>DISABLED</cfif></cfloop> --->>  
		<strong>#ucase(g_lname)#, #ucase(g_fname)#</strong><br>&nbsp;
		<cfif len(g_email)> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (#lcase(g_email)#) </cfif>
	</div>
</cfoutput>
</form>