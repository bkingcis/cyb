<cfparam name="residentSignInMessage" default="Default Resident Sign In Message">
<cfparam name="DashPassMessage" default="Default Dash Pass Message">
<cfparam name="staffSignInMessage" default="Default Staff Sign In Message">
<cfparam name="dashDirectMessage" default="Default Dash Direct Message">
<cfquery datasource="#request.dsn#" name="qresidentSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'residentSignInMessage'
	and 	c_id = #session.user_community#
	order by messageDate desc,message_id desc
	limit 1
</cfquery>
<cfquery datasource="#request.dsn#" name="qstaffSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'staffSignInMessage'
	and 	c_id = #session.user_community#
	order by messageDate desc,message_id desc
	limit 1
</cfquery>

			<h2 style="font: 16px 'Trebuchet MS', sans-serif; font-weight:bold;">Message Center</h2>
		<!---	<p><ul>
			<li>
				To add a new message:<br /><br />
					<ol>
					<li>Click inside the message box
					</li>
					<li> Compose a message
					</li>
					<li>Click SAVE CHANGES</li></ol>
				</li>
				 <li>To view past messages, click the button below.</li> 
			</ul>
			</p>--->
		
	
<div class="accordion">
	<h3><a href="##">Control Panel Messages</a></h3>	
	<table><tr>			
		<td>
			<span class="ui-state-default ui-corner-top ui-state-active" style="padding: 7px 5px 5px;">
				<a style="font-size: 12pt;" href="#">Message to Residents</a>
			</span>

			<div class="bannerForm">			
			<cfoutput>
				<div id="residentSignInMessage" class="wysiwyg" style="margin-top:4px">#qresidentSignInMessage.messageText#</div>
				Updated: #dateFormat(qresidentSignInMessage.messageDate,'long')# 			
				<div style="float:right"><br /><a href="/admin/messagehistory.cfm?fieldname=residentSignInMessage&height=340&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>VIEW PREVIOUS MESSAGES TO RESIDENTS</a></div>
				</cfoutput>
			</div>
		</td>
		<td width="40"> &nbsp;  </td>
		<td>
			<span class="ui-state-default ui-corner-top ui-state-active" style="padding: 7px 5px 5px;">
			<a style="font-size: 12pt;" href="#">Message to Personnel</a>
			</span>
			<div class="bannerForm">
				<cfoutput>
				<div id="staffSignInMessage" class="wysiwyg" style="margin-top:4px">#qstaffSignInMessage.messageText#</div> 
				Updated: #dateFormat(qstaffSignInMessage.messageDate,'long')#
				<div style="float:right"><br /><a href="/admin/messagehistory.cfm?fieldname=staffSignInMessage&height=340&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>VIEW PREVIOUS MESSAGES TO PERSONNEL</a></div>
				</cfoutput>
			</div>
		</td>	</tr> </table>

</div>
	