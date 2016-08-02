<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfquery datasource="#request.dsn#" name="qAllHomesites">
  select h_address, h_unitnumber,h_id
  from homesite
  where c_id =  #session.user_community#
  order by h_address, h_unitnumber
</cfquery>
<cfquery datasource="#request.dsn#" name="qAllResidents">
  select r_id,r_fname,r_lname
  from residents
  where c_id =  #session.user_community#
  order by r_lname, r_fname
</cfquery>

<cftry>
	<cfinclude template="header.cfm">
  <div id="popUpContainer">
  <h1>Visitor Search</h1>
	<cfif NOT structKeyExists(form,"visit_type")>
    <form action="searchbox.cfm" method="post">
    
      <h2>Step 1: Choose Report Type</h2>
      <div style="margin-left: 80px;color: white;text-align: left;">
        <label for="visittype1" style="display:inline-block"><input type="radio" name="visit_type" id="visittype1" value="past" checked="checked"> Future Announcements</label>
        <label for="visittype2" style="display:inline-block"><input type="radio" name="visit_type" id="visittype2" value="future" > Recorded Visits</label>
      </div>
			<div style="clear:both"></div>
      <h2>Step 2: Choose Resident <!-- OR Address/Unit --></h2>
      <table style="margin-left: 80px;">
       <!---  <tr>
          <td><input type="radio" name="res_type" value="homesite" checked="checked"></td>
          <td><cfif getCommunity.showunitonlyoption>Unit #<cfelse>Adress</cfif>:</td>
          <td>
						<select name="h_id"><option value=""></option>
						<cfoutput query="qAllHomesites"><option value="#qAllHomesites.h_id#"><cfif NOT getCommunity.showunitonlyoption>#qAllHomesites.h_address#</cfif> #qAllHomesites.h_unitnumber#</option></cfoutput></select>
             
						<select><option>All Users</option><option>Primary User</option></select>
          </td>
        </tr> --->
        <tr>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
					<td width="240">Resident Name:</td>
          <td><select name="r_id" class="form-control"><option value=""></option>
            <cfoutput query="qAllResidents"><option value="#qAllResidents.r_id#">#qAllResidents.r_lname#, #qAllResidents.r_fname#</option></cfoutput></select>
          </td>
        </tr>
				<tr>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>
      <button class="btn">Go!</button>
    </form>
		<cfelse>
				<cfif form.visit_type is 'past'>
					<cfmodule template="/staff/include/search_results_past.cfm" r_id="#form.r_id#">
				<cfelse>
					<cfmodule template="/staff/include/search_results_future.cfm" r_id="#form.r_id#">
				</cfif>
		</cfif>
  </div>
  <cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>