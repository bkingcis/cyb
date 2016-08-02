<cfoutput>
<cfif GetCommunity.DashPass IS 'YES'>
	<div class="form-group">
		<label class="col-md-4 control-label" for="dashpass#i#">DashPass:</label>
		<div class="radio col-md-2">
		  <label>
			<input type="radio" id="dashpass#i#a" name="dashpass#i#" value="gate" checked="checked" />	Gate
		  </label>
		</div>
 		<div class="radio col-md-2">
		  <label>
			<input type="radio" id="dashpass#i#" name="dashpass#i#" value="email" /> Email
		  </label>
		</div>
	</div>
<cfelse>
	<input type="hidden" name="dashpass#i#" value="">
</cfif>
<cfif GetCommunity.KeypunchOption IS 'YES' >
	<div class="form-group">
		<label class="col-sm-2 control-label" for="punchPasschk#i#">PunchPass:</label>
		<div class="col-md-5"><input type="checkbox" id="punchPasschk#i#" name="punchPasschk#i#" onclick="toggleMyPhoneNumber(this,'punchpassNumber#i#')">&nbsp;<input disabled="true" 
		type="text" id="punchpassNumber#i#" name="punchpassNumber#i#" value="10-digit mobile" onfocus="if(this.value=='10-digit mobile')this.value='';" />
		</div>
	</div>
</cfif>

<cfif GetCommunity.DashPass_Map IS 'YES'>
	<input type="radio" name="email_map#i#" value="none" <cfif evaluate("form.email_map"&i) is "none">checked="checked"</cfif>/>&nbsp;None<br>
	<input type="radio" name="email_map#i#" value="email" <cfif evaluate("form.email_map"&i) is "email">checked="checked"</cfif>/>&nbsp;Email
<cfelse>
	<input type="hidden" name="email_map#i#" value="">
</cfif>

<cfif GetCommunity.Entry_Notify IS 'YES'>
	<div class="form-group">
		<label class="col-sm-2 control-label" for="notify#i#"></label>
		<input type="radio" id="notify#i#none" name="notify#i#" value="none" <cfif evaluate("form.notify"&i) is "none">checked="checked"</cfif>/>&nbsp;None<br>
		<input type="radio" id="notify#i#ivisit" name="notify#i#" value="ivisit" <cfif evaluate("form.notify"&i) is "ivisit">checked="checked"</cfif>/>&nbsp;Initial Visit<br>
		<input type="radio" id="notify#i#evisit" name="notify#i#" value="evisit" <cfif evaluate("form.notify"&i) is "evisit">checked="checked"</cfif>/>&nbsp;Every Visit
	</div>
<cfelse>
	<input type="hidden" id="notify#i#none" name="notify#i#" value="">
</cfif>
</cfoutput>