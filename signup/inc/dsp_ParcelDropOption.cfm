<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfparam name="session.signup.PackageDropoff" default="">
<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#" >	
		<h4>Do the personnel who manage the entrance(s) at #session.signup.c_name# accept packages or deliveries for the residents?  (FedEx, UPS...)</h4>
		<fieldset>
			<legend><small>Accept packages at entry point(s):</small></legend>
			 <p style="display:inline-block;max-width:720px;margin-bottom:25px;"></p> 
			<div class="form-group">
				<label for="chk_PackageDropoff" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
					<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="chk_PackageDropoff" id="chk_PackageDropoff_yes">  Yes
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" name="chk_PackageDropoff" id="chk_PackageDropoff_no" checked="checked">  No
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