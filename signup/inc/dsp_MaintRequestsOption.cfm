<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfparam name="session.signup.track_maintenance_requests" default="">
<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<h4>Do management (or personnel) at #session.signup.c_name# receive repair requests from residents?</h4>
		<fieldset>
			<legend><small>Add Maintenance Requests:</small></legend>
			 <p style="display:inline-block;max-width:720px;margin-bottom:25px;"></p> 
			<div class="form-group">
				<label for="chk_PackageDropoff" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
					<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="chk_track_maintenance_requests" id="chk_track_maintenance_requests_yes">  Yes
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" name="chk_track_maintenance_requests" id="chk_track_maintenance_requests_no" checked="checked">  No
					 </li>
					</ul>
				</div>
			</div>
		  <fieldset/>		
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>