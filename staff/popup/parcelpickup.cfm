<cfsilent>
<cfif isDefined('url.itemDelivered')>
	<cfquery datasource="#datasource#" name="qUndelivered">
	update parcels set delivereddate = now(), 
		deliveredbystaff_id=<cfqueryparam value="#session.staff_id#" cfsqltype="CF_SQL_INTEGER" />
	where 	parcel_id = <cfqueryparam value="#url.itemDelivered#" cfsqltype="CF_SQL_INTEGER" />
	</cfquery>
</cfif>

<cfif isDefined('form.pickedupby')>
	<cfquery datasource="#datasource#" name="qUndelivered">
	update parcels set delivereddate = now(), 
		deliveredbystaff_id=<cfqueryparam value="#session.staff_id#" cfsqltype="CF_SQL_INTEGER" />
	where 	deliverTo = <cfqueryparam value="#form.pickedupby#" cfsqltype="CF_SQL_VARCHAR" />
	and delivereddate is null
	</cfquery>
	<cflocation url="/staff/" addtoken="false">
</cfif>

<cfquery datasource="#datasource#" name="qUndelivered">
	select p.itemcount,p.receivedFrom, r.r_fname, r_lname, p.receivedDate,p.parcel_id
	from parcels p left join residents r on cast(r.r_id as text) = p.receivedFrom
	where 	deliverTo = <cfqueryparam value="#url.deliverto#" cfsqltype="CF_SQL_VARCHAR" />
	and delivereddate is null
	order by receiveddate desc
</cfquery>
</cfsilent>
<cfinclude template="header.cfm">
<style>
 .approvalItems {
 	width: 400px;
	border: 3px solid #ffffff;
	background-color: #aaeeaa;
	margin: 3px auto;
	font: 14px Arial bold;
	padding: 6px;
 ]
</style>
<script type="">
	$(document).ready(function(){
		$('.deliverone').click(function(e){
			<cfoutput>link = '/staff/popup/parcelpickup.cfm?deliverto=#url.deliverto#';</cfoutput>
			link = link + '&itemDelivered=' + $(this).attr('ref');
			self.location=link;
		});
	});
</script>
<div id="popUpContainer">
<h1>ITEMS FOR PICKUP - <cfif isNumeric(url.deliverTo)>
<cfquery datasource="#datasource#" name="qName">
	select  r_fname, r_lname
	from 	residents where r_id = <cfqueryparam value="#url.deliverto#" cfsqltype="cf_sql_integer" />
</cfquery>
<cfoutput>#ucase(qName.r_lname)#, #ucase(qName.r_fname)#</cfoutput>
<cfelse><cfoutput>#url.deliverTo#</cfoutput></cfif></h1>

<form action="/staff/popup/parcelpickup.cfm" target="_parent" method="post">
<cfoutput><input type="hidden" name="pickedupby" value="#url.deliverto#"></cfoutput>
<input type="submit" value="ALL ITEMS DELIVERED" name="all"> <input type="button" onclick="parent.location.reload();parent.$.fancybox.close();" value="CANCEL">
</form>
<cfoutput query="qUndelivered">
	<div class="approvalItems">#itemcount# Items From: <cfif isNumeric(receivedFrom)>#UCASE(r_lname)#, #UCASE(r_fname)#<cfelse>#receivedFrom#</cfif> (#dateFormat(receivedDate,'m/d/yyyy')#)
	<div style="float:right;margin-top:-5;"><input class="deliverone" ref="#parcel_ID#" type="button" value="deliver" /></div></div>
</cfoutput>
</div>
</body>
</html>
