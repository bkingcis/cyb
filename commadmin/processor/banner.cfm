<cfsilent>
<cfimport prefix="security" taglib="/admin/security">
<security:community>
<cfset result = commMessageObj.insertCommMessage(session.user_community,form.id,form.value)>
</cfsilent><cfoutput>#form.value#</cfoutput>