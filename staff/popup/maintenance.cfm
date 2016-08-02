 <cftry>
  <cfif structKeyExists(url,'r_id')>
   <cfset form.r_id = url.r_id>
	<cfelseif structKeyExists(form,'r_id')>
   <cfset url.r_id = form.r_id>
	<cfelse>
	 <cfset url.r_id = 0>
   <cfset form.r_id = url.r_id>
  </cfif>
	
  <cfquery datasource="#request.dsn#" name="getResident">
    select r_lname, r_fname from residents
    where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
    and   r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
  </cfquery>

	<cfparam name="url.action" default="listAll" />
	<cfif url.action is 'updateStatus'>
		<cfquery datasource="#request.dsn#" name="getResident">
			update maintenance_request 
			set request_status = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.newstatus#">
			  where  c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
    		and maintenance_request_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.maintenance_request_id#" />
		</cfquery>
		<cfset message = "Status has been updated.">
	<cfelseif structKeyExists(form,'request_title') and structKeyExists(form,'r_id')>
		 <cfquery datasource="#request.dsn#" name="insRequest">
			insert into maintenance_request (r_id,c_id,title,detail,request_date)
			values	(<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">,
					<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#trim(form.request_title)#">,
					<cfqueryparam cfsqltype="CF_SQL_LONGVARCHAR" value="#trim(form.request_details)#">,
					<cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">	)
		</cfquery>
		<cfset message = "Request has been submitted.">
	</cfif>

<cfinclude template="header.cfm">
<script>	
	$(document).ready(function(){
		$('#new-request-content').hide();
		$('#new-request-cta').click(function(e){
			$('#new-request-cta').hide();
			$('#grid-data').hide();
			$('#new-request-content').show();
		});
		
		$('.sel_status').change(function(e){
		 	var $this=$(this);
			var rid = $this.attr('data-rid');
			var requestid =$this.attr('data-request-id');
			var newstatus =$this.val();
			//alert(requestid);
			window.location='maintenance.cfm?action=updateStatus&maintenance_request_id='+requestid+'&newstatus='+newstatus;
		});
	});
</script>

<div id="popUpContainer">
<h1>MAINTENANCE REQUESTS: &nbsp;
	<cfif NOT LEN(getResident.r_lname)> ALL RESIDENTS<cfelse><cfoutput>#ucase(getResident.r_lname)#<cfif LEN(getResident.r_fname)>, #ucase(getResident.r_fname)#</cfif></cfoutput></cfif></h1>
	<div id="grid-data">
	 <cfinclude template="/staff/include/maintenance.cfm">
	</div>
<cfcatch><cfdump var="#cfcatch#"> <cfabort></cfcatch>
 </cftry>
	
	<cfif val(url.r_id)><br />
		<button id="new-request-cta" class="btn" >Create New Maintenance Request</button>

		<div id="new-request-content" style="width:45%; margin:0 auto;">
		 <form action="maintenance.cfm" method="post">
			<cfoutput><input type="hidden" name="r_id" value="#url.r_id#" /></cfoutput>
			<fieldset style="color:white;">
				<div style="font-weight:bold;padding-bottom:10px;">Title:</div>
				<input type="text" name="request_title" ><br />
				 <div style="font-weight:bold;padding-bottom:10px;">Details:</div>
				 <textarea name="request_details" style="width:100%;height: 120px;"></textarea><br /><br />
				<input id="showOptions" class="btn" type="submit" value="Add Maintenance Request">	
			</fieldset>
     </form>
		</div>

  </cfif>

