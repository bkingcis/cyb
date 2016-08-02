<cfset timezoneadj = session.timezoneadj>
<cfparam name="alertPass" default="NO">
<cfparam name="i" default="1">

<cfif session.user_id EQ 0>
	<cflocation URL="/index.cfm">	
</cfif>
<cfinclude template="header.cfm">
	<cfif structKeyExists(form,"v_id")><cfset url.v_id = form.v_id></cfif>
	<cfif structKeyExists(url,"v_id")><cfset form.v_id = url.v_id></cfif>
	<cfif structKeyExists(url,"specialevent_id")><cfset form.specialevent_id = url.specialevent_id></cfif>
	<cfif structKeyExists(form,"specialevent_id")><cflocation url="/residents/popup/modspecialevent.cfm?specialevent_id=#form.specialevent_id#"></cfif>

<cfif NOT structKeyExists(form,"v_id")>
	<cfquery name="getAllVisitors" datasource="#datasource#">
		SELECT gv.v_id,g.g_fname,g.g_lname from guestvisits gv 
		join schedule s on s.v_id = gv.v_id
		join guests g on g.g_id = gv.g_id
		where s.visit_date = '#calDate#'
		and s.r_id = #val(session.user_id)#
		and s.h_id = #val(session.h_id)#
	</cfquery>
	<script>
		$(".modal-body").on('click','input:radio',function(){
			$this=$(this);
			$(".modal-body").find("input:radio:checked").not($this).prop('checked',false);
		})
	</script>
	<cfif getAllVisitors.recordcount><h4>Choose <cfoutput>#labels.visitor#</cfoutput>:</h4></cfif>
	<form method="post" action="/residents/popup/modifyschedule2.cfm">
		<ul class="list-group">	
			<cfoutput query="getAllVisitors">
			<li class="list-group-item"><input type="radio" name="v_id" value="#getAllVisitors.V_ID#" id="vid_#getAllVisitors.V_ID#"> #getAllVisitors.g_fname# #getAllVisitors.g_lname# </li>
			</cfoutput>
		</ul>
	
		<cfoutput><input type="hidden" name="caldate" value="#caldate#"></cfoutput>
	
		<cfquery name="getEvent" datasource="#datasource#">
			select e.specialevent_id, t.label from specialevents  e join CommunityeventTypes t on e.eventtypeid = t.etid
			Where r_id = #val(session.user_id)#	 
			and eventdate  = '#calDate#'	
		</cfquery>
		<cfif getEvent.recordcount>
	<h4>Choose Event:</h4>
			<ul class="list-group">	
				<cfoutput query="getEvent">
					<li class="list-group-item"><input type="radio" name="specialevent_id" value="#getEvent.specialevent_id#" id="sid_#getEvent.specialevent_id#"> #ucase(getEvent.label)#</li>
				</cfoutput>
			</ul>
		<!--- I am preserving this functionality because I believe it to be a more user-friendly option, but Todd thought it would
		be more consistent if it was removed
			#### if there is a single visitor and there are NO specialevents, do we forward them on automatically #### 
		<cfelseif getAllVisitors.recordcount EQ 1>
			<cflocation url="/residents/popup/modifyschedule2.cfm?v_id=#getAllVisitors.V_ID#" addtoken='false' > --->
		</cfif>
	</form>
	<cfabort>
	
<cfelse>
	<cfquery name="getGuestVisits" datasource="#datasource#">
		SELECT * from guestvisits
		where v_id = #form.v_id#
	</cfquery>	
</cfif>
<cfset session.g_id = getGuestVisits.g_id>
<cfquery name="getGuest" datasource="#datasource#">
	SELECT * from guests
	where g_id = #getGuestVisits.g_id#
</cfquery>	
<cfquery name="getSchedule" datasource="#datasource#">
	SELECT visit_date
	from schedule 
	WHERE v_id = #form.v_id#
</cfquery>
<cfquery name="getVisits" datasource="#datasource#">
	SELECT v_id
	from visits 
	WHERE v_id = #form.v_id#
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
	var listFrmVal = document.getElementById('allSelected').value;
	var dateArr = listFrmVal.split( "," );
	var indexOfdate = getIndex(thedate,dateArr);
	if (indexOfdate != -1) {
			//alert(thedate + 'to remove');
			boxToUpdate.className='calDayBox';
			dateArr.splice(indexOfdate,1); //adds element to the array			
			document.getElementById('allSelected').value=dateArr.join(); //pushes into a list on the hidden form field
	}
	else {
		//alert(thedate + 'to add');
		boxToUpdate.className='selectedBox';
		dateArr.push(thedate); //adds element to the array
		document.getElementById('allSelected').value = dateArr.join(); //pushes into a list on the hidden form field
		}
}
</script>

<cfif isDefined("url.messagecode")>

	<cfif url.messagecode is "duplicateEdit">
	<h1>Duplicate Guest Announcement</h1> 
	<div class="well">Please Edit Your Previously Scheduled Announcement Below:</div></cfif>

