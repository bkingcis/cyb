<cfinclude template="header.cfm">
	<form action="popup/deleteguest.cfm" method="post">
	<div class="alert alert-warning">Are you sure you want to delete this <cfoutput>#labels.visitor#</cfoutput>?</div>
		<cfoutput><input type="hidden" name="g_id" value="#url.g_id#"></cfoutput>
	</form>