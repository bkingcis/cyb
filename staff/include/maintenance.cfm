<cftry>
  <cfquery datasource="#request.dsn#" name="getRequests_new">
    select maintenance_request_id,m.r_id,title,request_date,request_status,r_lname, r_fname, h.h_id, h_unitnumber
		from maintenance_request m join residents r on r.r_id = m.r_id		
			join homesite h on r.h_id = h.h_id
    where r.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
    <cfif structKeyExists(form,'r_id') and val(form.r_id) >and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.r_id)#"> </cfif>
		AND  request_status = 'new'
		order by request_date
  </cfquery>

	 <cfquery datasource="#request.dsn#" name="getRequests_inprogress">
    select maintenance_request_id,m.r_id,title,request_date,request_status,r_lname, r_fname, h.h_id, h_unitnumber
		from maintenance_request m join residents r on r.r_id = m.r_id		
			join homesite h on r.h_id = h.h_id
		where r.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
    <cfif structKeyExists(form,'r_id') and val(form.r_id) >and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.r_id)#"> </cfif>
		AND  request_status = 'inprogress'
		order by request_date
  </cfquery>
  
	<cfquery datasource="#request.dsn#" name="getRequests_completed">
    select maintenance_request_id,m.r_id,title,request_date,request_status,r_lname, r_fname, h.h_id, h_unitnumber
		from maintenance_request m join residents r on r.r_id = m.r_id		
			join homesite h on r.h_id = h.h_id
		where r.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
    <cfif structKeyExists(form,'r_id') and val(form.r_id) >and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.r_id)#"> </cfif>
		AND  request_status = 'completed'
		order by request_date
  </cfquery>
	
	<cfquery name="getRequests" dbtype="query">
		select * from getRequests_new
		UNION
		select * from getRequests_inprogress
	</cfquery>

<cfparam name="show_only" default="active,completed">
<cfparam name="request.hidesubtitle" default="false">

<cfoutput>			
		<cfif getRequests.RecordCount and listFindNoCase(show_only,'active')>	
			<cfif NOT request.hidesubtitle>
			<h2><cfif show_only is 'active'>#ucase(labels.communications)#S<cfelse>ACTIVE</cfif></h2>
				<div class="homePageDatagrid">
				<table width="100%" cellpadding="1" cellspacing="1" border="0" class="fixed_headers">
			<cfelse>
				<div class="modalDatagrid">
				<table cellpadding="1" cellspacing="1" border="0" align="center">
			</cfif>
			<thead>	
		<table width="100%" cellpadding="2" cellspacing="1" border="0" align="center">
			<tr>
			 <th class="datatableHdr" align="center">Resident</th>
			 <th class="datatableHdr" align="center">Request Date</th>
			 <th class="datatableHdr" align="center">Title</th>
			 <th class="datatableHdr" align="center">Unit</th>
			 <th class="datatableHdr" align="center">Status</th>
			</tr>			
			<tbody>
			<cfloop query="getRequests">
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td align="center" style="font-size:10px;"><a href="maintenance_detail.cfm?maintenance_request_id=#maintenance_request_id#">#r_fname# #r_lname#</td>
				<td align="center" style="font-size:10px;">#dateFormat(request_date,'m/d/yyyy')#</td>
				<td style="font-size:10px;">#title#</td>
        <td align="center" style="font-size:10px;">#h_unitnumber#</td>
        <td style="font-size:10px;">
					<select name="status" class="sel_status" data-rid="#r_id#" data-request-id="#maintenance_request_id#">
						<option value="new"<cfif request_status is 'new'> selected="selected"</cfif>>New</option>
						<option value="inprogress"<cfif request_status is 'inprogress'> selected="selected"</cfif>>In Progress</option>
						<option value="completed"<cfif request_status is 'completed'> selected="selected"</cfif>>Completed</option>
					</select>
				</td>
        </tr>
      </cfloop>
      </tbody>
    </table>
	<cfelse>
		<p style="color: white;">No active #labels.communications#s found.</p>
	</cfif>

<cfif listFindNoCase(show_only,'completed')>
  <cfif getRequests_completed.recordcount>
	<h2>COMPLETED</h2>
		<table width="98%" cellpadding="2" cellspacing="1" border="0" align="center">
			<tr>
			 <th class="datatableHdr" align="center">Resident</th>
			 <th class="datatableHdr" align="center">Request Date</th>
			 <th class="datatableHdr" align="center">Title</th>
			 <th class="datatableHdr" align="center">Unit</th>
			 <th class="datatableHdr" align="center">Status</th>
			</tr>			
			<tbody>
			<cfloop query="getRequests_completed">
				<tr class="checkedinRowHover">
				<td align="center" style="font-size:10px;"><a href="maintenance_detail.cfm?maintenance_request_id=#maintenance_request_id#">#r_fname# #r_lname#</td>
				<td align="center" style="font-size:10px;">#dateFormat(request_date,'m/d/yyyy')#</td>
				<td style="font-size:10px;">#title#</td>
        <td align="center" style="font-size:10px;">#h_unitnumber#</td>
        <td align="center" style="font-size:10px;">
					<!--- <select name="status" class="sel_status" data-rid="#r_id#" data-request-id="#maintenance_request_id#">
						<option value="new"<cfif request_status is 'new'> selected="selected"</cfif>>New</option>
						<option value="inprogress"<cfif request_status is 'inprogress'> selected="selected"</cfif>>In Progress</option>
						<option value="completed"<cfif request_status is 'completed'> selected="selected"</cfif>>Completed</option>
					</select> --->Completed
				</td>
        </tr>
      </cfloop>
      </tbody>
    </table>
	<cfelse>
		<p style="color: white;">No completed #labels.communications#s found.</p>
	</cfif>
</cfif>    
</cfoutput>

</div>

<cfcatch><cfdump var="#cfcatch#"> <cfabort></cfcatch>
 </cftry>