<cfcomponent displayname="Resident">
	<cffunction name="create">
		<cfargument name="c_id" required="Yes">
		<cfargument name="h_id" required="Yes">
		<cfargument name="r_fname" required="Yes">
		<cfargument name="r_middleinitial" default="">
		<cfargument name="r_lname" required="Yes">
		<cfargument name="r_altphone" default="">		
		<cfargument name="r_email" required="Yes">
		<cfargument name="r_username" default="">
		<cfargument name="r_password" default="">
		
		<cfquery name="updateAcct" datasource="#request.dsn#">
			INSERT INTO	residents (c_id,h_id,r_fname,r_middleinitial,r_lname,r_altphone,r_email,r_username,r_password)
			VALUES		( #arguments.c_id#, #arguments.h_id#,'#trim(arguments.r_fname)#','#arguments.r_middleinitial#','#trim(arguments.r_lname)#',
				'#arguments.r_altphone#', '#trim(arguments.r_email)#','#trim(arguments.r_email)#','#arguments.r_password#')
		</cfquery>
		<cfquery name="getNewRes" datasource="#request.dsn#">
			SELECT max(r_id) as newID from residents 
		</cfquery>
		<cfreturn getNewRes.newID />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="h_id" required="Yes" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	*
			FROM	residents
			WHERE	h_id = #arguments.h_id#
			ORDER BY	r_id 
		</cfquery>
		<cfreturn get />
	</cffunction>
	<cffunction name="update">
		<cfargument name="r_id" required="Yes">
		<cfargument name="r_fname" required="Yes">
		<cfargument name="r_middleinitial" required="Yes">
		<cfargument name="r_lname" required="Yes">
		<cfargument name="r_altphone" required="Yes">		
		<cfargument name="r_email" required="Yes">
		<cfargument name="r_username" required="No">		
		<cfargument name="r_password" required="No">
		
		<cfquery name="updateAcct" datasource="#request.dsn#">
		UPDATE	residents
		SET		r_fname = '#arguments.r_fname#',
				r_middleinitial = '#arguments.r_middleinitial#',
				r_lname = '#arguments.r_lname#',
				r_altphone = '#arguments.r_altphone#',
				r_email = '#arguments.r_email#',
				r_username = '#arguments.r_email#'
				<cfif isDefined("arguments.r_password")>,
				r_password = '#arguments.r_password#'</cfif>
				
		WHERE	r_id = #arguments.r_id#
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="createInitialPass" returntype="boolean">
		<cfargument name="r_id" required="Yes" />
		<cfset var newPass = lcase(MakePassword())>
		<cfquery name="upd" datasource="#request.dsn#">
			UPDATE residents
			SET r_password = '#newPass#', r_passReset = 0
			WHERE	r_id = #arguments.r_id#
		</cfquery>
		<cfquery name="get" datasource="#request.dsn#">
			SELECT r_password,r_username,r_email 
			FROM residents
			WHERE	r_id = #arguments.r_id#
		</cfquery>
		<cfquery name="getComm" datasource="#request.dsn#">
			SELECT c_name, c_cname
			FROM communities
			WHERE	c_id = #session.user_community#
		</cfquery>
		<cfquery name="getEmailMessage" datasource="#request.dsn#">
			select emailText from emailMessageText
			WHERE	type = <cfqueryparam value="initialemail" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfif get.r_email contains "@">
		<cfset emailtext = replace(getEmailMessage.emailText,'@@username',get.r_username,'all')>
		<cfset emailtext = replace(emailText,'@@password',get.r_password,'all')>
		<cfset emailtext = replace(emailText,'@@communitylink','http://secure.cybatrol.com/residents','all')>
		<cfset emailtext = replace(emailtext,'@@communityname',getComm.c_name,'all')>
		
		<cfmail to="#get.r_email#" from="support@cybatrol.com" subject="New Resident Log-In Information" type="HTML">
		<center>#emailText#</center>		
		</cfmail>
		</cfif>
		<cfreturn true />
	</cffunction>
	<cffunction name="resetPass" returntype="boolean">
		<cfargument name="r_id" required="Yes" />
		<cfset var newPass = lcase(MakePassword())>
		<cfquery name="upd" datasource="#request.dsn#">
			UPDATE residents
			SET r_password = '#newPass#', r_passReset = 0
			WHERE	r_id = #arguments.r_id#
		</cfquery>
		<cfquery name="get" datasource="#request.dsn#">
			SELECT r_password,r_username,r_email 
			FROM residents
			WHERE	r_id = #arguments.r_id#
		</cfquery>
		<cfquery name="getEmailMessage" datasource="#request.dsn#">
			select emailText from emailMessageText
			WHERE	type = <cfqueryparam value="resetemail" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfset emailtext = replace(getEmailMessage.emailText,'@@username',get.r_username,'all')>
		<cfset emailtext = replace(emailText,'@@password',get.r_password,'all')>
		
		<cfmail to="#get.r_email#" from="support@cybatrol.com" subject="Resident Password Reset" type="html">
		<center>#emailtext#</center>
		</cfmail>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="delete">
		<cfquery datasource="#request.dsn#">
			DELETE FROM residents
			WHERE r_id = #arguments.r_id#
		</cfquery>
		<cfreturn True />		
	</cffunction>
	
	<cfscript>
	/**
	 * Generates an 8-character random password free of annoying similar-looking characters such as 1 or l.
	 * 
	 * @return Returns a string. 
	 * @author Alan McCollough (amccollough@anmc.org) 
	 * @version 1, December 18, 2001 
	 */
	function MakePassword()
	{      
	  var valid_password = 0;
	  var loopindex = 0;
	  var this_char = "";
	  var seed = "";
	  var new_password = "";
	  var new_password_seed = "";
	  while (valid_password eq 0){
	    new_password = "";
	    new_password_seed = CreateUUID();
	    for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
	      this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
	      seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
	      switch(seed){
	        case "1": {
	          new_password = new_password & chr(int((this_char mod 9) + 48));
	          break;
	        }
		case "2": {
	          new_password = new_password & chr(int((this_char mod 26) + 65));
	          break;
	        }
	        case "3": {
	          new_password = new_password & chr(int((this_char mod 26) + 97));
	          break;
	        }
	      } //end switch
	    }
	    valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);	
	  }
	  return new_password;
	}
	</cfscript>
	
</cfcomponent>