<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfquery name="getResidents" datasource="#datasource#">
	select r.r_lname || ', ' || r.r_fname as fullname,r.r_lname,r.r_fname,r.r_id 
	from residents r join homesite h on h.h_id = r.h_id
	where r.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and h.softdelete <> 1 
	and h_lname <> 'VACANT'
	order by r.r_lname, r.r_fname
</cfquery>
<cfquery name="getHomesites" datasource="#datasource#">
	select h_id,h_address,h_unitnumber from homesite
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and 	softdelete = 0
	order by h_address,h_unitnumber
</cfquery>

<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
<div style="clear:both;"></div><br /><br />
<table align="center" style="font-size:11px;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
	<tr>
	<td colspan="4" align="center"><div align="center" style="font-weight:bold;font-size:14px;">RESIDENT SEARCH<br>
	<br>
	</div></td>
	</tr>
	
	<form action="#" method="POST" name="annouce">
	<input type="hidden" name="whichsearch" value="resident">
	<tr>
		<td valign="top" align="right" style="padding-right:5px;">
		<strong>&nbsp;BY NAME:</strong>
		</td>
		<td valign="top">
			<input type="text" name="resident" id="resident" style="width:240px;"><br />
			
			
			<!--- <
			<select name="r_id"><cfoutput query="getResidents">
				<option value="#getResidents.r_id#">#ucase(getResidents.r_lname)#, #ucase(getResidents.r_fname)#</option></cfoutput>
			</select> --->
		</td>
		<td>					
			
			<input type="submit" value="go"><br /><br />
			
		</td>
	</tr>
	</form>
	<tr>
		<td align="right" style="padding-right:5px;">
		<strong>BY RESIDENT LAST NAME:</strong>
		</td>
		<td colspan="2">
		<span style="font-size:0.9em"><cfoutput><cfloop from="#Asc( 'A' )#" to="#Asc( 'Z' )#" index="letterIndex">
		<a href="residentsearch.cfm?letter=#chr(letterIndex)#">#chr(letterIndex)#</a>
	</cfloop></cfoutput></span>
		</td>
	</tr>
	<form action="#" method="POST" name="annouce">
	<input type="hidden" name="whichsearch" value="homesite">
	
	<tr>
	<td colspan="4" align="center">&nbsp;</td>
	</tr>
	<input type="hidden" name="r_lname" value="">
	<input type="hidden" name="r_fname" value="">	
	
	<tr>
	<td align="right" style="padding-right:5px;"><strong>&nbsp;BY <cfif getCommunity.showunitonlyoption>UNIT NUMBER<cfelse>ADDRESS</cfif>:</strong></td>
	<td><input type="text" name="homesite" id="homesite" style="width:240px;"><!--- <select name="h_id"><cfoutput query="getHomesites">
			<option value="#getHomesites.h_id#">#getHomesites.h_address#</option></cfoutput>
		</select> --->
	</td>
	<td><input type="submit" value="go"></td>
	</tr> 
