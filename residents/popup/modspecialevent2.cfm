<cfparam name="eventtypeid" default="">
<cfparam name="passed_inspection" default="NO">
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
	<div class="alert alert-success">Your event update has been saved.</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
<cfelseif eventtypeid IS "">
	<div class="alert alert-warning">You must designate the EVENT being scheduled:</strong><br>
	<form>
	<input type="button" onClick="window.history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
	</form>
<cfelseif ListLen(form.allSelected) GT 1>
	<div class="alert alert-warning">You must choose only one day only for an EVENT:<br>
	Your selection:<cfoutput> #form.allSelected#</cfoutput>
	</div>
	<form>
	<input type="button" onClick="window.history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
	</form>
	</div>
	<cfinclude template="../footer.cfm">
<cfelse>
	<div class="alert alert-warning">
	<strong>You must choose a date to successfully schedule an EVENT.</strong>
	</div>
	<form>
	<input type="button" onClick="window.history.go(-1)" value=" : go back : " style="background-color:#336699;color:#f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;">
	</form>
</cfif>
	
	
	
