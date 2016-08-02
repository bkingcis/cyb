<cfquery name="getPropList" datasource="#datasource#">
  SELECT	h.* from homesite h join residents_homesite rh on h.h_id = rh.h_id
          join residents r on r.r_id = rh.r_id
  WHERE	 	r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_id#" />
</cfquery>
<cfoutput>
  <h3>Select property:</h3>
  <form action="/residents/index.cfm" method="post" target="_parent" id="entrypoint_frm">
    <ul class="list-group">
      <cfloop query="getPropList">
        <li class="list-group-item ">
          <div class="input-group"> 
            <label class=""><input type="radio" value="#getPropList.h_id#" name="switch_h_id"> #getPropList.h_address# <cfif len(getPropList.h_unitnumber)>- Unit #getPropList.h_unitnumber#</cfif></label>
          </div>
        </li>
      </cfloop>
    </ul>
    <br /><br />
    <input type="submit" value="continue" class="btn btn-primary">
  </form> 
</cfoutput>