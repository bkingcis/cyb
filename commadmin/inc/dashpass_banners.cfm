<cfparam name="residentSignInMessage" default="Default Resident Sign In Message">
<cfparam name="DashPassMessage" default="Default Dash Pass Message">
<cfparam name="staffSignInMessage" default="Default Staff Sign In Message">
<cfparam name="dashDirectMessage" default="Default Dash Direct Message">

<cfif val(qCommunity.dashpass)>	
	<cfquery datasource="#request.dsn#" name="qDashPassMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 10
	</cfquery>  	
	<cfquery datasource="#request.dsn#" name="qDashPassMessage2">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage2'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 10
	</cfquery>	
</cfif>

			<h2>DashPass Messages</h2>
			<p style="font-size:1.2em">DashPass Messages provide visitors with necessary information regarding their visit (re: Speed limits, construction notices, upcoming events...)</p>
			<p><ul>
			<li>
				To add a new message:<br /><br />
					<ol>
			<li>Click inside the message box
			</li>
			<li> Compose a message
			</li>
			<li>Click SAVE CHANGES</li></ol></li></ul></p>
<div class="accordion">
	
<cfif val(qCommunity.dashpass)>
	<div>									
		<h3><a href="#">DashPass Message Box - Left Side (click to edit)</a></h3>
		<div class="bannerForm">		
			<table><tr><td><cfoutput>
			<div id="DashPassMessage" class="wysiwyg">#qDashPassMessage.messageText#</div>
			<div style="float:left; width:225px;">Updated On #dateFormat(qDashPassMessage.messageDate,'long')#</div>
			<div style="float:left"><a href="/admin/messagehistory.cfm?fieldname=DashPassMessage&height=340&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>LEFT BOX PREVIOUS MESSAGES</a></div>
			</cfoutput></td><td valign="top">Example: <br /><img src="/img/DASHPASS.LEFT.png" height="200" /></td></tr></table>
		</div> 
	</div>
	<div>					
		<h3><a href="#">DashPass Message Box - Right Side (click to edit)</a></h3>
		<div class="bannerForm">
			 <table><tr><td>
    		<cfoutput>
			<div id="DashPassMessage2" class="wysiwyg">#qDashPassMessage2.messageText#</div>
			<div style="float:left; width:225px;">Updated On #dateFormat(qDashPassMessage2.messageDate,'long')#</div>
			<div style="float:left"><a href="/admin/messagehistory.cfm?fieldname=DashPassMessage2&height=340&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>RIGHT BOX PREVIOUS MESSAGES</a></div>
			</cfoutput></td><td valign="top">Example: <br /><img src="/img/DASHPASS.RIGHT.png" height="200" /></td></tr></table>
		</div>
	</div><!-- end fourth accordian block -->
	</cfif>
	
</div><!-- end accordian -->