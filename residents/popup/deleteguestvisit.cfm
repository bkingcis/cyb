<cftry>
<cfquery name="deleteSC" datasource="#datasource#">
	DELETE FROM schedule
	WHERE v_id = #v_id# 
</cfquery>
<cfquery name="deleteGV" datasource="#datasource#">
	DELETE FROM guestvisits
	WHERE v_id = #v_id# 
</cfquery>

<cfinclude template="header.cfm">
	<div class="well">Guest Visit Successfully Removed</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>
<!--- 
<cflocation url="/residents/" addtoken="No">
--->
