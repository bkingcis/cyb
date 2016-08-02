<cfif qEntryPoints.recordcount eq 1>
 	<cfset session.entrypointid = qEntryPoints.entrypointid>
	<script language="JavaScript"> top.location.replace("/staff");  </script>
<cfelse>
	<cfoutput>
		<h3>Select your current location:</h3>
		<form action="/staff/index.cfm" method="post" target="_parent" id="entrypoint_frm">
		<ul class="list-group">
			<cfloop query="qEntryPoints">
				<li class="list-group-item ">
					<div class="input-group"> 
					<label class=""><input type="radio" value="#qEntryPoints.entrypointid#" name="entrypointid"> #qEntryPoints.label#</label>
					</div>
				</li>
			</cfloop>
		</ul>
		<br /><br />
		<input type="submit" value="continue" class="btn btn-primary">
		</form> 
	</cfoutput>
</cfif>	