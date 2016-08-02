<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfscript>
 attributes = StructNew();
 attributes.badfields = '';
 request.dsn = datasource;
 if (isDefined("url")) {
	if (isStruct(url)) {
		for (itemURLParam in url)
			evaluate("attributes.#itemURLParam# = url.#itemURLParam#");
		}
	}
 if (isDefined("form")) {
	if (isStruct(form)) {
		for (itemFormParam in form)
			try{
			evaluate("attributes.#itemFormParam# = form.#itemFormParam#");			
			} catch(any excpt) {
				     attributes.badfields = listAppend(attributes.badfields,itemFormParam);
			}
		}
	}
</cfscript>
<cfinclude template="popup/header.cfm">
<div id="popUpContainer">
	<cfif structKeyExists(form,"mon") and val(form.mon) and val(form.day) and val(form.yr)>
		<cfset attributes.allselected = "#form.mon#/#form.day#/#form.yr#">
	</cfif>
<cfparam name="attributes.allselected" default="#dateFormat(now(),"m/d/yyyy")#" />
<cfparam name="attributes.SEARCHCRIT" default="future" />

<cfif left(attributes.allSelected,1) is ",">
<cfset attributes.allSelected = mid(attributes.allSelected,2,len(attributes.allSelected)-1)>
</cfif>

<cfif listLen(attributes.allSelected) EQ 1 OR attributes.searchcrit is 'future' >
	<cfif attributes.allselected is ''>
		<cfset thesearchdate = request.timezoneadjustednow>
	<cfelse>
		<cfset thesearchdate = attributes.allSelected>
	</cfif>

	<cfquery name="getCommunity" datasource="#datasource#">
		select * from communities 
		where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
	</cfquery>
	<cfoutput>
	<h1>#ucase(DateFormat(thesearchdate,'long'))#</h1><br /><br />
		<input type="button" onclick="history.back();" value=": New Search :">
	
	
	<cfif isDefined('form.r_lname')>
	<div align="center" class="staffHeader2">
		
		Search Results For <br />
		
		<cfif len(trim(form.r_lname)) or len(trim(form.r_fname))>Resident:
			<cfif len(trim(form.r_lname))>#ucase(form.r_lname)#</cfif>
			<cfif len(trim(form.r_fname))>, #ucase(form.r_fname)#</cfif><br />
		</cfif>
		<cfif len(trim(form.g_lname)) or len(trim(form.g_fname))>Visitor:
			<cfif len(trim(form.g_lname))>#ucase(form.g_lname)#</cfif>
			<cfif len(trim(form.g_fname))>, #ucase(form.g_fname)#</cfif><br />
		</cfif>
	</div>
	<cfelseif isDefined('form.selResidentID')>
			
	</cfif>
		<!--- <cfdump var="#form#"> --->
	
	</cfoutput>
		<!---<cfif isDefined("searchcrit")>
		<cfif LEN(attributes.allSelected)>
			<table align="center" >
				<cfset request.dsn = datasource>
				<tr><cfset firstmonthshown = month(request.timezoneadjustednow)>
					<cfif month(listFirst(attributes.allSelected)) eq month(request.timezoneadjustednow) - 2><cfset firstmonthshown = month(request.timezoneadjustednow) - 2> <td valign="top"><cf_cal month="#month(request.timezoneadjustednow) - 2#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td></cfif>
					<cfif month(listFirst(attributes.allSelected)) eq month(request.timezoneadjustednow) - 1><cfset firstmonthshown = month(request.timezoneadjustednow) - 1></cfif>
					<cfif month(listFirst(attributes.allSelected)) eq month(request.timezoneadjustednow) - 1 OR firstmonthshown eq month(request.timezoneadjustednow) - 2><td valign="top"><cf_cal month="#month(request.timezoneadjustednow) - 1#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td></cfif>
					<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td>
					<td valign="top"><cf_cal month="#month(request.timezoneadjustednow) + 1#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td>
					<cfif firstmonthshown eq month(request.timezoneadjustednow)><td valign="top"><cf_cal month="#month(request.timezoneadjustednow) + 2#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td>
					<td valign="top"><cf_cal month="#month(request.timezoneadjustednow) + 3#" calendarmode="selector" selectorcolor="eeee77" SELECTEDLIST="#attributes.allSelected#" hide="visitors,events"></td></cfif>
				</tr>
			</table>
		</cfif>
		 <cfoutput>
			<cfif len(trim(attributes.g_lname))>Visitor Last Name: #trim(ucase(attributes.g_lname))#<br /></cfif>
			<cfif len(trim(attributes.g_fname))>Visitor First Name: #trim(ucase(attributes.g_fname))#<br /></cfif>
			<cfif len(trim(attributes.r_lname))>Resident Last Name: #trim(ucase(attributes.r_lname))#<br /></cfif>
			<cfif len(trim(attributes.r_fname))>Resident First Name: #trim(ucase(attributes.r_fname))#<br /></cfif>
		</cfoutput> <cfif searchcrit is "future">
			<cfinclude template="include/search_results_future.cfm">
		<cfelse>
			<cfinclude template="include/search_results_history.cfm">		
		</cfif> 
	</cfif>--->
		<style>
		.datatableHdr  {background-color:#c0c0c0; color: black; font-size: 13px; font-weight: 600;}
		.checkedinRow {background-color:#ccffcc;}
			.checkedinRow td {font-size:10px;}
		.checkedinRowHover {background-color:#efefef;}
			.checkedinRowHover td {font-size:10px;}
		.notcheckedinRow {background-color:#aaeeaa;}
			.notcheckedinRow td {font-size:10px;}
		.notcheckedinRowHover {background-color:#efefef;}
			.notcheckedinRowHover td {font-size:10px;}
		</style>
		<cfif dateCompare(thesearchdate,createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) lt 0>
			<cfinclude template="include/search_results_past.cfm">
		<cfelseif dateCompare(thesearchdate,request.timezoneadjustednow) gt 0>
			<cfinclude template="include/search_results_future.cfm">
		<cfelse>
			<cfinclude template="include/search_results_present.cfm">	
		</cfif> 
	
<cfelse>
	<div style="width:84%;padding:5px;margin: 5px auto 40px auto;text-align:center;">
	<strong>Please select one date for your SINGLE DATE search.</strong>
	</div>
	<input type="button" onclick="self.location='searchbox.cfm';" style="font-weight:600;margin-left:330px;" value="<< Go Back"><br>
</cfif><!--- 
<br />
<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm"> --->

</div>
	
