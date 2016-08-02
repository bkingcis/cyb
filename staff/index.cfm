<cftry>
<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="/login" addtoken="no">
</cfif>
<cfset tomorrow = dateadd("d",1,request.timezoneadjustednow)>
<cfquery name="getCommunity" datasource="#request.dsn#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="qStaffSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'staffSignInMessage'
	and 	c_id = #val(GetCommunity.c_id)#
	order by messageDate desc,message_id desc
	limit 1
</cfquery>
<cfquery datasource="#datasource#" name="qresidentSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'residentSignInMessage'
	and 	c_id = #GetCommunity.c_id#
	order by messageDate desc
</cfquery>
<cfinclude template="settimes.cfm">
<cfquery name="qEntryPoint" datasource="#request.dsn#">
    select *
    FROM communityentrypoints
    WHERE entrypointid = #val(session.entrypointid)#
</cfquery>
<cfquery name="GetStaff" datasource="#request.dsn#">
	select staff.staff_id, staff.c_id, staff.staff_fname, staff.staff_lname
	from staff
	where staff_id = #session.staff_id#
</cfquery>
<cfset metarefresh = TRUE>
<cfinclude template="include/header5.cfm">
	<!--- 
	<cfinclude template="timelayout.cfm">quick bar of times throughout the day --->
	<cfif NOT getCommunity.dashpass OR 1 eq 1>
		<cfinclude template="include/quickbar.cfm">
	</cfif>
	<cfif getCommunity.dashpass >
		<cfinclude template="frmdashpass.cfm">	<!--- quick dash-pass entry form --->
	</cfif>
			
	<cfif getCommunity.dashpass and NOT getCommunity.checkoutoption>
		<cfinclude template="include/currentAccess.cfm">
		<cfif NOT isDefined('url.viewhour')>
		<cfif val(getCommunity.permanantguests)>
		<cfinclude template="include/247Access.cfm">
		</cfif><!--- end community 24/7 IF block --->
		</cfif>
	<cfelseif getCommunity.dashpass and getCommunity.checkoutoption>
		<cfinclude template="include/currentAccessWithCheckout.cfm">	
		<cfif NOT isDefined('url.viewhour')>
			<cfif val(getCommunity.permanantguests)>
			<cfinclude template="include/247Access.cfm">
			</cfif><!--- end community 24/7 IF block --->
		</cfif>
	<cfelseif getCommunity.checkoutoption>
		<!-- inc include/homePageNoDashPassWithCheckout -->
		<cfinclude template="include/homePageNoDashPassWithCheckout.cfm">
	<cfelse>
		<!-- inc include/homePageNODashpassOption -->
		<cfinclude template="include/homePageNODashpassOption.cfm">
	</cfif>
	<cfif NOT isDefined('url.viewhour')>
			<!-- inc include/homePageSpecialEvents -->
	    <cfinclude template="include/homePageSpecialEvents.cfm">
	</cfif>
	<!--- <cfif getCommunity.parcelpickup> --->
			<!-- inc include/homePageParcelList -->
		<cfinclude template="include/homePageParcelList.cfm">
	<!--- </cfif> --->
	<br />
	
	</div>

		<div style="margin:0 0 15px;padding:0;">
		    <!-- &nbsp;&nbsp;<a href="<cfoutput>#BaseURL#</cfoutput>">
			<img src="<cfoutput>#BaseURL#</cfoutput>/images/footer.gif" width="780" height="32" border="0"></a> -->
		</div>

	</div> <!-- end of mainPanel -->
</div> <!--- end col 2 --->
<div id="col3">
<div id="utility7" class="utilityPanel">
		<div class="inner" style="background-color: #0071be;">
			<cfinclude template="actionlist.cfm">
		</div>
	</div>

<div id="utility4" class="utilityPanel"><div class="inner" style="background-color: #0071be">
<div class="heading">MESSAGE TO PERSONNEL:</div>
<cfoutput><cfif qStaffSignInMessage.recordcount>
	<span style="color:white;">#ucase(qstaffSignInMessage.messageText)#</span>
	<div style="text-align:right;color:##eee;font-size:0.8em;font-weight:100;padding-top:4px;">
	Posted: #dateFormat(qstaffSignInMessage.messageDate,'long')#  #timeFormat(qstaffSignInMessage.messageDate,'h:mm tt')#
	</div>
<cfelse>
	
</cfif></cfoutput>
</div></div>
<div id="utility5" class="utilityPanel"><div class="inner" style="background-color: #0071be">
<div class="heading">MESSAGE TO RESIDENTS:</div>
<cfoutput><cfif qresidentSignInMessage.recordcount>
	<span style="color:white;">#ucase(qresidentSignInMessage.messageText)#</span>
	<div style="text-align:right;color:##eee;font-size:0.8em;font-weight:100;padding-top:4px;">
	Posted: #dateFormat(qresidentSignInMessage.messageDate,'long')#  #timeFormat(qresidentSignInMessage.messageDate,'h:mm tt')#
	</div>
<cfelse>
	
</cfif></cfoutput>
</div></div>
<!---
	<div id="utility6" class="utilityPanel">
		<div class="inner" style="background-color: #0071be;">
			<div class="heading">RESIDENT OPINIONS:</div>
			<cfquery datasource="#datasource#" name="qBB">
				select bb.label,bb.insertdate, r.r_fname, r.r_lname
				from residentBB bb join residents r on bb.r_id = r.r_id
				join communities c on c.c_id = r.c_id
				where  category_id = 99 <!--- the bulletin board category for comments --->
				order by insertdate desc
			</cfquery>
			<cfif qBB.recordcount>
				<cfoutput query="qBB">
				<div class="minicomment">#label#</div>
				<div class="minicomment-bottom">&nbsp;</div>
				<div class="minicommentmeta">#r_fname# #left(r_lname,1)#<!--- <br />
					<em>#dateFormat(insertdate,'m/d/yyyy')# #timeFormat(insertdate)#</em> --->
					<em><cfif dateCompare(dateAdd('d',-1,now()),insertdate) eq 0>
					#timeFormat(insertdate)#<cfelse>#dateFormat(insertdate,'m/d/yyyy')#</cfif></em>
				</div>
				<div class="clr"></div>
				</cfoutput>
			<cfelse>
			
				<div class="minicommentmeta">VELMA WARE:</div>
				<div class="minicomment">"I think it would be a great idea to add a Stop Sign at the gatehouse."</div>
				<div class="minicomment-bottom">&nbsp;</div>
				<div class="minicommentmeta">Posted: September 24, 2015  8:25am</div>
				<div class="clr"><br /></div>

				<div class="minicommentmeta">BARB NELLIS:</div>
				<div class="minicomment">"Great idea, Velma!  I agree."</div>
				<div class="minicomment-bottom">&nbsp;</div>				
				<div class="minicommentmeta">Posted: September 24, 2015  8:49 AM</div>
				<div class="clr"><br /></div>

				<div class="minicommentmeta">JANE TIERNEY:</div>
				<div class="minicomment">"How about a community garage sale this winter?"</div>
				<div class="minicomment-bottom">&nbsp;</div>
				<div class="minicommentmeta">Posted: September 27, 2015  12:42pm</div>
				<!-- <strong style="color:white">** No Comments Posted **</strong> -->
			</cfif>
		</div>
	</div>
	--->
	
	</div> <!-- end of col3 -->
</div> <!-- end of container -->
<cfinclude template="include/footer.cfm">

<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>