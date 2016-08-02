<cfsilent>
<cfset reset_response = 'Your password could not be reset at this time.  Please try again.'>
<cfif isDefined("form.pass1") and isDefined("form.pass2") and form.pass1 is form.pass2>
  <cfif isDefined('token')>
    <cfif login_type is 'resident'>
      <cfquery datasource="cybatrol" name="chkToken">
        select r_id from residents 
        where password_reset_token = <cfqueryparam value="#token#" cfsqltype="CF_SQL_VARCHAR" />
      </cfquery>
      <cfif chkToken.recordcount>
         <!--- RESETS IT HERE  --->
         <cfquery datasource="cybatrol" name="chkToken">
            UPDATE residents set r_password = <cfqueryparam value="#pass1#" cfsqltype="CF_SQL_VARCHAR" />,
                                r_passreset = 1
            where password_reset_token = <cfqueryparam value="#token#" cfsqltype="CF_SQL_VARCHAR" />
         </cfquery>
         <cfset reset_response = 'Your password was updated successfully.'>
      <cfelse>
         <cfset reset_response = 'Password Reset Request has Timed out. Your password could not be reset at this time.  Please try again.'>
      </cfif>
    <cfelseif login_type is 'personnel' or login_type is 'staff'>
      <cfquery datasource="cybatrol" name="chkToken">
        select s_id from staff 
        where password_reset_token = <cfqueryparam value="#token#" cfsqltype="CF_SQL_VARCHAR" />
      </cfquery>
      <cfif chkToken.recordcount>
        <!--- RESETS IT HERE  --->
         <cfquery datasource="cybatrol" name="chkToken">
            UPDATE staff set staff_password = <cfqueryparam value="#pass1#" cfsqltype="CF_SQL_VARCHAR" />,
                             s_passreset = 1
            where password_reset_token = <cfqueryparam value="#token#" cfsqltype="CF_SQL_VARCHAR" />
         </cfquery>
         <cfset reset_response = 'Your password was updated successfully.'>
      <cfelse>
         <cfset reset_response = 'Password Reset Request has Timed out. Your password could not be reset at this time.  Please try again.'>
      </cfif>
    </cfif>
  <cfelse>
    <cfset reset_response = 'Invalid token. Your password could not be reset at this time.  Please try again.'>
  </cfif>
<cfelse>
  <cfset reset_response = 'Passwords did not match.'>
</cfif>
</cfsilent>