<cfparam name="residentSignInMessage" default="Default Resident Sign In Message">
<cfparam name="DashPassMessage" default="Default Dash Pass Message">
<cfparam name="staffSignInMessage" default="Default Staff Sign In Message">
<cfparam name="dashDirectMessage" default="Default Dash Direct Message">


<style>
    .yui-skin-sam .yui-toolbar-container .yui-toolbar-editcode span.yui-toolbar-icon {
        background-image: url( http://developer.yahoo.com/yui/examples/editor/assets/html_editor.gif );
        background-position: 0 1px;
        left: 5px;
    }
    .yui-skin-sam .yui-toolbar-container .yui-button-editcode-selected span.yui-toolbar-icon {
        background-image: url( http://developer.yahoo.com/yui/examples/editor/assets/html_editor.gif );
        background-position: 0 1px;
        left: 5px;
    }
    .editor-hidden {
        visibility: hidden;
        top: -9999px;
        left: -9999px;
        position: absolute;
    }
    textarea {
        border: 0;
        margin: 0;
        padding: 0;
    }	
    #msgpost_container span.yui-toolbar-insertimage, #msgpost_container span.yui-toolbar-insertimage span.first-child {
        border-color: blue;
		height: 120px;
    }
</style>

<script language="JavaScript">
	
	function viewHistory(fieldname) {
		window.open('messageHistory.cfm?fieldname='+fieldname,'msg','location=0,width=400,height=400,status=1,toolbar=1,scrollbars=1');
	}
	
	function viewMessage(messageid) {
		window.open('readMessage.cfm?messageid='+messageid,'msg','location=0,width=500,height=500,status=1,toolbar=1,scrollbars=1');
	}
	
	function navigateTabs(tab) {
	var navtab1 = document.getElementById('navtab1');
	var navtab2 = document.getElementById('navtab2');
	var navtab3 = document.getElementById('navtab3');
	
			if (tab == '1') {
				window.location='admin.cfm?fa=communityMessages';
		}
		if (tab == '2') {
				window.location='admin.cfm?fa=banners';
				}
				
		if (tab == '3') {
				window.location='admin.cfm?fa=homesites';
				}
				
		if (tab == '4') {
				window.location='admin.cfm?fa=staffhome';
			}
		  
	}
</script>
<ul style="list-style:none;" id="navTabs">
<li class="current" id="navtab1"><a href="#" onclick="navigateTabs(1);">Messages</a></li><!--- <img align="middle" src="img/grey-nav-edge.png" style="margin: -10px -25px 0 0;">--->
<li id="navtab2"><a href="#" onclick="navigateTabs(2);">Banners</a></li>
<li id="navtab3"><a href="#" onclick="navigateTabs(3);">Homesites</a></li>
<li id="navtab4"><a href="#" onclick="navigateTabs(4);">Staff Users</a></li>
</ul>
<div style="clear:both;border-bottom:5px solid #999;margin: 0 11px 0 11px;"></div>
<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
<cfquery datasource="#request.dsn#" name="qNotifications">
        select * from adminMessageContent m join adminMessageRecipients r
		on m.messageid = r.messageid
        order by insertdate desc
    </cfquery>	
<cfoutput>
<!--- <div id="adminmessagebox">
<fieldset style="margin:18px;border: 0px;"><!--- <legend style="font-size: 16px; font-weight:600; font-family:Arial;">Admin Incoming Message</legend> --->
<div style="margin-left:20px;margin-right:20px;padding-top:4px;">
	<cftry>
	<cfif DateDiff("d",now(),qNotification.insertDate) lt 5> 
        <cfset alertstyle = 'Alert'>
    <cfelse>
        <cfset alertstyle = ''>
    </cfif>
		<cfcatch type="any">
		<cfset alertstyle = ''>
		</cfcatch>
	</cftry>
		<div style="text-align:center;font-size:13px;font-weight:600">Incoming Message</div>
	 
		<table width="100%"><tr><th>From Cybatrol, Inc. Admin</th></tr></table>			
		<cfif val(qNotification.messageid)>
		<div id="alertBox" class="homeTabsStyle#alertstyle#">	
		<div id="aboutxTab" style="text-align: right; height: 120px;">
			<div name="messageText" style="background-color:white;height: 110px;overflow: auto;margin:2px;text-align:center;padding:4px;">
            <strong>MESSAGE SENT: #dateFormat(qNotification.insertDate,"m/d/yyyy")# - #TimeFormat(qNotification.insertDate,"h:m tt")#</strong><br />
            ----------------------------------------------------<br />
			<strong>SUBJECT: #qNotification.messageSubject#</strong><br />
			#qNotification.messageText#</div>
		</div>
		<a href="admin.cfm?fa=acknowledgeAdminMessage&messageId=#qNotification.messageid#">hide message</a>
	</div>		</cfif>
    <div style="margin-right:52px;text-align:right">
			<a href="javascript:viewHistory('notification')">View Incoming Message History</a> &nbsp;
    </div>	 	
</div> 
</fieldset>
</div>--->	
<style>
	.emailRead a {
		color: ##666;
		font-weight: 100;
		family: Arial;
	}
	.emailUnread a {
		color: black;
		font-weight: 600;
		family: Arial;
	}
</style>

	<br />
	<div style="text-align:center;font-size:13px;font-weight:600">Messages</div>
	<div class="scrollDiv">
		<table width="100%">
			<tr>
				<th class="community">Date</th>
				<th class="community">Subject</th>
			</tr>
			<cfloop query="qNotifications">
			<tr class="#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#" onclick="viewMessage(#qNotifications.messageid#)" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#'">
				<td width="180" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>"><a href="javascript:viewMessage(#qNotifications.messageid#)" style="font-weight:600;">#dateFormat(qNotifications.insertDate,"m/d/yyyy")# - #TimeFormat(qNotifications.insertDate,"h:m tt")#</a></td>
				<td align="left" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>"><a href="javascript:viewMessage(#qNotifications.messageid#)" style="font-weight:600;">#qNotifications.messageSubject#</a></td>						
			</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>



	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />


	
	
	<br clear="all" />