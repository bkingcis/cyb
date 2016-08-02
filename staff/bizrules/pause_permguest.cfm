<cftry>
<cfsilent>
<cfif form.paused is '1'>
  <cfset paused = 1>
<cfelse>
  <cfset paused = 0>
</cfif>

<cfquery datasource="#request.dsn#" name="qUpdatePaused">
  update guests  
  set g_paused = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#paused#" /> 
  where c_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.user_community#" />
  and g_id = (
    select g_id from guestvisits where v_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.vid#" /> limit 1
  )
</cfquery>
</cfsilent>
<strong>Status saved.</strong>
<cfcatch>
</strong>Status NOT Saved.</strong>  An error occured:<br />
<cfoutput>
#cfcatch.message#<br />
#cfcatch.detail#</cfoutput>
</cfcatch>
</cftry>