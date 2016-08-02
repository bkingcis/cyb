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
<cfquery datasource="#datasource#" name="getResident">
	select * from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
</cfquery>
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

<cfinclude template="header.cfm">	
	<div id="popUpContainer">
	<h1><cfoutput>ENTER SPECIAL EVENT: #ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#</cfoutput></h1>
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
		
		<table align="center" style="background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td align="center">	&nbsp;
				</td>
			</tr>
			<tr>
				<td align="center" style="padding-right:5px;"><strong style="color:black;">Special event scheduled successfully.</strong>
				</td>				
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<!--- <cflocation url="jsclosewin.cfm"> --->
	<cfelse>
		<div class="pagebutton" style="text-align: center;">	
		<cfswitch expression="#reason#">	
			<cfcase value="eventtype">
			<strong style="color:white">You must designate the EVENT being scheduled.</strong>
			</cfcase>	
			<cfcase value="toomanydates">
			<strong style="color:white">Please Choose Only One Date.</strong>
			</cfcase>	
			<cfcase value="Duplicate Date Found">
			<strong style="color:white">The Event and Date Selected Is Already In use.</strong>
			</cfcase>
			<cfcase value="End Time Must Be After Start Time">
			<strong style="color:white">End Time Must Be After Start Time.</strong>
			</cfcase>
			<cfcase value="nodateselected">
			<strong style="color:white">You must choose the date from the calendar to successfully schedule an EVENT.</strong>
			</cfcase>
			<cfdefaultcase>
				<cfdump var="#form#">
			</cfdefaultcase>
		</cfswitch>
		<br /><br />
			<input type="button" class="btn" value=" : Go Back : " style="color:red" onclick="history.go(-1);">
		</div>
	
	</cfif>
	
	</div>
	
