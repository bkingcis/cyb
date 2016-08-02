<CFIF val(session.user_id) EQ 0>
	<cflocation URL="../residents.cfm">	
<CFELSE>
	<cfset request.dsn = datasource>
	<cfquery datasource="#request.dsn#" name="qEventTypes">
		Select * from CommunityeventTypes
		where c_id = #session.user_community#
		order by label
	</cfquery>
	<script>
		function getIndex(input, arrayData) {
			for (i=0; i<arrayData.length; i++) {
				if (arrayData[i] == input) {
					return i;
				}
			}
			return -1;
		}
		function selectDateBox (boxToUpdate,thedate) {
			$('.preselectedBox').removeClass('preselectedBox').addClass('calDayBox');
			$('#allSelected').val(thedate);
			boxToUpdate.className='preselectedBox';
		}
	</script>
	<cfinclude template="header.cfm">
		<form name="testForm" action="/residents/popup/specialEvent_announce2.cfm" method="post">
		<fieldset><legend><small>1. Select <cfoutput>#labels.special_event#</cfoutput> Date:</small></legend>
			<div class="row" style="overflow:auto">
			<table align="center" border="1" bordercolor="white" class="calTable">
				<tr>
					<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
					<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
					<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
					<!--- <td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td> --->
				</tr>
			</table>
			</div>
			
			<style>
			.selectedBox {background-color: ##ff6}
			.preselectedBox {background-color: ##ff6}
			</style>
			
		</fieldset>
		<cfoutput>
		<script language="JavaScript">
			document.testForm.dateList.options[0]=null; 
		</script>
		<fieldset><legend><small>2. Choose Times:</small></legend>

			<div class="form-group col-sm-offset-2 col-sm-6">	
				<!--- <input id="dateList" value="" name="dateList"> --->
				<select id="dateList" name="dateList" size="1" style="visibility:hidden;"><option value="-">-----------------</option></select>
				
				<label for="hour">Start Time:</label>
				<select class="form-control" name="hour">
					<cfloop from="0" to="23" index="i">
						<cfloop from="0" to="30" step="30" index="m">
						<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
						<cfset ittValue = i & ':' & min>
						<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
						</cfloop>
					</cfloop>
				</select>
					
				<label for="end_hour">End Time:</label>
				<select class="form-control" name="end_hour">
					<cfloop from="0" to="23" index="i">
						<cfloop from="0" to="30" step="30" index="m">
						<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
						<cfset ittValue = i & ':' & min>
						<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
						</cfloop>
					</cfloop>
				</select>
			</div>
			
		</fieldset>
		
		<fieldset><legend><small>3. Choose <cfoutput>#labels.special_event#</cfoutput> Type:</small></legend>

			<div class="form-group col-sm-offset-2 col-sm-10">
				  <cfloop query="qEventTypes">
				  <div class="checkbox">
					<label>
					<input type="radio" name="eventtypeid" value="#qEventTypes.etid#"> #qEventTypes.label#
					</label>
				  </div>
				  </cfloop>
				<input type="hidden" name="allSelected" id="allSelected">	
			</div>
			
		</fieldset>
</form>	
</cfoutput>
</CFIF>