</table>
</form>
<cfif isDefined("form.whichsearch") or isDefined("url.letter")>
<br />
	<cfparam name="form.whichsearch" default="none">
	<cfif form.whichsearch is "homesite">	
		<cfquery name="getSearchResults" datasource="#datasource#">
			select * from residents r join homesite h on r.h_id = h.h_id
			where h.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
			and h.softdelete <> 1 
			and h.h_lname <> 'VACANT'
			<cfif getCommunity.showunitonlyoption>
			AND h_unitnumber = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.homesite#" />	
			<cfelse>
			AND h_address = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.homesite#" />	
			</cfif>
			order by r_lname, r_fname
		</cfquery>	
	<div align="center"><strong>SEARCH RESULTS</strong><br>
	<cfelse>
		<cfquery name="getSearchResults" datasource="#datasource#">
			select * from residents r join homesite h on r.h_id = h.h_id
			where h.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
			<cfif isDefined("url.letter")>
			and r.r_lname like '#url.letter#%'
			<cfelse>
			AND (r.r_lname = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#listFirst(form.resident)#" />
			AND r.r_fname = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#trim(listRest(form.resident))#" /> )
			</cfif>
			AND h.softdelete <> 1 
			AND h.h_lname <> 'VACANT'
			order by r_lname, r_fname
		</cfquery>
	<div align="center"><strong>SEARCH RESULTS</strong><br>
	</cfif>
	
				
		<cfif getSearchResults.RecordCount GT 0>
				<table cellpadding="0" cellspacing="2" border="0" width="85%">
				<tr>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">Last</td>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">First</td>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">Phone</td>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">Address</td>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">Tools</td>
				</tr>
				<cfoutput query="getSearchResults">
				<cfif NOT getSearchResults.r_lname is 'Vacant'>
					<cfquery name="getHomesite" datasource="#datasource#">
						select * from homesite
						Where h_id = #getSearchResults.h_id#
					</cfquery>
					<tr>
						<td align="center">#ucase(getSearchResults.r_lname)#</td>
						<td align="center">#ucase(getSearchResults.r_fname)#</td>
						<td align="center">#getHomesite.h_phone#</td>
						<td align="center"><cfif NOT getCommunity.showunitonlyoption> #getHomesite.h_address#  </cfif><cfif len(getHomesite.h_unitnumber)>Unit #getHomesite.h_unitnumber#</cfif></td>
						<form action="../residents/login.cfm" method="POST">
						<td align="center">
						<input type="hidden" name="c_id" value="#getSearchResults.c_id#">
						<input type="hidden" name="r_id" value="#getSearchResults.r_id#">
						<input type="hidden" name="h_id" value="#getSearchResults.h_id#">
						<input type="hidden" name="staff_id" value="#session.staff_id#">
						<input type="hidden" name="r_fname" value="#getSearchResults.r_fname#">
						<input type="hidden" name="r_lname" value="#getSearchResults.r_lname#">
						
						<input type=hidden name="loggedfromstaff" value="YES">
						<input title="All Authorized Guests" type="button" value="*" onclick="this.form.action='searchprocess.cfm';this.form.target='_self';this.form.submit();">
						<cfif isDefined("getCommunity.quickpass") and getCommunity.quickpass>
						<input title="Create QuickPass" type="button" value="Q" onclick="quickpassPrint(#getSearchResults.r_id#);">
						</cfif>
						<input title="Announce Guest(s)" type="button" value="A" onclick="this.form.action='guestAnnounce2.cfm';this.form.target='_self';this.form.submit();">
						<input title="View/Edit Guest(s)" type="button" value="E" onclick="this.form.action='guestAnnounceList.cfm';this.form.target='_self';this.form.submit();">
						<input title="Add 24/7 Guest" type="button" value="24/7" onclick="this.form.action='permguest1.cfm';this.form.target='_self';this.form.submit();">
						<input title="Special Events" type="button" value="S" onclick="this.form.action='SpecialEvent_announce1.cfm';this.form.target='_self';this.form.submit();">
						
						<!--- <input type="submit" value="login" onclick="this.form.target='_blank';this.form.submit();"> ---></td></form>					
					</tr>		
				</cfif>
				</cfoutput>
				</table>
				</div>		
		<cfelse>
				<div align="center" style="font-size:13px;font-weight:bold;margin-bottom:10px;">Sorry, but your search returned 0 results</div>				
				<div align="center"><FORM>
				<input type="button" onClick="window.history.go(-1)" VALUE="Go Back">
				</FORM></div><br>
					
		</cfif>		
	</cfif>
<br />
<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">
<script>
function findValue(li) {
	if( li == null ) return alert("No match!");
 
	// if coming from an AJAX call, let's use the CityId as the value
	if( !!li.extra ) var sValue = li.extra[0];
 
	// otherwise, let's just display the value in the text box
	else var sValue = li.selectValue;
 
	alert("The value you selected was: " + sValue);
}
 
function selectItem(li) {
	findValue(li);
}
 
function formatItem(row) {
	return row[0] + " (id: " + row[1] + ")";
}
 
function lookupLocal(){
	var oSuggest = $("#homesite")[0].autocompleter;
 
	oSuggest.findValue();
 
	return false;
}
$(document).ready(function() {
	$("#resident").autocomplete(
		[ <cfoutput>#replace(replace(QuotedValueList(getResidents.fullname),"'","|","all"),'|','"','all')#</cfoutput> ],
		
		{
			delay:10,
			minChars:1,
			matchSubset:1,
			matchContains: true,
			onItemSelect:selectItem,
			onFindValue:findValue,
			autoFill:true,
			maxItemsToShow:10
		}
	);
	$("#homesite").autocomplete(
		[ <cfoutput>
		<cfif getCommunity.showunitonlyoption>
		#replace(replace(QuotedValueList(gethomesites.h_unitnumber),"'","|","all"),'|','"','all')#
		<cfelse>
		#replace(replace(QuotedValueList(gethomesites.h_address),"'","|","all"),'|','"','all')#
		</cfif>
		</cfoutput> ],
		
		{
			delay:10,
			minChars:1,
			matchSubset:1,
			matchContains: true,
			onItemSelect:selectItem,
			onFindValue:findValue,
			autoFill:true,
			maxItemsToShow:10
		}
	);
});
</script> 