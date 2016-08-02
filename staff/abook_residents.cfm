<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Cybatrol Address Book</title>
	<cfoutput><link rel=stylesheet href=#BaseURL#/site.css></cfoutput>
<!--- <script language="JavaScript">
<!--hide from old browsers
var nameList = parent.document.annouce.f_ABUsed.value;
//-->
</SCRIPT> --->
</head>


<body>
<cfquery name="getAbook" datasource="#datasource#">
	select * from residents
	where c_id = #session.user_community#
	order by r_lname
</cfquery>

<table cellspacing="3" border="0">
<tr>
<td> &nbsp;</td>
<td><strong>Last, First</strong></td>
</tr>
<!--- <cfset #nameListv#='<script language="javascript" type="text/javascript">document.write(nameList);</script>'> --->
<!--- <cfset #nameListv#="<script language='javascript' type='text/javascript'>document.write(nameList);</script>">
<cfoutput>#nameListv#</cfoutput> --->
<form method=post>
<cfoutput query="getAbook">
<tr>
<td><input type="radio" name="use" onClick="parent.document.testForm3.r_fname.value='#ucase(r_fname)#';parent.document.testForm3.r_lname.value='#ucase(r_lname)#';"></td>
<td>#ucase(r_lname)#, #ucase(r_fname)#</td>
<tr></tr>
</cfoutput>
</form>
</table>
</body>
</html>
