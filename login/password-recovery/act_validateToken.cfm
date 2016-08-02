<!--- Step 1:  Is this a resident or staff user account --->
    <cfquery datasource="cybatrol" name="qCheckLoginType">
			select r_id from residents where password_reset_token = <cfqueryparam value="#url.token#" cfsqltype="CF_SQL_VARCHAR" />
      and active = 1
		</cfquery>
		<cfif qCheckLoginType.recordcount>
			<cfset login_type = 'resident'>
		<cfelse>
			<cfquery datasource="cybatrol" name="qCheckLoginType">
				select staff_id from staff where password_reset_token = <cfqueryparam value="#url.token#" cfsqltype="CF_SQL_VARCHAR" />
        and active = 'true'
			</cfquery>
			<cfset login_type = 'staff'>
		</cfif>
		
	
<!--- Step 2:  Get the validated user by token  --->  
    <cfquery datasource="cybatrol" name="qVerifyToken">
			select * from <cfif login_type is 'personnel' or login_type is 'staff'> staff<cfelse> residents</cfif> 
			where password_reset_token = <cfqueryparam value="#url.token#" cfsqltype="CF_SQL_VARCHAR" />
			and <cfif login_type is 'personnel' or login_type is 'staff'> staff_username<cfelse> r_username</cfif> 
      = <cfqueryparam value="#url.username#" cfsqltype="CF_SQL_VARCHAR" />
		</cfquery>
    <cfif qVerifyToken.recordcount>
       <cfif login_type is "personnel" or login_type is "staff">
         <cfset session.s_id = qVerifyToken.staff_id>
       <cfelse>
         <cfset session.r_id = qVerifyToken.r_id>
       </cfif>
    </cfif>