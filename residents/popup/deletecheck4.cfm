<cfinclude template="header.cfm">
<cfoutput>
<form action="/residents/popup/deletespevent.cfm" method="post">
	<div class="alert alert-warning">Are you sure you want to cancel this event?</div>
	<input TYPE="hidden" NAME="specialevent_id" VALUE="#url.specialevent_id#">
</form>
</cfoutput>
</div>
