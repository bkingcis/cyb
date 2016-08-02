<cftry>
<cfsilent>
<cfif form.active is 'true'>
  <cfset paused = 0>
<cfelse>
  <cfset paused = 1>
</cfif>

<cfquery datasource="#request.dsn#" name="qUpdatePaused">
  update guests  
  set g_paused = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#paused#" /> 
  where h_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.h_id#" />
  and g_id = (
    select g_id from guestvisits where v_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.vid#" /> limit 1
  )
</cfquery>
</cfsilent>
<strong>Status saved.</strong>
<cfcatch>
</strong>Status NOT Saved.</strong>  An error occured:<br />
<cfoutput>#cfcatch.detail#</cfoutput>
</cfcatch>
</cftry>