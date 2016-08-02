<cfparam name="eventtypeid" default="">
<cfparam name="passed_inspection" default="NO">
<cfif left(form.allselected,1) is ",">
	<cfset form.allselected = mid(form.allselected,2,len(form.allselected)-1)>
</cfif>

<cfinclude template="header.cfm">
<div id="popUpContainer">
	<h1>EDIT SPECIAL EVENT</h1>
	<h2 style="font-weight:bold;color:##000;font-size:16px;border-bottom:1px solid silver;"> &nbsp;</h2>



<cfif form.allSelected IS NOT "" 
	AND eventtypeid IS NOT "" 
	AND (ListLen(form.allSelected) IS 1 
	OR passed_inspection IS "YES")>					
		
		<cfquery name="insertSchedule" datasource="#datasource#">
			update specialevents SET
				eventdate = #CreateODBCDate(form.allSelected)#,
				starttime = #CreateODBCDateTime(starttime)#,
				endtime = #CreateODBCDateTime(endtime)#,
				eventtypeid = #val(listfirst(eventtypeid))#
			Where specialevent_id = #form.specialevent_id#	
		</cfquery>
		
		<cflocation url="/staff">
<cfelseif eventtypeid IS "">
	
		<!--- <cfinclude template="residentsinfo.cfm"> --->
		<div align="center" style="font-weight:bold;">You must designate the EVENT being scheduled:</strong><br>
		<form>
		<input type="button" onClick="history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
		</form>
		</div>
	<cfelseif ListLen(form.allSelected) GT 1>
	
		<div align="center" style="font-weight:bold;">You must choose only one day only for an EVENT:<br>
		Your selection:<cfoutput> #form.allSelected#</cfoutput>
		</div><br>
			
		<form>
		<input type="button" onClick="window.history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
		</form>
		</div>
		
	<cfelse>
	
		<!--- <cfinclude template="residentsinfo.cfm"> --->
		<div align="center" style="font-weight:bold;">
		<strong>You must choose a date to successfully schedule an EVENT.</strong><br>
		
		<br>
		
		<form>
		<input type="button" onClick="window.history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
		</form>
		</div>
	</cfif>
	
</div>
	
	
	
