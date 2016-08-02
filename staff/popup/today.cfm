<cftry>
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
<cfset form.r_id = url.r_id>
<cfinclude template="header.cfm">
<script type="text/javascript">
	$(document).ready(function(){
		$('a').attr('target','_top');
	});
</script>
<cfparam name="attributes.allselected" default="#dateFormat(request.timezoneadjustednow,"m/d/yyyy")#" />
<cfparam name="attributes.SEARCHCRIT" default="present" />

<cfif left(attributes.allSelected,1) is ",">
<cfset attributes.allSelected = mid(attributes.allSelected,2,len(attributes.allSelected)-1)>
</cfif>

<cfif attributes.allselected is ''>
	<cfset thesearchdate = request.timezoneadjustednow>
<cfelse>
	<cfset thesearchdate = attributes.allSelected>
</cfif>
	<cfquery name="getResident" datasource="#datasource#">select r_lname,r_fname,r_id from residents
		where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
		and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.r_id#">
	</cfquery>
	<cfquery name="getCommunity" datasource="#datasource#">
		select * from communities 
		where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
	</cfquery>
<div id="popUpContainer">
	<h1>RESIDENT: <cfoutput>#ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#</cfoutput></h1>
	<cfinclude template="/staff/include/currentAccess.cfm">	
	<cfif val(getCommunity.permanantguests)><cfinclude template="/staff/include/247Access.cfm"></cfif>
	<cfinclude template="/staff/include/search_results_present.cfm">	
	<!--- 	--->
	<cfif isDefined("getCommunity.track_maintenance_requests") and getCommunity.track_maintenance_requests>
	<cfset show_only="active">
	<cfinclude template="/staff/include/maintenance.cfm">
	</cfif>
	
	<cfif isDefined("getCommunity.track_maintenance_requests") and getCommunity.track_maintenance_requests>
	<cfinclude template="/staff/include/parcelList.cfm">
	</cfif>

</div>	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>