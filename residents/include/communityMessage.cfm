<cfif qresidentSignInMessage.recordcount and not (structKeyExists(cookie,"community_msg_acknowledged") AND cookie.community_msg_acknowledged)>
	<cfoutput>
	<div id="community-msg-alert" class="alert alert-warning" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
	<span aria-hidden="true">&times;</span></button>
		<em>#ucase(qresidentSignInMessage.messageText)#</em>
		(Posted: #dateFormat(qresidentSignInMessage.messageDate,'long')#)
	</div>
	</cfoutput>
</cfif>

<script>
	$('#community-msg-alert').on('closed.bs.alert', function () {
		document.cookie="community_msg_acknowledged=1";
	})
</script>