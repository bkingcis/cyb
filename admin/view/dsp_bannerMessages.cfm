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

<div  id="loginmessagebox">
<fieldset style="margin:10px;border: 0px;"><!--- <legend style="font-size: 16px; font-weight:600; font-family:Arial;">Sign-In Page Message Center</legend> --->
<cfoutput>
<div class="messageLeft">
		<div style="text-align:center;font-size:13px;font-weight:600">Login Page Banner</div>
	<div class="homeTabsStyle" >
	<cfquery datasource="#request.dsn#" name="qresidentSignInMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'residentSignInMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>
	<script>
     var ResidentSignInEditor = new YAHOO.widget.Editor('ResidentSignInMessageText', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Customize Your Message',
						buttons: [
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true }							   
						]
					}
				]
			}
		});
		ResidentSignInEditor.render();
     </script>
		<div id="aboutTab1" style="text-align: right;">		
			<table width="100%"><tr><th>Resident</th></tr></table>			
			<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="ResidentSignInEditor.saveHTML()">
			<textarea name="messageText" id="ResidentSignInMessageText">#qresidentSignInMessage.messageText#</textarea>
			<input type="hidden" name="fieldname" value="residentSignInMessage"><input type="hidden" name="message_id" value="#qresidentSignInMessage.message_id#">
			<a href="javascript:viewHistory('residentSignInMessage')">view resident message history</a> <input type="submit" value="Save"></form>
		</div>
	</div>
</div>

<div class="messageRight">	
	
		<div style="text-align:center;font-size:13px;font-weight:600">Login Page Banner</div>
	<div class="homeTabsStyle">
	<cfquery datasource="#request.dsn#" name="qstaffSignInMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'staffSignInMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>
    <script>
     var StaffSignInEditor = new YAHOO.widget.Editor('StaffSignInMessageText', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Customize Your Message',
						buttons: [
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true }							   
						]
					}
				]
			}
		});
		StaffSignInEditor.render();
     </script>
		<div id="aboutTab2" style="text-align: right;">
		
			<table width="100%"><tr><th>Staff</th></tr></table>			
			<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="StaffSignInEditor.saveHTML()">
			<textarea name="messageText" id="StaffSignInMessageText">#qstaffSignInMessage.messageText#</textarea>
			<input type="hidden" name="fieldname" value="staffSignInMessage"><input type="hidden" name="message_id" value="#qstaffSignInMessage.message_id#">
			<a href="javascript:viewHistory('staffSignInMessage')">view staff sign-in message history</a> <input type="submit" value="Save"></form>
		</div>							
	</div>
</div>
</fieldset>
</div>

<div id="dashpassmessagebox">
<cfif val(caller.qCommunity.dashpass)>
<fieldset style="margin:10px;border: 0px;"><!--- <legend style="font-size: 16px; font-weight:600; font-family:Arial;">DashPass Messages</legend> --->

<div style="width:620px;margin: 0 auto 0 auto;">
<div class="messageDashPass">
	<!--- <div style="text-align:center;font-size:13px;font-weight:600"></div> --->
	<div class="homeTabsStyle">
	<cfquery datasource="#request.dsn#" name="qDashPassMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>	
    <script>
     var DashPassMessageEditor = new YAHOO.widget.Editor('DashPassMessageText', {
			height: '180px',
			width: '260px',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Customize Your Message',
						buttons: [							
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true }						
						]
					}
				]
			}
		});
		DashPassMessageEditor.render();
     </script>
		<div id="aboutTab3" style="text-align: right;">
			<table width="100%"><tr><th>DashPass Message Box Left</th></tr></table>			
			<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="DashPassMessageEditor.saveHTML()">
			<textarea name="messageText" id="DashPassMessageText" style="width:99%; height: 120px;overflow: auto;margin:2px;font:13px Arial;"><strong style="font-size:16px;">#qDashPassMessage.messageText#</strong></textarea>
			<input type="hidden" name="fieldname" value="DashPassMessage"><input type="hidden" name="message_id" value="#qDashPassMessage.message_id#">
			<a href="javascript:viewHistory('DashPassMessage');">view DashPass message history</a> <input type="submit" value="Save">
            </form>
		</div>
	</div>						
</div>		
<div class="messageDashPass">
	<!--- <div style="text-align:center;font-size:13px;font-weight:600"></div> --->
	<div class="homeTabsStyle">
	<cfquery datasource="#request.dsn#" name="qDashPassMessage2">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage2'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>	
     <script>
     var DashPassMessage2TextEditor = new YAHOO.widget.Editor('DashPassMessage2Text', {
			height: '180px',
			width: '260px',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Customize Your Message',
						buttons: [
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true }							   
						]
					}
				]
			}
		});
		DashPassMessage2TextEditor.render();
     </script>
		<div id="aboutTab4" style="text-align: right;">
			<table width="100%"><tr><th>DashPass Message Box Right</th></tr></table>
			<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="DashPassMessage2TextEditor.saveHTML()">
			<textarea name="messageText" id="DashPassMessage2Text" style="width:99%; height: 120px;overflow: auto;margin:2px;"><strong style="font-size:16px;">#qDashPassMessage2.messageText#</strong></textarea>
			<input type="hidden" name="fieldname" value="DashPassMessage2"><input type="hidden" name="message_id" value="#qDashPassMessage2.message_id#">
			<a href="javascript:viewHistory('DashPassMessage2');">view DashPass message history</a> <input type="submit" value="Save"></form>
		</div>
	</div>						
</div>

</div>

	
	</fieldset>
</cfif>
	</div>
	<br clear="all" /></cfoutput>