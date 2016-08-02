<cfparam name="dateList" default="" />
<cfif isDefined('form.allSelected'&i)>
	<cfset dateList=evaluate('form.allSelected'&i)>
</cfif>
<cfif not isDefined('form.hour'&i)>
	<cfset SetVariable('form.hour'&i,'')>
</cfif>
<cfoutput>
<cfif i gt 1><tr>
<td colspan="2" style="border-top:1px solid silver;"> &nbsp;</td></tr></cfif>
<tr>
	<td valign="top" align="center">
<!---	<br /><cfif val(i)><strong>Visitor #i#</strong><br /><br /></cfif> --->
		<cfparam name="form.lname#i#" default="">
		<cfparam name="form.fname#i#" default="">
		<strong style="font-size: 1.2em"><span style="color:white;">VISITOR:</span> &nbsp; #evaluate('form.lname'&i)#, #evaluate('form.fname'&i)#</strong> 
		
		<!--- Last Name: ---> <input type="hidden" value="#evaluate('form.lname'&i)#" name="LName#i#" style="margin-left:4px;width: 200px;" maxlength="45" <cfif 1 eq 2 and isDefined('getAddressbook.recordcount') and getAddressbook.recordcount>onclick="return showDataPop(#i#);"</cfif> /><!--- <br/><br /> --->
		<!--- First Name: ---> <input type="hidden" value="#evaluate('form.fname'&i)#"  name="FName#i#" maxlength="45" style="margin-left:4px;width: 200px;" /><br />
		<cfif getCommunity.guestcompanionOption>
			<br />	Plus Guests: <select name="guestcompanioncount#i#" class="form-control"><option>0<option>1<option>2<option>3<option>4</select>
		<cfelse>
			<input type="hidden" name="guestcompanioncount#i#" value="">
		</cfif>
		<input type="hidden"  name="Email#i#">	
		<br />
	</td>
</tr>
<tr>
	<td>
	
	<table border="2" cellpadding="4" bordercolor="##ffffff">
		<cfset request.dsn = datasource>
		<tr>
			<td valign="top"><cf_cal itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>
			<td valign="top"><cf_cal itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cf_cal itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cf_cal itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
		</tr>
	</table>
	</td>
</tr>
<cfif isDefined('url.v_id')>
	<!--- check for previous visits to hide initial time and single entry options below --->
	<cfquery datasource="#datasource#" name="qCheckInitial">
		select * from visits where v_id = <cfqueryparam value="#url.v_id#" cfsqltype="CF_SQL_INTEGER" />
	</cfquery>
<cfelse>
	<cfset qCheckInitial = queryNew('temp')>
</cfif>
<!--- <cfif NOT qCheckInitial.recordcount> We No Longer Restrict Edit on Announcements on Staff Side (2/18/2011) --->
<tr>
	
	<td align="center">		
	<table align="center">
		<tr><td>
	  Arrival Time: 			
			<select name="hour#i#" class="form-control">
			<option value=""> - Choose - </option>
			<cfloop from="0" to="23" index="h">
				<cfloop from="0" to="30" step="30" index="m">
					<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
					<cfset ittValue = h & ':' & min>
					<option value="#ittValue#"<cfif timeFormat(evaluate('form.hour'&i),'h:mm') is '#h#:#min#'> selected="selected"</cfif>><cfif h eq 12>12:#min#pm<cfelseif h gt 12>#evaluate(h-12)#:#min#pm<cfelseif h lt 1>12:#min#am<cfelse>#h#:#min#am</cfif></option>
				</cfloop>
			</cfloop>
			</select>&nbsp;&nbsp;&nbsp;	
		</td>
		<td>&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;	
		<input type="checkbox" name="singleEntry#i#"<cfif isDefined('form.singleEntry#i#') and val(evaluate('form.singleEntry#i#'))> checked="checked"</cfif>> Single Entry Pass&nbsp;&nbsp;
		</td>
		</tr></table><input type="hidden" name="allSelected#i#" id="allSelected#i#" value="#dateList#">
	</td>
</tr>
<!--- </cfif> --->
</cfoutput>