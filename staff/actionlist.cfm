<cfparam name="attributes.showonly" default="residents,announce,search,events,home,logout">
<cfif NOT isDefined("datasource")><cfset datasource = caller.datasource></cfif>
<cfquery datasource="#datasource#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #session.user_community#
	order by label
</cfquery>

	<div class="pagebutton" style="text-align: center;padding-top:40px">
	 <a class="extlink" href="popup/activity.cfm?limit=1"><!--- or history.cfm ---> &nbsp; Last Check-in &nbsp; </a> <br /><br />
	  <a class="extlink" href="popup/activity.cfm"> &nbsp; Check-in Activity &nbsp; </a> <br /><br />
	 
	 <cfif listFind(attributes.showonly,"search")><a class="extlink" href="popup/searchbox.cfm">&nbsp; Visitor Search &nbsp;</a><br /><br /></cfif>
	 <cfif isDefined("getCommunity.track_maintenance_requests") and val(getCommunity.track_maintenance_requests)>
	 	<a class="extlink" href="popup/maintenance.cfm"> &nbsp; Maintenance Requests &nbsp; </a>  <br /><br />
	 </cfif>
		 
	 <a href="powerfailure.cfm" target="_new"> &nbsp; Power Failure &nbsp; </a> 
	 <cfif isDefined("getCommunity.quickpass") and val(getCommunity.quickpass)> |  <a href="Javascript:quickpassPrint();">Quick Pass</a>
	 <script>
		function quickpassPrint(r_id) {
					r_id=r_id||"";
					printable=window.open("printable-pass.cfm?v_id=0&r_id="+r_id,"printable","status=0,toolbar=0,width=825,height=700");
				}
	 </script>
	 </cfif>
	</div>

