<cfimport prefix="security" taglib="../../admin/security">
<security:community>
<cfif isDefined("form.fa")>
	<cfif form.fa is 'moveout'>
		<cfset result = homeSiteObj.delete(form.h_id)>
		<cfset newID = homeSiteObj.createVacant( argumentCollection=form )>
		<cfset result2 = residentObj.create(session.user_community,newID,'','','Vacant','','') />		
		<cflocation url="../index.cfm##tabs-1" addtoken="no">
	<cfelseif form.fa is 'savehomesite'>	
		<cfset h_phone = form.h_phone_part1 & '.' & form.h_phone_part2 & '.' & form.h_phone_part3>  
		<cfif val(form.h_id)>
			<cfquery name="checkUnit" datasource="#request.dsn#">
				select h_lname from homesite where
				h_id = <cfqueryparam value="#val(form.h_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
			<cfparam name="form.h_notes" default="" />
			<cfset result = homeSiteObj.update(form.c_id,form.h_id,form.h_lname,form.h_address,form.h_unitnumber,form.h_city,form.h_state,form.h_zipcode,"#form.h_phone_part1#.#form.h_phone_part2#.#form.h_phone_part3#",form.h_notes)>
			<cfset result2 = residentObj.update(form.r_id,form.r_fname,form.r_middleinitial,form.h_lname,"#form.r_altphone_part1#.#form.r_altphone_part2#.#form.r_altphone_part3#",form.r_email)>
			<cfif checkUnit.h_lname is 'Vacant'>
				<cfset qCommunity = CommunityObj.read(session.user_community)>
				<cfif isDefined("form.sendWelcomeEmail") and form.sendWelcomeEmail eq 1>
					<cfset result3 = residentObj.createInitialPass(form.r_id)>
				</cfif>
				<cfquery name="updateAcct" datasource="#request.dsn#">
				UPDATE	homesite
				SET		insertdate = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">
				WHERE	h_id = <cfqueryparam value="#val(form.h_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cfif>
		<cfelse>
			<!--- <cfquery name="insHomesite" datasource="#request.dsn#">
			INSERT INTO	homesite (h_lname,h_address,h_unitnumber,h_city,h_state,h_zipcode,h_phone,c_id,h_notes)
			VALUES ('#form.h_lname#','#form.h_address#','#form.h_unitnumber#','#form.h_city#','#form.h_state#',
					 '#form.h_zipcode#','#h_phone#',#form.c_id#,'#form.h_notes#')
			</cfquery> --->
			<cfparam name="form.h_notes" default="" />
			<cfset newHS = homeSiteObj.create(session.user_community,form.h_id,form.h_lname,form.h_address,form.h_unitnumber,form.h_city,form.h_state,form.h_zipcode,"#form.h_phone_part1#.#form.h_phone_part2#.#form.h_phone_part3#",form.h_notes)>
			<cfset result2 = residentObj.create(session.user_community,newHS,form.r_fname,form.r_middleinitial,form.h_lname,"#form.r_altphone_part1#.#form.r_altphone_part2#.#form.r_altphone_part3#",form.r_email)>
			<cfset qCommunity = CommunityObj.read(session.user_community)>
			<cfset result3 = residentObj.createInitialPass(result2)>
		</cfif>
		<cflocation url="../index.cfm##tabs-1" addtoken="no">
	</cfif>
</cfif>
<cfparam name="url.h_id" default="0" />
<script type="text/javascript">
	function saveThisHomesite(obj){
		obj.form.submit();
	}
	function moveOutBtnClick(obj){
		responseFromPrompt = confirm('Are you sure you want to mark this homesite as Vacant?'); 
		if (responseFromPrompt) {
		document.getElementById('fuseaction').value='moveout';
		obj.form.submit();
		}
	}
</script>
<cfinclude template="../../admin/qry_homesite.cfm">

		<cfset qCommunity = CommunityObj.read(session.user_community)>
<cfoutput>
			<!--- <div id="accordionF">
			<div> --->
				<h3><a href="##"><cfif url.h_id eq 0>New<cfelse>Edit</cfif> Address / Unit</a></h3>
				<div>
			<cfif url.h_id neq 0 and isdate(qhomesite.insertdate) and not qhomesite.h_lname is 'vacant'>
			<p style="text-align:right;color:green">Active Account Since #dateFormat(qhomesite.insertdate,"mmmm d, yyyy")#</p>
			</cfif>
			<form name="hsForm" action="forms/homesite.cfm" method="post">
				<input type="Hidden" name="fa" id="fuseaction" value="savehomesite">
				<input type="hidden" name="h_id" value="#qhomesite.h_id#"><!--- homesite id --->
				<input type="hidden" name="r_id" value="#qhomesite.r_id#"><!--- resident id --->
				<input type="hidden" name="c_id" value="#qhomesite.c_id#"><!--- community id --->
				<table  cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							Main Surname<br>
							<input type="text" name="h_lname" id="h_lname" maxlength="60" class="txtField" value="#ucase(qHomesite.h_lname)#">
						</td>
						<td>
							First<br>
							<input type="text" name="r_fname" id="r_fname" maxlength="60" class="txtField" value="#ucase(qHomesite.r_fname)#"><!--- #qHomesite.h_fname# --->
						</td>
						<td>
							M/I<br>
							<input name="r_middleinitial" size="2" maxlength="1" type="text" class="txtField" value="#ucase(qHomesite.r_middleinitial)#">
						</td>
					</tr>
					<tr>
						<td>
							Resident Address<br>
							<input type="text" name="h_address" maxlength="100" class="txtField" value="#qHomesite.h_address#">
						</td>
						<td colspan="2">
							Unit ##<br>
							<input name="h_unitnumber" maxlength="12" type="text" class="txtField" value="#qHomesite.h_unitnumber#">
						</td>
					</tr>
					<tr>
						<td>
							City<br><cfif LEN(trim(qHomesite.h_city))><cfset cityVal = qHomesite.h_city><cfelse><cfset cityVal = qCommunity.c_city></cfif>
							<input type="text" name="h_city" maxlength="60" class="txtField" value="#cityVal#">
						</td>
						<td>
							State<br><cfif LEN(trim(qHomesite.h_state))><cfset stateVal = qHomesite.h_state><cfelse><cfset stateVal = qCommunity.c_state></cfif>
							<input type="text" name="h_state" class="txtField" maxlength="2" value="#stateVal#">
						</td>
						<td>
							Zip Code<br><cfif LEN(trim(qHomesite.h_zipcode))><cfset zipVal = qHomesite.h_zipcode><cfelse><cfset zipVal = qCommunity.c_zipcode></cfif>
							<input type="text" name="h_zipcode" class="txtField" style="width:40px" maxlength="6" value="#zipVal#">
						</td>
					</tr>
					<tr>
						<td>
							Primary Telephone<br>
							<input type="text" name="h_phone_part1" style="width:20px" maxlength="3" value="#listFirst(qHomesite.h_phone,".")#"> 
							<input name="h_phone_part2" type="text" style="width:20px" maxlength="3" value="<cfif listLen(qhomesite.h_phone,".") gt 1>#listGetAt(qHomesite.h_phone,2,".")#</cfif>"> 
							<input name="h_phone_part3" type="text" style="width:25px" maxlength="4" value="<cfif listLen(qhomesite.h_phone,".") gt 2>#listGetAt(qHomesite.h_phone,3,".")#</cfif>"> 
						</td>
						<td colspan="2">
							Email<br>
							<cfif url.h_id neq 0>
							<input type="text" name="disabledemail" id="r_email" class="txtField" maxlength="160" class="txtField" value="#qHomesite.R_EMAIL#" disabled="disabled" />
							<input type="hidden" name="r_email" id="r_email" class="txtField" maxlength="160" value="#qHomesite.R_EMAIL#" />
							<cfelse>
							<input type="text" name="r_email" id="r_email" class="txtField" maxlength="160" class="txtField" value="#qHomesite.R_EMAIL#" />
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							Auxillary Telephone<br>						
							<input type="text" name="R_ALTPHONE_part1" style="width:20px" maxlength="3" value="#listFirst(qHomesite.R_ALTPHONE,".")#"> 
							<input name="R_ALTPHONE_part2" type="text" style="width:20px" maxlength="3" value="<cfif listLen(qhomesite.R_ALTPHONE,".") gt 1>#listGetAt(qHomesite.R_ALTPHONE,2,".")#</cfif>"> 
							<input name="R_ALTPHONE_part3" type="text" style="width:25px" maxlength="4" value="<cfif listLen(qhomesite.R_ALTPHONE,".") gt 2>#listGetAt(qHomesite.R_ALTPHONE,3,".")#</cfif>"> 												
						</td>
					</tr>
				</table>
		
				<cfif NOT ucase(qHomesite.h_lname) is 'VACANT' AND NOT qHomesite.h_lname is ''>
				<input type="button" name="moveout" style="color:red" onclick="moveOutBtnClick(this);" value="Vacate Address / Unit">
				<cfelse>
				<input type="checkbox" name="sendWelcomeEmail" value="1">  Send Welcome Email?<br />
				</cfif>
				<input type="button" style="color:green" onclick="saveThisHomesite(this);" value="Save Address / Unit">
				</form>
		</cfoutput>
		</div>
	<!--- </div> --->
	<cfquery datasource="cybatrol" name="qVacancyHistory">
		select hv.vacancydate, h.h_lname
		from homesitevacancy hv join homesite h on h.h_id = hv.previoushomesiteid
		where hv.homesiteid = <cfqueryparam value="#url.h_id#" cfsqltype="CF_SQL_INTEGER">
		ORDER by vacancydate desc
	</cfquery>
	<cfif qVacancyHistory.recordcount>
	<!--- <div> --->
		<h3><a href="#">Previous Occupant(s)</h3>
		<div style="height:300px;overflow:auto;">		
		<table width="99%" bgcolor="#ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
			<tr>
				<th>Date Removed</th><th>Name</th>
			</tr>
			<cfoutput query="qVacancyHistory">
				<tr class="#iif(qVacancyHistory.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qVacancyHistory.currentrow mod 2,de("dataB"),de("dataA"))#'">
					<td align="left">#DateFormat(qVacancyHistory.vacancydate, "mm/dd/yyyy")# #TimeFormat(qVacancyHistory.vacancydate, "hh:mm:ss tt")#</td>
					<td align="left">#ucase(qVacancyHistory.h_lname)#</td>
				</tr>			
			</cfoutput>
			</table>			
		<!--- </div>
	</div> --->	
	</cfif>	
</div>
