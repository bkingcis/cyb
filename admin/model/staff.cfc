<cfcomponent displayname="Staff">
<cfparam name="passwordEmailsdao" default="#application.passwordEmailsdao#" />

	<cffunction name="create">	
		<cfquery name="updateAcct" datasource="#request.dsn#">
			INSERT INTO	staff (c_id,staff_fname,staff_lname,staff_email,staff_username,active,s_passReset)
			VALUES		( #session.user_community#,'#arguments.staff_fname#','#arguments.staff_lname#','#arguments.staff_email#','#arguments.staff_email#','#arguments.active#',0)
		</cfquery>
		
		<cfquery name="lastEntered" datasource="#request.dsn#">
			select staff_id from staff
			order by staff_id desc limit 1
		</cfquery>
		
		<cfif NOT isDefined("arguments.staff_employeenumber")>
			<cfset arguments.staff_employeenumber = lastEntered.staff_id>
		</cfif>
		
		<cfquery name="updateAcct" datasource="#request.dsn#">
			UPDATE staff set
			staff_employeenumber = '#arguments.staff_employeenumber#'
			where staff_id = #lastEntered.staff_id#
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="Yes" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	*
			FROM	staff
			WHERE	c_id = #arguments.c_id#
			ORDER BY	staff_level desc, active desc, staff_lname, staff_fname
		</cfquery>
		<cfreturn get />
	</cffunction>
	
	<cffunction name="resetPass" returntype="boolean">
		<cfargument name="staff_id" required="Yes" />
		<cfargument name="newOrOld" required="no" />
		
		<cfset var newPass = lcase(MakePassword())>
		<cfquery name="upd" datasource="#request.dsn#">
			UPDATE staff
			SET staff_password = '#newPass#', s_passReset = 0
			WHERE	staff_id = #arguments.staff_id#
		</cfquery>
		<cfquery name="get" datasource="#request.dsn#">
			select staff_email,staff_password,staff_username
			from staff
			WHERE	staff_id = #arguments.staff_id#
		</cfquery>
		
		<cfif isDefined('arguments.newOrOld') and arguments.newOrOld is 'new'>
		<cfset qStaffEmailText = passwordEmailsdao.GetEmailMessageByType('StaffInitialEmail')>
		<cfelse>
		<cfset qStaffEmailText = passwordEmailsdao.GetEmailMessageByType('staffresetemail')>
		</cfif>
		
		<!--- <cftry> --->
		<cfset emailBody = qStaffEmailText.emailText>
		<cfset emailBody = replaceNoCase(emailBody,"@@username",get.staff_username,"all")>
		<cfset emailBody = replaceNoCase(emailBody,"@@password",get.staff_password,"all")>
		<cfmail to="#get.staff_username#" from="support@cybatrol.com" 
		subject="Staff Account Information - Cybatrol" type="html">#emailBody#</cfmail><!--- This is a system generated email.  Please do not reply.

Your account information has been reset.  To login to the community visitor access system please use the following credentials:
username: #get.staff_username#
password: #get.staff_password#

Thank You!

The Cybatrol Staff
		 --->
		
		<cfreturn true />
		<!--- <cfcatch type="any">
			<cfreturn false />
				<cfmail to="bking@fusiondevelopers.com" from="support@cybatrol.com" subject="Staff Account Information - Cybatrol"
					 server = "mail.cybatrol.com"  port = "25" username = "dashpass@cybatrol.com" password = "cybatrol" spoolenable = "yes">This is a system generated email.  Please do not reply.
			
			ERROR ON SEND
			username: #get.staff_username#
			password: #get.staff_password#
			
			
			
			The Cybatrol Staff
					
					</cfmail>
		</cfcatch>
		</cftry> --->
	</cffunction>
	
	<cffunction name="update">		
		<cfquery name="updateAcct" datasource="#request.dsn#">
		UPDATE	staff
		SET		staff_fname = '#arguments.staff_fname#',
				staff_lname = '#arguments.staff_lname#',
				staff_email = '#arguments.staff_email#',
				staff_username = '#arguments.staff_email#',
				active = '#arguments.active#'
				
		WHERE	staff_id = #arguments.staff_id#
		</cfquery>
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