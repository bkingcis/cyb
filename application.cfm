<cfinclude template="config.cfm">

<CFAPPLICATION 	NAME="#apName#" 
				SESSIONMANAGEMENT="yes" 				
				setclientcookies="yes"
				clientmanagement="yes">
<cfset Session.LibraryPath = LibraryUpload>
<cfset Session.LibraryURL = LibraryURL>
<cfparam name="session.user_id" default="0">
<cfparam name="session.Stylesheet" default="http://secure.cybatrol.com/site.css">
<cfparam name="session.TIMEZONEADJ" default="0">
