<cfif qOverlap.recordcount><!---  and not (structKeyExists(cookie,"community_msg_acknowledged") AND cookie.community_msg_acknowledged)> --->
	<cfoutput>
	<div id="overlap-msg-alert" class="alert alert-danger" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
	<span aria-hidden="true">&times;</span></button>
		Overlap alert.....Overlap
	</div>
	</cfoutput>
</cfif>