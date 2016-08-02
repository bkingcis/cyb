<cfparam name="ohgsType" default="">
<cfparam name="eventtypeid" default="">
<cfparam name="passed_inspection" default="True">
<cfparam name="reason" default="" />
	
<cfif Left(form.allselected,1) is ",">
	<cfset form.allSelected = replace(form.allSelected,",","")>	
</cfif>
<cfset DatesListed = QueryNew("DATELIST")>

<cfif isDate(listFirst(form.allSelected))>
	<cfquery name="GetDuplicates" datasource="#datasource#">
		select * from specialEvents
		where r_id = #val(form.r_id)#
		AND eventDate = #CreateODBCDate(listFirst(form.allSelected))#
		AND eventtypeid = #val(eventtypeid)#
		AND canceled IS null
	</cfquery>
<cfelse>
	<cfset GetDuplicates = queryNew('test')>
</cfif>

<cfif ListLen(form.allSelected) gt 1>	
	<cfset passed_inspection = FALSE>
	<cfset reason = "toomanydates">
<cfelseif ListLen(form.allSelected) lt 1>	
	<cfset passed_inspection = FALSE>
	<cfset reason = "nodateselected">
<cfelseif getDuplicates.recordcount>
	<cfset passed_inspection = FALSE>
	<cfset reason = "Duplicate Date Found">
<cfelseif ListFirst(form.hour,":") gt ListFirst(form.end_hour,":")>
	<cfset passed_inspection = FALSE>
	<cfset reason = "End Time Must Be After Start Time">
<cfelseif eventtypeid IS "">
	<cfset passed_inspection = FALSE>
	<cfset reason = "eventtype">
</cfif>
	

<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
<div id="pageBody" style="display:none;z-index:2;" onclick="position:absolute;height:600px;this.style.display:none;document.getElementById('popBox').style.display='none'"><!--- any click on the page should hide the address pop-up --->
</div>
<div style="clear:both;">
</div>	
<br /><br />
	
	<cfif passed_inspection>		<!--- Create New Quesry from DateList to Query and Order--->	    
	   
		<cfset dayinquestion = form.allSelected>	
		<!--- Create ODBC Ready Date and Time for Initial Visit			--->
		<cfset st_time = CreateDateTime(DateFormat(dayinquestion,"YYYY"),  DateFormat(dayinquestion,"MM"),  DateFormat(dayinquestion,"DD"),  form.hour,  00, 00)>
		<cfset end_time = CreateDateTime(DateFormat(dayinquestion,"YYYY"),  DateFormat(dayinquestion,"MM"),  DateFormat(dayinquestion,"DD"),  form.end_hour,  00, 00)>
			
		<cfquery name="insertSchedule" datasource="#datasource#">
			insert into specialEvents
				(r_id,eventdate,starttime,endtime,eventtypeid,c_id,createdByStaffID)				
				values(#form.r_id#, #CreateODBCDate(dayinquestion)#,'#form.hour#','#form.end_hour#',#eventtypeid#,#session.user_community#,#session.staff_id#)
		</cfquery>
		
		<cflocation url="index.cfm">
	<cfelse>
		<div class="pagebutton" style="text-align: center;">	
		<cfswitch expression="#reason#">	
			<cfcase value="eventtype">
			<strong>You must designate the EVENT being scheduled.</strong>
			</cfcase>	
			<cfcase value="toomanydates">
			<strong>Please Choose Only One Date.</strong>
			</cfcase>	
			<cfcase value="Duplicate Date Found">
			<strong>The Event and Date Selected Is Already In use.</strong>
			</cfcase>
			<cfcase value="End Time Must Be After Start Time">
			<strong>End Time Must Be After Start Time.</strong>
			</cfcase>
			<cfcase value="nodateselected">
			<strong>You must choose the date from the calendar to successfully schedule an EVENT.</strong>
			</cfcase>
			<cfdefaultcase>
				<cfdump var="#form#">
			</cfdefaultcase>
		</cfswitch>
		<br />
		<form><br />		
		<input type="button" value=" Go Back " style="color:Red;" onclick="history.back();">
		</form>
		</div>
	</cfif>
	
	
	
	<cfmodule template="actionlist.cfm">
	<cfinclude template="../footer.cfm">
	
