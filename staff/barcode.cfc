<cfcomponent>
	<cfset datasource="cybatrol" />
	<cffunction name="create" access="public" returntype="numeric" displayname="Create User " hint="Returns Barcode">
		<cfargument name="g_id" required="true">
		<cfset var gid = ''>
       <cftry>
	    <cfset codepass = FALSE>
		 <cfloop condition="codepass is FALSE">
			<cfset gid = RandRange(10000000,99999999)>
              <cfquery datasource="#datasource#" name="qGetBarCodeHistory">
                  select barcode from barcodes where barcode = '#gid#'
              </cfquery>
              <cfif NOT qGetBarCodeHistory.recordcount>
                  <cfset codepass = TRUE>
              </cfif>
          </cfloop>		
		 <cfreturn gid />
		 	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>