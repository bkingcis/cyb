<!--- <h1>In progress</h1> --->
<!-- file popup/saveaccount.cfm -->
<cfset form.h_id = 99>
<cfquery datasource="#request.dsn#" name="qMasterUser" >
	select h_id,c_id from residents where
	r_id = <cfqueryparam value="#val(session.user_id)#" cfsqltype="CF_SQL_INTEGER">
	and active = 1
</cfquery>

<!--- this is immediately updated with the cfinvoke after initial entry --->
<cfset temp_pass = 'xyz321'>

<cfif LEN(form.r_fname)>

	<cfquery datasource="#request.dsn#">
		insert into residents (c_id,h_id,r_fname,r_lname,r_email,r_altphone,r_username,r_password)
		values (
				 <cfqueryparam value="#val(qMasterUser.c_id)#" cfsqltype="CF_SQL_INTEGER">,
				 <cfqueryparam value="#val(qMasterUser.h_id)#" cfsqltype="CF_SQL_INTEGER">,
				 <cfqueryparam value="#form.r_fname#" cfsqltype="CF_SQL_VARCHAR">,
				 <cfqueryparam value="#form.r_lname#" cfsqltype="CF_SQL_VARCHAR">,
				 <cfqueryparam value="#form.r_email#" cfsqltype="CF_SQL_VARCHAR">,
				 <cfqueryparam value="#form.r_phone#" cfsqltype="CF_SQL_VARCHAR">,
				 <cfqueryparam value="#form.r_email#" cfsqltype="CF_SQL_VARCHAR">,
				 <cfqueryparam value="#temp_pass#" cfsqltype="CF_SQL_VARCHAR">
				 
			)
	</cfquery>
	
	<cfquery datasource="#request.dsn#" name="qNewRes">
		select MAX(r_id) as new_id from residents
	</cfquery>
	
	<cfset result = createObject('component','admin.model.resident').createInitialPass(qnewres.new_id) />
	
	<!--- <cflocation url="account.cfm?newuser=success"> --->
	<div class="container" id="usertable">
		<div class="row">
			<div class="col-md-6 col-sm-6 col-lg-6">
				<div class="resultmsg alert alert-success">New <cfoutput>#labels.other_user#</cfoutput> created.</div>
			</div>
		</div>
	</div>
	
	<script>
	$(function(){
		$('#headerModal').find('#btnContinue').hide();
	});
	</script>
</cfif>