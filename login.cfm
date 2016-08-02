<!~--- <cfmail from="bking@fusiondevelopers.com" to="bkingcis@gmail.com" subject="test"> THIS IS A TEST </cfmail>Loaded<cfabort> --->
<cfparam name="session.loginsucc" default="">

<cfif isDefined("form.c_id")>
	<cfquery name="getComm" datasource="#datasource#">
	select c_cname from communities
	where c_active = 'True'
	and c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.c_id)#" />
	</cfquery>
	<cfif getComm.recordcount>
	<cflocation addtoken="No" url="http://#getComm.c_cname#.cybatrol.com/residents.cfm">
	<cfelse>
		<cflocation addtoken="No" url="http://www.cybatrol.com/residents.cfm">
	</cfif>
</cfif>

<cfquery name="getStates" datasource="#datasource#">
	select c.c_id,c.c_name,c.c_state AS commState,s.state,s.abbreviation AS stState
	from communities c, states s
	WHERE c.c_state=s.abbreviation
	AND   c.c_active = 'True'
	order by s.state,c.c_name
</cfquery>

<cfquery name="getComms" datasource="#datasource#">
	select c_id,c_name from communities
	WHERE  c_active = 'True'
	order by c_name
</cfquery>

<div align="center" style="font-weight:bold;font-size:16px;">RESIDENT LOGIN</div><br>

<table cellpadding="3" cellspacing="3" class="login" width="300">	
	<cfif session.loginsucc IS "failed">
	<tr><td style="color:Red;font-weight:bold"><em>Login Failed</em></td></tr>
	<cfset session.loginsucc = ''>
	</cfif>
	<tr class="login">
	<td class="loginbottom">
	<cfif isDefined("session.community")>
	<form action="residents/login.cfm" method=post name="loginForm">
	<input type="hidden" name="c_id" value=<cfoutput>#session.community#</cfoutput>>
	<input type="text" name="username" style="width:190px;margin-left:10px;">&nbsp;Username<br /><br />
	<input type="password" name="password" style="width:190px;margin-left:10px;">&nbsp;Password
	
	<cfelse>
<div align="center">	
<form action="residents.cfm" method=post name="StateForm">
<CF_TwoSelectsRelated
	QUERY="getStates"
	NAME1="state"
	NAME2="c_id"
	VALUE1="commState"
	VALUE2="c_id"
	DISPLAY1="commState"
	DISPLAY2="c_name"
	EMPTYTEXT1="Select State"
	EMPTYTEXT2="Select Community"
	SIZE1="1"
	SIZE2="1"
	AUTOSELECTFIRST="Yes"
	HTMLBETWEEN="<br /><br />"
	FORMNAME="StateForm"><br>
    <br></div>
	</cfif></td>
	</tr>
	<tr class=login>
	<td class="logintop"><input type="Submit" style="color:green" value=" : Continue : "></td>
	</tr>
</table>
</form>