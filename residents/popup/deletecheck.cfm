<cfinclude template="header.cfm">
<cfoutput>
<form action="popup/deleteguestvisit.cfm" method="POST">
	<div class="alert alert-warning">Are you sure you want to delete this guest announcement?</div>
	<input TYPE="hidden" NAME="v_id" VALUE="#v_id#">
	<!--- <div class="modal-footer">
	<input type="submit" class="btn btn-sm btn-primary" value="YES - DELETE THIS GUEST ANNOUNCEMENT">
	</div> --->
</form>
</cfoutput>
</div>
