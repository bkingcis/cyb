<cfparam name="session.signup.timezone" default="pacific">

<cfoutput>
	<form class="form-horizontal" method="post" action="?action=#xfa.submit#" role="form">	
		<fieldset>
			<legend></legend>
			  <div class="form-group">
			  <label for="inputtimezone" class="col-sm-2 control-label">Community Timezone:</label>
				<div class="col-sm-3">
			  		<select name="inputtimezone" type="text" class="form-control">
						<option value="pacific"<cfif session.signup.timezone is 'pacific'> selected="true"</cfif>>US Pacific</option>				
						<option value="mountain"<cfif session.signup.timezone is 'mountain'> selected="true"</cfif>>US Mountian Time</option>	
						<option value="central"<cfif session.signup.timezone is 'central'> selected="true"</cfif>>US Central Time</option>	
						<option value="eastern"<cfif session.signup.timezone is 'eastern'> selected="true"</cfif>>US Eastern Time</option>
				  	</select>
				</div>
			  
			  </div>
		</fieldset>
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="submit" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>