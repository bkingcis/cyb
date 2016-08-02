<cfquery name="get" datasource="#request.dsn#">
	SELECT	*
	FROM	residents
	WHERE	h_id = (select h_id from residents where r_id  =  <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_id)#" />)
	AND 	active = 1
	ORDER BY	r_id 
</cfquery>
<cffunction name="isUserPrimary">
	<cfif session.user_id eq get.r_id[1]>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>
<cftry>
	<div class="container" id="usertable">
		<div class="row">
			<div class="col-md-6 col-sm-6 col-lg-6">
				<div class="resultmsg alert alert-success"></div>
			</div>
		</div>
		<!--- <div class="row">
			<div class="col-md-6">		
				<h5 class="modal-title" id="myModalLabel">Existing <cfoutput>#labels.other_users#</cfoutput>:</h5>
			</div>
		</div> --->
		<cfoutput query="get">
		<div class="row">
			<div class="col-sm-4 col-lg-4 col-md-4">#get.r_fname# #get.r_lname#</div>
			<cfif isUserPrimary()>
				<div class="col-sm-2 col-lg-2 col-md-2"><cfif get.currentrow gt 1>
					<button class="btn btn-xs btn-default btnDeleteUser" data-user-id="#get.r_id#"><span class="glyphicon glyphicon-trash"></span> remove</button>
				<cfelse>PRIMARY</cfif></div>
			</cfif>
		</div>
		<p style="height:12px;"></p>
		</cfoutput>
	</div>
	<cfcatch> <cfdump var="#message#"></cfcatch>
</cftry>
<cfif isUserPrimary()>
	<cfif get.recordcount lt 5 >
		<button id="addnewuser" type="button" class="btn btn-success btn-sm">
			<i class="glyphicon glyphicon-plus-sign"></i> New <cfoutput>#labels.other_users#</cfoutput>
		</button>
		
		<div class="container" id="newres_frm">
			<h5 class="modal-title" id="myModalLabel" style="display:hidden">Create New <cfoutput>#labels.other_users#</cfoutput>:</h5>
			<div id="" class="row">
				<div class="col-md-4">
					<form action="/residents/popup/saveaccount.cfm" method="post">
						<div class="form-group">
							<label>Name
								<input type="text" name="r_fname" placeholder="First Name" class="form-control" required data-error="Required"/>
								<input type="text" name="r_lname" placeholder="Last Name" class="form-control" required data-error="Required" />
							</label>
							<div class="help-block with-errors"> &nbsp;</div>
						</div>
						<div class="form-group">
							<label>Email
								<input type="text" name="r_email" placeholder="Email" class="form-control" required data-error="Required" />
							</label>							
							<div class="help-block with-errors"> &nbsp;</div>
						</div>
						<div class="form-group">
							<label>Phone
								<input type="text" name="r_phone" placeholder="Phone" class="form-control" required data-error="Required" />
							</label>
							<div class="help-block with-errors"> &nbsp;</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	
	<cfelse>
	 <p>Maximum <cfoutput>#labels.other_users#</cfoutput> Permitted - 5</p>
	</cfif>
</cfif>
<script>
	$(function(){
		$("#newres_frm").hide();
		$(".resultmsg").hide();
		$('#addnewuser').on('click',function(){
			$("#newres_frm").show();
			$("#usertable").hide();
			$("#addnewuser").hide();
			$('#headerModal').find('#btnContinue')
				.show()
				.text('Add <cfoutput>#labels.other_users#</cfoutput>');	  
		});
		$('.btnDeleteUser').on('click',function(){
			var formdata = {r_id:$(this).data('user-id')};
			var the_r_id = $(this).data('user-id');
			var jqxhr = $.get( 'popup/deleteAccount.cfm', formdata, function( results ) {
				 $('.resultmsg').show()
				   .html(results)
				   .fadeOut(5000);
				   if(!results.indexOf('Account removed')==-1){
				   	alert('looking for closeset');
					$("button['data-user-id=the_r_id']").hide();
				   }
				  // alert(results);
			})
			.fail(function(e) {
				alert( "Page not loaded." + e );
			})
			.always(function() {
				//alert( "finished" );
			});  
		});
	});
</script>