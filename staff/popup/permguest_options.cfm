<cftry>
<cfquery name="getpermGuests" datasource="#datasource#">
	select guests.g_id, guests.g_lname, guests.g_fname, 
	guestvisits.v_id,guestvisits.g_initialvisit, guests.r_id, guests.g_paused, guestvisits.g_checkedin,
	guestvisits.g_barcode,guestvisits.g_permanent, guestvisits.insertedby_staff_id, guestvisits.guestcompanioncount,
	guestvisits.g_barcode,guestvisits.g_photo,residents.h_id ,residents.r_lname, residents.r_fname, 
	residents.r_id, residents.r_altphone
	from guests, guestvisits, residents
	where guests.g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(g_id)#" />
	and guests.g_id = guestvisits.g_id 
	and guestvisits.v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(v_id)#" />
	and guests.r_id = residents.r_id
</cfquery>
<cfquery name="getHomesite" datasource="#datasource#">
	select * from homesite where h_id = #val(getpermGuests.h_id)#
</cfquery>
<cfquery name="qHistory" datasource="#datasource#">
	select *
	FROM visits	WHERE v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(v_id)#" />
	order by g_checkedin desc
</cfquery>
<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery name="qstateList" datasource="#datasource#">
	select state,abbreviation from states 
	order by state
</cfquery>


<cfparam name="nextactions" default="" />

<cfinclude template="header.cfm"> <cfoutput>
<div id="popUpContainer"><h1><!--- 24/7 Access ---> Express Pass Visitor<!--- RESIDENT: #ucase(getpermGuests.r_lname)#, #ucase(getpermGuests.r_fname)# ---></h1>
<div> <p /> </div>
  <table border="0" cellpadding="1" width="100%">
	        <tr>
	            <td rowspan="8" width="50">&nbsp;&nbsp;</td>
	            <td style="font-weight:bold;color:##ffffff;font-size:13px;">VISITOR:<br><br></td>
	            <td style="font-size:14px;font-weight:600;">#UCASE(getpermGuests.g_lname)#, #UCASE(getpermGuests.g_fname)#
				<br><br></td>
				
	            <td style="font-weight:bold;color:##ffffff;font-size:13px;">INITIAL VISIT:<br><br></td>
				<td valign="top">					
					<table border="0" cellpadding="1">
					<tr>
						<td style="font-weight:bold;font-size:13px;" valign="top" align="right">Actual:</td>
						<td style="font-size:13px;" valign="top"><cfif isdate(qHistory.g_checkedin[qHistory.recordcount])>#DateFormat(qHistory.g_checkedin[qHistory.recordcount],"m/d/yyyy")# #TimeFormat(qHistory.g_checkedin[qHistory.recordcount],"hh:mm:ss tt")#<cfelse>No Visit Recorded</cfif></td>
				    </tr> 
					</table>					
				</td>
	        </tr>
	        <tr>
	            <td style="font-weight:bold;color:##ffffff;font-size:13px;" valign="top" rowspan="6">RESIDENT:</td>
	            <td style="font-size:14px;" valign="top" rowspan="6">#ucase(getpermGuests.r_lname)#, #ucase(getpermGuests.r_fname)#<br>
	                <cfif NOT getCommunity.showunitonlyoption>#gethomesite.h_address#<br><cfelse>Unit</cfif>
					 <cfif len(gethomesite.h_unitnumber)> #gethomesite.h_unitnumber#<br></cfif>
	                 #gethomesite.h_city#,#gethomesite.h_state#&nbsp;#gethomesite.h_zipcode#<br>
	                Main Phone: #gethomesite.h_phone#<br>
	                <cfif Len(getpermGuests.r_altphone) and not getpermGuests.r_altphone is "..">Alt Phone: #getpermGuests.r_altphone#</cfif>
	            </td>				
	        </tr>
		</table><div> <p /> </div>
			<cfif val(v_id)>	<br /> 
			<form action="/staff/modifyschedule3.cfm" method="post">
				<input type="hidden" name="v_id" value="#v_id#">
				<!--- cfif getPermGuests.g_paused> 
					<input name="sbtButton" class="btn" type="submit" value=" : Paused : "> 
				<cfelse> 
					<input name="sbtButton" class="btn" type="submit" value=" : Active : "> 
				</cfif --->
				<table width="100%"><tr><td align="center">
				<input type="radio" data-vid="#v_id#" name="g_paused" value="0"<cfif !getPermGuests.g_paused> checked="checked"</cfif>> Active  
				<input type="radio" data-vid="#v_id#" name="g_paused" value="1"<cfif getPermGuests.g_paused> checked="checked"</cfif>> Paused 
				</td></tr></table><br /><br />
				
				<input name="sbtButton" class="btn" type="submit" value=" : Delete Visitor : " style="color:Red;">
				<input id="viewHistory" class="btn" type="button" value="Recorded Visits" onclick="self.location='/staff/popup/history.cfm?g_id=#url.g_id#'">
				
				
			</form>
		</cfif>
		
	</cfoutput>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

<script>
$(function(){
	$('input[name="g_paused"]').click(function(){
			var $this = $(this);
			var frmData = {
				paused: $this.val(),
				vid: $this.attr('data-vid')
			}
			var jqxhr = $.post( 
				'/staff/bizrules/pause_permguest.cfm', frmData, function( results ) {
					alert('Status Saved.');
				}
			)
	});
});
</script>

