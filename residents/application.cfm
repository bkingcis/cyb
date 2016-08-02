<cfinclude template="../config.cfm">
<cfapplication	name="#apName#"
				sessionmanagement="Yes"
				setclientcookies="No"
				sessiontimeout="#CreateTimeSpan(0,0,100,0)#">
				
<cfparam name="session.timezoneadj" default="0">
<cfscript>
   application.respref = '';
   application.respath = '';
   application.absroot = '';
   request.timezoneadjustednow  = dateAdd('h',session.timezoneadj,now());
</cfscript>
