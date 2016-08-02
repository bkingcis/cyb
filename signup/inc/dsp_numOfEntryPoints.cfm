<cfparam name="session.signup.SEL_ENTRYPOINTS" default="">
<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<h4><!-- Entry access points are the physical locations available to arriving guests. --></h4>
		<fieldset>
			<legend><small>How many physical entrances (example: front desks, gatehouses) your arriving visitors utilize.</small></legend>
			  <div class="form-group">
				<label for="inputF_NAME" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
				  <select name="sel_entrypoints" type="text" class="form-control" id="sel_entrypoints" name="entrypointcount">
				  	<cfloop from=1 to=5 index=i><option<cfif session.signup.SEL_ENTRYPOINTS eq i> selected="selected"</cfif>>#i#</option>
					</cfloop>
				  </select>
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
