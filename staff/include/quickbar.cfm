<cftry>
	<cfquery datasource="#request.dsn#" name="qAllResidents">
		select r_id, r_fname, r_lname from residents
		where  c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		AND active = 1
		ORDER by r_lname, r_fname
	</cfquery>
	<cfquery datasource="#datasource#" name="qEventTypes">
		Select * from CommunityeventTypes
		where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		order by label
	</cfquery>

	<div id="quickbar">
		<form id="frmQuickbar" name="frmQuickbar" action="#" style="margin:0px;padding:0px;" method="post">
		 <strong style="color:white;">Jump To:</strong>
		 <select name="r_id" id="selResidentID" class="action-btn"><option value=""> - All Residents -</option>
			<cfoutput query="qAllResidents"><option value="#r_id#">#ucase(r_lname)#, #ucase(r_fname)#</option></cfoutput>
		 </select><div style="height: 8px;"> </div>
		 <input type=hidden name="loggedfromstaff" value="YES">
		 <input class="jumpBtn btn btn-small action-btn" title="Today" type="button" value="Today" id="todayBtn" hrefVal="today.cfm" />
		 <input class="jumpBtn btn btn-small action-btn" title="Announce Guest" type="button" value="Add Visitor" id="announceBtn" hrefVal="guestAnnounce2.cfm" />
	 <!--- <input class="jumpBtn btn btn-small action-btn" title="All Activity" type="button" value="All Activity" id="todayBtn" hrefVal="today.cfm" /> --->
		
		<cfif val(getCommunity.permanantguests)>
		 <input class="jumpBtn btn btn-small action-btn" title="Add or Edit 24/7 Guest Access" type="button" value="Express Pass" id="permGuestBtn" hrefVal="permguest1.cfm" />
		</cfif>
		<!---  <cfif isDefined("getCommunity.quickpass") and getCommunity.quickpass>
		 <input class="jumpBtn btn btn-small action-btn" title="Create QuickPass" type="button" value="Q" id="qpBtn" hrefVal="searchprocess.cfm" />
		 </cfif>
		 <!---<input class="jumpBtn btn btn-small" title="Visitor History" type="button" value="History" id="historyBtn" hrefVal="history.cfm" />--->
		 <input class="jumpBtn btn btn-small action-btn" title="Edit Guest/Special Event" type="button" value="Edit" id="editBtn" hrefVal="guestAnnounceList.cfm" />
		 --->
		 <cfif qEventTypes.recordcount>
		 <input class="jumpBtn btn btn-small action-btn" title="Add or Edit Special Events" type="button" value="Special Events" id="eventsBtn" hrefVal="events.cfm" />
		 </cfif>
		 <cfif isDefined("getCommunity.track_maintenance_requests") and val(getCommunity.track_maintenance_requests)>
		 <input class="jumpBtn btn btn-small action-btn" title="Maintenance Requests" type="button" value="Maintenance" id="maintBtn" hrefVal="maintenance.cfm" />
		 </cfif>
		 <input class="jumpBtn btn btn-small action-btn" title="Parcel/Package Reciept or Delivery" type="button" value="Parcel/Package" id="parcelBtn" hrefVal="parcel.cfm" />
		</form>
	</div>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

<script> 
	$(document).ready(function(){
		$('.jumpBtn').click(function(){
			if ($('#selResidentID').val()=='' && ( $(this).val()=='Today' ||  $(this).val()=='All Activity' || $(this).val()=='Announce' || $(this).val()=='Edit') ){
				alert('Please select a resident from the "Jump To" menu');
				$('#selResidentID').focus();
				return false;
			} 
			linkTo = $(this).attr('hrefVal')+'?r_id='+$('#selResidentID').val();
			
			$.fancybox({
		                'href' : 'popup/'+linkTo,
						'type' : 'iframe',
						'height': '80%',
						'width' : '70%'
		            });
		});
			
		$('.jumpBtnAlt').click(function(){
			quickpassPrint($('#selResidentID').val());
		});
	});

	function quickpassPrint(r_id) {
			r_id=r_id||"";
			printable=window.open("printable-pass.cfm?v_id=0&r_id="+r_id,"printable","status=0,toolbar=0,width=825,height=700");
		}
</script> 