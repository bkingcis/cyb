<cfloop from="1" to="6" index="i">
<cfset temp = QueryChangeColumnName(session.custDataQuery,'column#i#',evaluate('form.colmapcol'&i))>
</cfloop>

<cfset successArray = arrayNew(1)>
<cfset errorArray = arrayNew(1)>

<cfloop query="session.custDataQuery">
<!--- Create a homesite --->
	<cftry>
	<cfquery datasource="cybatrol" name="addHomesite">
		insert into homesite (
  			c_id, h_lname, h_address, h_city, h_state, h_zipcode, h_phone, h_unitnumber, h_notes
		)
		values (
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.signup.c_id)#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_lname#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.h_address1#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.signup.c_city#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.signup.c_state#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.signup.c_postalcode#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_phone#" />,
			<cfif structKeyExists(session.custDataQuery,"h_unit")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.h_unit#" /><cfelse>''</cfif>,
			'added through customer signup bulk upload.'
		)
	</cfquery>
	<cfquery datasource="cybatrol" name="thisHomesite">
		select MAX(h_id) as new_h_id from homesite
	</cfquery>
	
	<cfquery datasource="cybatrol" name="addHomesite">
		insert into residents (
  			h_id,c_id,r_fname,r_lname,r_altphone,r_email,r_password,r_username
		)
		values (
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#thisHomesite.new_h_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.signup.c_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_fname#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_lname#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_phone#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_email#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#makePassword()#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.custDataQuery.r_email#" />
		)
	</cfquery>
		<cfset res.row = session.custDataQuery.currentRow>
		<cfset res.h_id = thisHomesite.new_h_id>
		<cfset arrayAppend(successArray,res)>
	<cfcatch>
	<cfdump var="#cfcatch#">
		<cfset res.row = session.custDataQuery.currentRow>
		<cfset res.errMessage = cfcatch.message>
		<cfset arrayAppend(errorArray,res)>
	</cfcatch>
	</cftry>
</cfloop>
<div class="container"><form><div class="row">
		<div class="col-med-10">
<fieldset>
	
		<div class="well"><strong>Results:</strong><br />
Successfully added <cfoutput>#ArrayLen(successArray)#</cfoutput> New residents.<br />
<cfif ArrayLen(errorArray)><cfdump var="#errorArray#"></cfif></div>
	</fieldset></div></div>


	<p style="display:inline-block;max-width:720px;margin-bottom:25px;">
		<button type="button" class="btn btn-primary" onclick="self.location='/admin'">Login To Your Account Now</button>
	</p></form>
</div>



<cffunction
    name="QueryChangeColumnName"
    access="public"
    output="false"
    returntype="query"
    hint="Changes the column name of the given query.">
 
    <!--- Define arguments. --->
    <cfargument
        name="Query"
        type="query"
        required="true"
        />
 
    <cfargument
        name="ColumnName"
        type="string"
        required="true"
        />
 
    <cfargument
        name="NewColumnName"
        type="string"
        required="true"
        />
 
    <cfscript>

        // Define the local scope.
        var LOCAL = StructNew();

        // Get the list of column names. We have to get this
        // from the query itself as the "ColdFusion" query
        // may have had an updated column list.
        LOCAL.Columns = ARGUMENTS.Query.GetColumnNames();

        // Convert to a list so we can find the column name.
        // This version of the array does not have indexOf
        // type functionality we can use.
        LOCAL.ColumnList = ArrayToList(
            LOCAL.Columns
            );

        // Get the index of the column name.
        LOCAL.ColumnIndex = ListFindNoCase(
            LOCAL.ColumnList,
            ARGUMENTS.ColumnName
            );

        // Make sure we have found a column.
        if (LOCAL.ColumnIndex){

            // Update the column name. We have to create
            // our own array based on the list since we
            // cannot directly update the array passed
            // back from the query object.
            LOCAL.Columns = ListToArray(
                LOCAL.ColumnList
                );

            LOCAL.Columns[ LOCAL.ColumnIndex ] = ARGUMENTS.NewColumnName;

            // Set the column names.
            ARGUMENTS.Query.SetColumnNames(
                LOCAL.Columns
                );

        }

        // Return the query reference.
        return( ARGUMENTS.Query );

    </cfscript>
</cffunction>

<cfscript>
	/**
 * Generates an 8-character random password free of annoying similar-looking characters such as 1 or l.
 * 
 * @return Returns a string. 
 * @author Alan McCollough (amccollough@anmc.org) 
 * @version 1, December 18, 2001 
 */
function MakePassword()
{      
  var valid_password = 0;
  var loopindex = 0;
  var this_char = "";
  var seed = "";
  var new_password = "";
  var new_password_seed = "";
  while (valid_password eq 0){
    new_password = "";
    new_password_seed = CreateUUID();
    for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
      this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
      seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
      switch(seed){
        case "1": {
          new_password = new_password & chr(int((this_char mod 9) + 48));
          break;
        }
	case "2": {
          new_password = new_password & chr(int((this_char mod 26) + 65));
          break;
        }
        case "3": {
          new_password = new_password & chr(int((this_char mod 26) + 97));
          break;
        }
      } //end switch
    }
    valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);	
  }
  return new_password;
}
</cfscript>