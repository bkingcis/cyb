<!---

/**********************************************************
intelliEdit 
Version:				4.0
Build:					4.0.3/July 15, 2003

Author:					Andrei Oprea
Web:					http://www.oprea.org
Support:				http://forums.oprea.org

Copyright © 2001-2003, Andrei Oprea. All rights reserved.
***********************************************************/
--->


<cfif IsDefined("URL.Action") AND URL.Action EQ "upload">
	<cfset #filefield# = "Form.MyFile">
	
	<cfif IsDefined("Form.inpcatid") AND Form.inpcatid NEQ "">
		<cfif IsDefined("Form.File") AND Form.File NEQ "">
			<cffile action="upload"
	   			destination="#Session.LibraryPath#\#Form.inpcatid#"
	    		nameConflict="makeunique"
	    		fileField="Form.File">
			<cfif File.ClientFileExt NEQ "gif" AND File.ClientFileExt NEQ "jpg" AND File.ClientFileExt NEQ "jpeg">
				<b>Error!</b>
				<br>
				<br>
				<cfoutput>
					File name: #File.ServerFile#
				</cfoutput>
				<cffile action="DELETE" file="#Session.LibraryPath#\#Form.inpcatid#\#File.ServerFile#"> 
				<cflocation url="box_Images.cfm?catid=#Form.inpcatid#">
			<cfelse>
				<cflocation url="box_Images.cfm?catid=#Form.inpcatid#">
			</cfif>
		<cfelse>
			<cflocation url="box_Images.cfm?catid=#Form.inpcatid#">
		</cfif>
	<cfelse>
		<cfif IsDefined("Form.File") AND Form.File NEQ "">
			<cffile action="upload"
	   			destination="#Session.LibraryPath#"
	    		nameConflict="makeunique"
	    		fileField="Form.File">
			<cfif File.ClientFileExt NEQ "gif" AND File.ClientFileExt NEQ "jpg" AND File.ClientFileExt NEQ "jpeg">
				<b>Error!</b>
				<br>
				<br>
				<cfoutput>
					File name: #File.ServerFile#
				</cfoutput>
				<cffile action="DELETE" file="#Session.LibraryPath#\#File.ServerFile#"> 
				<cflocation url="box_Images.cfm">
			<cfelse>
				<cflocation url="box_Images.cfm">
			</cfif>
		<cfelse>
			<cflocation url="box_Images.cfm">
		</cfif>
	</cfif>
</cfif>
