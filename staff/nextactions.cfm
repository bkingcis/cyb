<script language="JavaScript">
		function ReprintAndPrintPop(vID) {
			printable=window.open("reprintDP.cfm?v_id="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}
		function ReissueAndPrintPop(vID) {
			printable=window.open("reissueDP.cfm?v_id="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}
		function ReissueSEAndPrintPop(vID) {
			printable=window.open("reissueSEDP.cfm?v_id="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}
	</script>

<cfparam name="attributes.nextActions" default="">
<cfoutput>
	<cfif listFindNocase(attributes.nextActions,"findresident")><input type="button" value="Find a Resident" onclick="self.location='announce.cfm'" />&nbsp;</cfif>
	<cfif listFindNocase(attributes.nextActions,"findguest")><input type="button" value="Find a Guest" onclick="self.location='searchbox.cfm'" />&nbsp;</cfif>
	<cfif listFindNocase(attributes.nextActions,"reprintDP")><input type="button" value="Reprint DashPass" onclick="ReprintAndPrintPop(#attributes.v_id#)'" />&nbsp;</cfif>
	<cfif listFindNocase(attributes.nextActions,"reissueDP")><input type="button" value="Cancel/Re-Issue DashPass" onclick="ReissueAndPrintPop(#attributes.v_id#);" />&nbsp;</cfif>
	<cfif listFindNocase(attributes.nextActions,"IssueSingleEntry")><input type="button" value="Print Single-Entry Pass" onclick="ReissueSEAndPrintPop(#attributes.v_id#)" />&nbsp;</cfif>

</cfoutput>