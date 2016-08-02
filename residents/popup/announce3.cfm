<cfinclude template="../bizrules/newannouncevalidate.cfm">

<cfinclude template="header.cfm">

	<form name="testForm" action="/residents/popup/announce4.cfm" method="post">
	<cfoutput><p><span class="lead">
	<cfif isDefined('qGuest') and qGuest.recordcount>
		#qGuest.g_fname# #qGuest.g_lname#
	<cfelse>
		#form.fname1# #form.lname1#
	</cfif></span><br /><!--- <a href="javascript:alert('in progress')"><i class="glyphicon glyphicon-plus-sign"></i> Add Another Visitor</a> --->
	   
	</p></cfoutput><p>Entry permitted on selected dates - Click ALL that apply</>
	<div class="row" style="overflow:auto">
		<table align="center" border="2" bordercolor="white">
			<cfset request.dsn = datasource>
			<tr>
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors"></td>
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors"></td>	
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors"></td>	
			<!---	<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors"></td> --->
			</tr>
		</table>
	</div>
		<style>
		.selectedBox {background-color: #74dd82}
		.preselectedBox {background-color: #74dd82}
		</style>

<cftry>
	<table align="center" cellpadding="0" cellspacing="0" border="0">
		<!--- <tr>
		<td colspan="2"><div align="center" style="font-weight:bold;padding-bottom:10px;padding-top:15px;">Approximate Arrival Time of Guest(s) on Initial Date</div></td>
		</tr> --->
		<tr>
		<td width="30%" align="left">
			<select name="dateList" size="1" style="visibility:hidden;">
			<option value="-">-----------------</option>
			</select><BR>
			<script language="JavaScript">
			document.testForm.dateList.options[0]=null; 
			</script>
		</td>
		<td width="40%" align="center" style="padding-top:20px;">
		<label for="hour">Arrival Time:</label>
		<cfoutput>
		<cfset nexthr = hour(request.timezoneadjustednow)>
		<cfif minute(request.timezoneadjustednow) gt 0>
			<cfset nextmin = 15>
		</cfif>
		<cfif minute(request.timezoneadjustednow) gt 15>
			<cfset nextmin = 30>
		</cfif>
		<cfif minute(request.timezoneadjustednow) gt 30>
			<cfset nextmin = 45>
		</cfif>
		<cfif minute(request.timezoneadjustednow) gt 45>
			<cfset nextmin = 0>
			<cfset nexthr = nexthr + 1>
			<cfif nexthr gt 23><cfset nexthr = 0></cfif>
		</cfif>
		
		<cfparam name="nextmin" default="0">
		<cfparam name="nexthr" default="0">
		<select class="form-control" name="hour">
		<cfloop from="0" to="23" index="i">
		<cfloop from="0" to="45" step="30" index="m">
		<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
		<cfset ittValue = i & ':' & min>
		<option<cfif i eq nexthr and min eq nextmin> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
		</cfloop>
		</cfloop>
		</select></cfoutput>
		</div>
		</td>
		<td width="30%">&nbsp;</td>
		</tr>
	</table>
<input type="hidden" name="allSelected" id="allSelected">


<cfoutput>
	<cfif isDefined('qGuest') and qGuest.recordcount>
		<input type="hidden" name="G_ID" value="#QGUEST.g_id#">
	<cfelse>
		<cfloop collection="#form#" item="i">	
			<cfif not i is 'fieldnames'>
			<input type="hidden" name="#i#" value="#Evaluate('form.' & i)#">
			</cfif>
		</cfloop>
	</cfif>
</cfoutput>

<cfcatch type="Any"><cfdump var="#cfcatch#"></cfcatch></cftry>
<fieldset/>	
	<!---   <div class="modal-footer">
		  <button type="button" id="btn_back" class="btn btn-sm btn-default"><span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-sm btn-primary">NEXT STEP</button>
	  </div>

<input type="button" value=" back " style="color:Red;" onclick="self.history.back()"></td>
<input type="button" value=" clear date(s) " onclick="self.location.reload();" style="color:Red;"></td>
<input type="submit" value=" submit " style="color:Green;"> --->
</form>
</div>

<script type="text/javascript">
$(function() {
			$('#btn_back').on( "click", function() {
			  window.history.back();
			});
		});
		
		
function getIndex(input, arrayData) {
	for (i=0; i<arrayData.length; i++) {
		if (arrayData[i] == input) {
			return i;
		}
	}
	return -1;
}

function selectDateBox (boxToUpdate,thedate) {
	var listFrmVal = $('#allSelected').val();
	var dateArr = listFrmVal.split( "," );
	var indexOfdate = getIndex(thedate,dateArr);
	
	if (indexOfdate != -1) {
			//alert(thedate + 'to remove');
			boxToUpdate.className='calDayBox';
			dateArr.splice(indexOfdate,1); //adds element to the array			
			$('#allSelected').val(dateArr.join()); //pushes into a list on the hidden form field
	}
	else {
		//alert(thedate + 'to add');
		boxToUpdate.className='selectedBox';
		dateArr.push(thedate); //adds element to the array
		$('#allSelected').val(dateArr.join()); //pushes into a list on the hidden form field
		}
}
</script>
