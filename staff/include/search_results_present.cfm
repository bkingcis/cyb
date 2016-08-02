<!--- <h1>Present</h1>

Current Day Searched:

Actual Visits (alpha by guest last - Scroll 10) - (sort by visit time)
Authorized Access (alpha by guest last - Scroll 10)
24/7 Guests (alpha by guest last name - Scroll 10)
Special Events (alpha by resident last name - Scroll 10)
	 --->	
	<cfquery name="getCommunity" datasource="#request.dsn#">
		select * from communities 
		where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
	</cfquery>
	<cfset variables.begintime = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),Day(request.timezoneadjustednow))>
	<cfif structKeyExists(form,'JumpBtn') and form.jumpbtn is 'All Activity'>
		<cfset variables.endtime = dateAdd('d',90,variables.begintime)>
	<cfelse>
		<cfset variables.endtime = dateAdd('d',1,variables.begintime)>
	</cfif>
	
	<!--- <cfif isdefined("form.g_lname")><cfset attributes.g_lname = form.g_lname></cfif>
	<cfif isdefined("form.g_fname")><cfset attributes.g_fname = form.g_fname></cfif>
	<cfif isdefined("form.r_lname")><cfset attributes.r_lname = form.r_lname></cfif>
	<cfif isdefined("form.r_fname")><cfset attributes.r_fname = form.r_fname></cfif> --->
	<cfparam name="attributes.searchcrit" default="today">
	<cfparam name="thesearchdate" default="#request.timezoneadjustednow#">
	<cfparam name="attributes.g_lname" default="">
	<cfparam name="attributes.g_fname" default="">
	<cfparam name="attributes.r_lname" default="">
	<cfparam name="attributes.r_fname" default="">
	<cfparam name="attributes.r_id" default="">
	
	<cfif structKeyExists(url,"r_id")><cfset attributes.r_id = url.r_id></cfif>
	
	<cfif attributes.searchcrit neq 'future'>
	<cfimport taglib="../model" prefix="m">
	 <m:getvisits thedate="#thesearchdate#" 
	 	g_lname="#attributes.g_lname#" 
		g_fname="#attributes.g_fname#" 
		r_lname="#attributes.r_lname#" 
		r_fname="#attributes.r_fname#" 
		r_id="#attributes.r_id#">
	 <cfif qvisits.recordcount>
	 	
			<cfif isDefined('limit') AND limit eq 1>
				<cflocation url="/staff/guestdetails.cfm?g_id=#qvisits.g_id#&v_id=#qvisits.v_id#">
			</cfif>
		<h2>RECORDED VISITS</h2>
	<cfoutput> <p style="color:white;"> Viewing:  Results for #dateFormat(thesearchdate,"m/d/yyyy")#</p> </cfoutput>

		<div class="homePageDatagrid">
				<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">
			
			<tr>
			<td class="datatableHdr" align="center">Visitor Name<!--- /Company Name ---> (L/F)</td>
			<td class="datatableHdr" align="center">Resident Name</td>
			<td class="datatableHdr" align="center">Resident Phone</td>
			<td class="datatableHdr" align="center">Address</td>
			<td class="datatableHdr" align="center" width="60">Time</td>
			<td class="datatableHdr" align="center">Entry Point</td>
			<td class="datatableHdr" align="center">Personnel</td>
			<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
			 --->
			</tr>			
			<tbody>
			<cfparam name="limit" default="100">
			<cfoutput query="qvisits" maxrows="#limit#">
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td style="font-size:10px;">&nbsp;<a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
					<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)#</td>
					<td style="font-size:10px;" align="center">#h_phone#</td>
					<td style="font-size:10px;" align="center">#h_address#</td>
					<td style="font-size:10px;" align="center">#TimeFormat(qvisits.g_checkedin,"hh:mm:ss tt")#</td>
					<td style="font-size:10px;" align="center">#entryPoint#</td>
				  <td style="font-size:10px;" align="center">#recorded_by#</td>
				</tr>
			</cfoutput>
			</tbody>
		</table>
		</div> 
		
		</cfif>
	</cfif>		
	<!---
	<cfif getCommunity.dashpass and NOT getCommunity.checkoutoption>
		<cfinclude template="currentAccess.cfm">
		<cfif NOT isDefined('url.viewhour')>
		<cfif val(getCommunity.permanantguests)>
		<cfinclude template="247Access.cfm">
		</cfif><!--- end community 24/7 IF block --->
		</cfif>
	<cfelseif getCommunity.dashpass and getCommunity.checkoutoption>
		<cfinclude template="currentAccessWithCheckout.cfm">	
		<cfif NOT isDefined('url.viewhour')>
			<cfif val(getCommunity.permanantguests)>
			<cfinclude template="247Access.cfm">
			</cfif><!--- end community 24/7 IF block --->
		</cfif>
	<cfelseif getCommunity.checkoutoption>
		<cfinclude template="homePageNoDashPassWithCheckout.cfm">
	<cfelse>
		<cfinclude template="homePageNODashpassOption.cfm">
	</cfif>
	<cfif NOT isDefined('url.viewhour')>
	   <cfif NOT LEN(attributes.g_lname) AND NOT LEN(attributes.g_fname)>
	    <cfinclude template="homePageSpecialEvents.cfm">
	   </cfif>
	</cfif>
	
	
	    <cfinclude template="homePageparcelList.cfm">
	 ---> 