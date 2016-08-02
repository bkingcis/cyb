<cfparam name="ohgsType" default="">
<cfparam name="eventtypeid" default="">
<cfparam name="passed_inspection" default="NO">
<cfif Left(form.allselected,1) is ","><cfset form.allSelected = replace(form.allSelected,",","")></cfif>
<cfinclude template="header.cfm">
	<cfif form.allSelected IS NOT "" 
		AND eventtypeid IS NOT "" 
		AND (ListLen(form.allSelected) IS 1 OR passed_inspection IS "YES")>		<!--- Create New Quesry from DateList to Query and Order--->	    
	    <CFSET DatesListed = QueryNew("DATELIST")>
		<cfloop list="#allSelected#" index="i">
			<cfoutput>
				<!--- <cfif CreateDate(ListGetAt(i,1,"/"),ListGetAt(i,2,"/"),ListGetAt(i,3,"/")) GTE CreateDate(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"))>
				<cfset thisdate = CreateDate(month(i),day(i),year(i))>			 --->   
				<cfset thisDate = i> 
			    <cfset temp = QueryAddRow(DatesListed, 1)>			    
			    <CFSET temp = QuerySetCell(DatesListed, "DATELIST", thisdate)>
				<!--- </cfif> --->
			</cfoutput>
		</cfloop>
		<cfquery name="OrderDates" DBTYPE="query">
			select * from DatesListed
				ORDER BY DATELIST
		</cfquery>
		<cfoutput query="OrderDates" maxrows="1">
		<cfset dayinquestion = DATELIST>
		</cfoutput>		
		
		<!--- End of Ordering Dates--->
		
		<!--- Create ODBC Ready Date and Time for Initial Visit			--->
		<cfset st_time = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  form.hour,  00, 00)>
		<cfset end_time = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  form.end_hour,  00, 00)>
		
		
		<!--- Create ODBC Ready Date and Time for Initial Visit			
		<cfif form.AMPM IS "PM">		    
		    <cfset st_time = #CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  Evaluate(form.hour+12),  form.minute, 00)#>
		<cfelse>
		    <cfset st_time = #CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  form.hour,  form.minute, 00)#>
		</cfif>
		<cfif form.end_AMPM IS "PM">		    
		    <cfset #end_time# = #CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  Evaluate(form.end_hour+12),  form.end_minute, 00)#>
		<cfelse>
		    <cfset #end_time# = #CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  form.end_hour,  form.end_minute, 00)#>
		</cfif>--->
		<!--- End of ODBC Create DATE Time Preperation--->		
			<cfoutput query="OrderDates">
				<cfquery name="GetDuplicates" datasource="#datasource#">
					select * from specialEvents
					where r_id = #session.user_id#
					AND eventDate = #CreateODBCDate(DATELIST)#
					AND eventtypeid = #eventtypeid#
					AND canceled IS null
				</cfquery>
				<cfif GetDuplicates.RecordCount IS 0>
				<cfquery name="insertSchedule" datasource="#datasource#">
					insert into specialEvents
						(r_id,eventdate,starttime,endtime,eventtypeid,c_id)				
						values(#session.user_id#, #CreateODBCDate(DATELIST)#,'#form.hour#','#form.end_hour#',#eventtypeid#,#session.user_community#)
				</cfquery>
				</cfif>
				
			</cfoutput>		
		
		<div class="alert alert-success"><cfoutput>#labels.special_event#</cfoutput> Scheduled</div>
		<script>
			$('#btnContinue').hide();	  
	  		$('#btnBack').hide();
	  		$('#btnClose').hide();
		</script>
	<cfelseif ListLen(form.allSelected) GT 1>
		<div class="alert alert-warning">
			Please Choose Only One Date.
		</div>
		<script>
			$('#btnContinue').hide();	  
	  		$('#btnBack').show();
	  		$('#btnClose').hide();
		</script>
	<cfelseif eventtypeid IS "">
		<div class="alert alert-danger">
		You must designate the <cfoutput>#labels.special_event#</cfoutput> being scheduled.
		</div>
		<script>
			$('#btnContinue').hide();	  
	  		$('#btnBack').show();
	  		$('#btnClose').hide();
		</script>
	<cfelse>
		<div class="alert alert-danger">
			You must choose the date from the calendar to successfully schedule <cfoutput>#labels.special_event#</cfoutput>.
		</div>
		<script>
			$('#btnContinue').hide();	  
	  		$('#btnBack').show();
	  		$('#btnClose').hide();
		</script>
	</cfif>
	
	</div>
	
