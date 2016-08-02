<cftry>
<cfif structKeyExists(url,"maintenance_request_id")>
  <cfset attributes.maintenance_request_id = url.maintenance_request_id>
</cfif>
<cfif structKeyExists(form,"detail")>
  <cfquery datasource="#request.dsn#" name="updRequest">
    update maintenance_request set
      request_status=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.status#" />,
      title=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.title#" />,
      detail=<cfqueryparam cfsqltype="CF_SQL_TEXT" value="#form.detail#" />
    where  c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
    and maintenance_request_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.maintenance_request_id#" />
  </cfquery>
  <cfset message = "Maintenance request update saved.">
<cfelse>
  <cfset message = "">
</cfif>
<cfquery datasource="#request.dsn#" name="getRequest">
    select maintenance_request_id,m.r_id,title,detail,request_date,request_status,r_lname, r_fname, h.h_id, h_unitnumber
		from maintenance_request m join residents r on r.r_id = m.r_id		
			join homesite h on r.h_id = h.h_id
    where r.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
    and maintenance_request_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.maintenance_request_id#" />
</cfquery>
 <cfquery datasource="#request.dsn#" name="getResident">
    select r_lname, r_fname from residents
    where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
    and   r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(getRequest.r_id)#">
  </cfquery>
<cfinclude template="header.cfm">
<cfoutput>
  <div id="popUpContainer">
    <cfif len(message)><div class="message" style="margin: 10px; border: 1px solid black; background-color: ##eee;color:black;">#message#</div></cfif>
    <h1>MAINTENANCE REQUEST: #getResident.r_lname#, #getResident.r_fname#</h1>
  	<div style="width:45%; margin:0 auto;">

      <form action="maintenance_detail.cfm?maintenance_request_id=#getRequest.maintenance_request_id#" method="post">
        <fieldset style="color:white;">
          <div style="font-weight:bold;padding-bottom:10px;">Title:</div>
          <input type="text" name="title" value="#getRequest.title#">
          <div style="font-weight:bold;padding-bottom:10px;">Detail:</div>
          <textarea name="detail" style="width:100%; height: 120px;">#getRequest.detail#</textarea>

          <div style="font-weight:bold;padding-bottom:10px;">Status:</div>
          <select  name="status">
            <option value="new"<cfif getRequest.request_status is 'new'> selected="selected"</cfif>>New</option>
            <option value="inprogress"<cfif getRequest.request_status is 'inprogress'> selected="selected"</cfif>>In Progress</option>
            <option value="completed"<cfif getRequest.request_status is 'completed'> selected="selected"</cfif>>Completed</option>	
          </select>
          <input type="submit" value="Save">
        </fieldset>
      </form>
    </div>
 </cfoutput>
  
</div>
  <cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>