	<cfoutput>
	  
	<h2 style="font: 16px 'Trebuchet MS', sans-serif;font-weight:bold;">Residents</h2>
		<p>
			<ul>
				<li>Click the PRIMARY RESIDENT NAME to edit details.</li>
				<li>Click the ADDITIONAL USERS to add/edit users and to reset/send passwords.</li>
			</ul>
		</p>
		<div class="accordion">
			<div>
				<h3><a href="##">Current Resident Users</a></h3>
		
				<div style="height:300px;overflow:auto;">
				<table width="100%">
					<tr>
					<th class="community">Primary Resident</th>
					<th>Address</th>
					<th>Additional Users</th>
					<th>Main Phone</th>
				</tr>
					<cfloop query="qHomesites">
						<cfquery  name="qResidents" datasource="#request.dsn#">
							select *
							from residents where h_id = #qHomesites.h_id#	
							AND 	active = 1
						</cfquery>
					<tr class="#iif(qHomesites.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qHomesites.currentrow mod 2,de("dataB"),de("dataA"))#'">
						<td align="center"><a href="forms/homesite.cfm?h_id=#qHomesites.h_id#&height=440&width=440" class="thickbox" style="font-weight:600;">#ucase(qHomesites.h_Lname)#<cfif LEN(trim(qResidents.r_fname[1]))>, #ucase(qResidents.r_fname[1])#</cfif></a></td>
						<td align="center">#h_address#<cfif len(h_unitnumber)> Unit #h_unitnumber#</cfif></td>
						<td align="center"><cfif NOT qHomesites.h_Lname is "Vacant"><a href="forms/residents.cfm?h_id=#qHomesites.h_id#&height=380&width=650" class="thickbox" style="font-weight:600;">View/Edit #qResidents.recordcount-1#/4</a></cfif></td>
						<td align="center">#h_phone#</td>							
					</tr>
					</cfloop>
				</table>
				<p><a href="forms/homesite.cfm?height=440&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Add Primary Resident</a> &nbsp; <a href="forms/homesiteBulk.cfm?height=440&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Bulk Upload</a></p>
		
				<!--- <table width="92%" style="margin-bottom:10px;" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td style="border-bottom:0px;" align="right">
							
							<input type="button" value="Add Address/Unit" onclick="self.location='#request.self#?fa=newHomeSite'"> &nbsp;  
						</td>
					</tr>
				</table>---></cfoutput>
				</div>
			</div><!-- end first accordian block -->
		</div><!-- end of accordian -->	