</cfif>

	<cfoutput>
		<form action="/residents/popup/modifyschedule3.cfm" method="post">	
		<input type="button" class="btn btn-sm btn-danger visit-cancel-btn" value="DELETE VISIT" data-vid="#url.v_id#">	
		<fieldset><legend>#getGuest.g_lname#<cfif len(getGuest.g_fname)>, #getGuest.g_fname#</cfif></legend>
		<cfif getGuestVisits.insertedby_staff_id>
			<strong style="color:red;">Originally Announced By Staff Member</strong>
		</cfif>
		<input type="hidden" name="g_lname" value="#getGuest.g_lname#" maxlength="50">
		<input type="hidden" name="g_fname" value="#getGuest.g_fname#" maxlength="50">
	
	<cfif GetCommunity.guestcompanionOption eq 1>
	Plus Guest(s) <select name="guestcompanioncount">
		<option<cfif val(getGuestVisits.guestcompanioncount) eq 0> selected="selected"</cfif>>0</option>
		<option<cfif val(getGuestVisits.guestcompanioncount) eq 1> selected="selected"</cfif>>1</option>
		<option<cfif val(getGuestVisits.guestcompanioncount) eq 2> selected="selected"</cfif>>2</option>
		<option<cfif val(getGuestVisits.guestcompanioncount) eq 3> selected="selected"</cfif>>3</option>
		<option<cfif val(getGuestVisits.guestcompanioncount) eq 4> selected="selected"</cfif>>4</option>
	</select>
	<cfelse>
		<input type="hidden" name="guestcompanioncount" value="0">
	</cfif>
	
	<cfset dateList = "">
	<cfloop query="getSchedule">
		<cfset dateList = listAppend(dateList,dateFormat(getSchedule.visit_date,"m/d/yyyy"))>
	</cfloop>
	<p class="text-center">  
		 Entry permitted on selected dates - Click ALL that apply
	</p>
	<div class="form-group" style="overflow: auto">
	<table align="center" border="2" bordercolor="white">	
		<tr>
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<!--- <td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td> --->
		</tr>
	</table>
	</div>
	<style>
	.selectedBox {background-color: ##74dd82}
	.preselectedBox {background-color: ##74dd82}
	</style>

	<cfquery name="getSingleEntry" datasource="#datasource#">
		select * from schedule
		WHERE v_id = #url.v_id#
	</cfquery>

	<br />
	<div class="form-group col-md-6 col-md-offset-2">
		<cfif not getVisits.recordcount>
			<div align="center" style="font-weight:normal;padding-bottom:5px;">
			<cfif getSingleEntry.RecordCount IS 1>
				<label for=""></label>
				<div>
					<input type="radio" name="change_entrytype" value="SingleEntry" <cfif getSingleEntry.g_singleentry IS "TRUE">checked</cfif>>&nbsp;<strong>SINGLE ENTRY</strong> <input type="radio" name="change_entrytype" value="FullDay" <cfif getSingleEntry.g_singleentry IS "FALSE">checked</cfif>>&nbsp;<strong>FULL DAY</strong>
				</div>
			</cfif>
			<label for="hour">Arrival Time:</label>
			<select class="form-control" name="hour">
				<cfloop from="0" to="23" index="i">
				<cfloop from="0" to="45" step="30" index="m">
				<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
				<cfset ittValue = i & ':' & min>
				<option<cfif TimeFormat(getGuestVisits.g_initialvisit,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
				</cfloop>
				</cfloop>
			</select>
		</cfif>
		<select name="dateList" size="1" style="visibility:hidden;">
		<option value="-">-----------------</option>
		</select>
		
	 	<cfif GetCommunity.DashPass IS 'YES'>	
			<div class="form-group">
				<label class="control-label" for="dashpass_reissue">Reissue DashPass:</label>
				<div class="">
					<select id="dashpass-reissue" name="dashpass_reissue" class="form-control inp-sm">
						<option class="list-group-item" value="none">None</option>
						<option class="list-group-item" value="gate">Pickup at Check-In</option>
						<option class="list-group-item" value="email">Email to <cfoutput>#labels.permanent_visitor#</cfoutput></option>
					</select>
				</div>
				<div class="help-block with-errors"> &nbsp;</div>
			</div>
			<div class="form-group email-form-grp">
				<label for="Email#i#" class="control-label"></label>
				<div class="">
					<input type="text" class="form-control inp-sm" id="Email-Inp" name="g_email" value="#getGuest.g_email#" placeholder="<cfoutput>#labels.visitor#</cfoutput>'s Email Address" required data-error="Required">
				</div>
				<div class="col-md-2 help-block with-errors"></div>
			</div>
		<cfelse>
			<input type="hidden" name="g_email" value="#getGuest.g_email#">
	 	</cfif>
	</div>
	<!-- -->
	<script language="JavaScript">
	//document.form[0].dateList.options[0]=null; 
	$('.email-form-grp').hide();
	$("form").on('change','##dashpass-reissue',function(){
		if ( this.value === 'email'){
			$('.email-form-grp').show();
		} else {
			$('.email-form-grp').hide();
		}
	});
	</script>
	<input type="hidden" name="g_id" value="#session.g_id#">
	<input type="hidden" name="g_barcode" value="#getGuestVisits.g_barcode#">

	
		<cfset cookie.v_id = url.v_id>
	<input type="hidden" name="v_id" value="#url.v_id#">
	<input type="hidden" name="allSelected" id="allSelected" value="#dateList#">
	</cfoutput>
