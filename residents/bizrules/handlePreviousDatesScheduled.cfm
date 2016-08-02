<!--- ##################
Here we attempt to locate guest announcements that overlap with previously scheduled visits.
Any guest that has an existing date (full-day only) will not be able to continue.  All other
guests in this reservation may be scheduled.
################## --->

<cfset breaksRule = False />
<cfparam name="lastITTDate" default="" />
<cfparam name="session.message" default="" />
<cfset guestswithoverlap = '' />
<cfset qmatches = querynew('guestIndex,v_id,g_id')>

<!--- OrderDates:  Incoming Query Object - Lists all new requested dates --->
<!--- allSelected: list of dates as a form value --->
<cfloop from="1" to="#number_of_guests#" index="i">
	<!--- STEP 1: Lets pull dates for the guests being announced --->
	<cfquery datasource="#datasource#" name="qExistingSchedules">
		select s.visit_date,s.v_id,s.g_id from schedule s left join 
		guestvisits GV on GV.v_id = S.v_id
		where   s.g_id = (
			select g_id from guests 
			where g_fname = '#evaluate("form.fname"&i)#'
			and g_lname = '#evaluate("form.lname"&i)#'
			and g_email = '#evaluate("form.email"&i)#'
			and c_id = #session.user_community#
			limit 1
			)
		and s.g_singleentry is null
	</cfquery>
	
	<cfloop query="qExistingSchedules">
		<cfif listFind(allSelected,dateFormat(qExistingSchedules.visit_date,"m/d/yyyy"))>
			<cfset queryAddRow(qMatches,1)>
			<cfset querySetCell(qMatches,'v_id',qExistingSchedules.v_id,qMatches.recordCount)>
			<cfset querySetCell(qMatches,'guestIndex',i,qMatches.recordCount)>
			<cfset querySetCell(qMatches,'g_id',qExistingSchedules.g_id,qMatches.recordCount)>
		</cfif>		
	</cfloop>
	<cfset uniqueV_idList = uniqueValueList(qMatches, "v_id")>
	
	<cfif number_of_guests eq 1 and ListLen(uniqueV_idList) lt 2 and val(uniqueV_IDList)>
		<cflocation addtoken="No" url="modifyschedule2.cfm?g_id=#qMatches.g_id#&v_id=#qMatches.v_id#&messagecode=duplicateEdit">
	</cfif>
</cfloop>
<cfif qMatches.recordcount>
<cfset breaksRule = True />
<cfsavecontent variable="session.message">
<strong><span style="color:red;font-size:16px;">Warning:</span> <br>
Duplicate Guest Announcement<br>
Please Edit Guest(s) From The Home Page Calendar:</strong><br />

<cfoutput query="qMatches" group="v_id">
<div style="border: 1px solid red; margin: 6px 0 10px 0;padding:3px;">
	<strong style="font-size:14px;">#evaluate("form.lname"&qMatches.guestindex)#, #evaluate("form.fname"&qMatches.guestindex)#</strong>
	<table>
		<tr>
		<td valign="top"><cfmodule template="../emailcal.cfm" v_id="#qMatches.v_id#" month="#month(request.timezoneadjustednow)#" hide="events"></td>
		<td valign="top"><cfmodule template="../emailcal.cfm" v_id="#qMatches.v_id#" month="#month(request.timezoneadjustednow)+1#" hide="events"></td>
		<td valign="top"><cfmodule template="../emailcal.cfm" v_id="#qMatches.v_id#" month="#month(request.timezoneadjustednow)+2#" hide="events"></td>
		<td valign="top"><cfmodule template="../emailcal.cfm" v_id="#qMatches.v_id#" month="#month(request.timezoneadjustednow)+3#" hide="events"></td>
		</tr>
	</table>
</div>
</cfoutput>
</cfsavecontent>
</cfif>

<cfscript>
/**
* Returns a list of unique values from a query column.
* 
* @param queryname      Query to scan. (Required)
* @param columnname      Column to use. (Required)
* @param cs      If true, the unique list will check the case of the values. Defaults to false. (Optional)
* @return Returns a string. 
* @author Nick Giovanni (ngiovanni@gmail.com) 
* @version 1, March 27, 2007 
*/
function uniqueValueList(queryName, columnName) {
    var cs = 0; 
    var curRow = 1;
    var uniqueList = ""; 
    
    if(arrayLen(arguments) GTE 3 AND isBoolean(arguments[3])) cs = arguments[3]; 
    
    for(; curRow LTE queryName.recordCount; curRow = curRow +1){
        if((not cs AND not listFindNoCase(uniqueList, trim(queryName[columnName][curRow]))) OR (cs AND not listFind(uniqueList, trim(queryName[columnName][curRow])))){
            uniqueList = ListAppend(uniqueList, trim(queryName[columnName][curRow]));
        }
    }
    return uniqueList; 
}
</cfscript>