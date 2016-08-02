<!--- <security:master> --->

<cfif not isDefined("session.user_community") OR NOT val(session.user_community)>
	<h1>Session Expired</h1>
<cfelse>

<cfset commMessageObj = createObject( 'component', 'admin.model.commMessage' ) />
<cfset qMessages = commMessageObj.read(url.messageid)>
<!--- 
<cfif qMessages.acknowledgedby eq 0>
	<cfset commMessageObj.acknowledgeAdminMessage(session.userid,url.messageid,session.usercommunity)>
</cfif> --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Cybatrol - Message Read</title>
	<link href="css/styles.css" type="text/css" rel="stylesheet">
	<script>
		function showHide(elementid,dbId){
			var theDiv = document.getElementById(elementid);
			if (theDiv.style.display == 'none'){
				theDiv.style.display = 'block';
				document.getElementById('expand10').innerHTML = '[-]';
			}
			else theDiv.style.display = 'none'; 
				document.getElementById('expand10').innerHTML = '[+]';
		}
	</script>
</head>
<body>

<div align="center">
	<div id="container">
		<cfif not qMessages.recordcount>
		<div style="height:150px;overflow-x:auto;background-color:white;font-family:arial;font-size:10pt;">There is currently no message to view.</div>
		</cfif>
		<cfoutput query="qMessages">
		<div class="formHeader" style="font-family:arial;font-size:11pt;cursor: pointer; cursor: hand;font-size:11px;">#dateFormat(qMessages.messagedate,"m/d/yyyy")# - #TimeFormat(qMessages.messagedate,"h:mm tt")#</div>		
		<div id="msgBody#qMessages.currentrow#" style="height:380px;overflow-x:auto;border:1px solid ##666;background-color:white;font-family:arial;font-size:10pt;">
		<cfif isDefined("qMessages.messageSubject")><br>
		<strong>SUBJECT: #qMessages.messageSubject#</strong>
		<br /><br /></cfif>
		#qMessages.messageText# </div>
		</cfoutput>
		</cfif>
		<!--- <input type="button" style="margin-left:auto;margin-right:auto;font:10px Arial;" value="Close Window" 
	onclick="self.close()"> --->
</div></div>
</body>
</html>
