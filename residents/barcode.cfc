<cfcomponent>
	<cfset datasource="cybatrol" />
	<cffunction name="create" access="public" returntype="numeric" displayname="Create User " hint="Returns Barcode">
		<cfargument name="g_id" required="true">
		<!--- <cfquery name="getNextBarcode" datasource="#datasource#">
			select * from barcodes
			Where c_id = #session.user_community#
			Order by bc_id
		</cfquery>
		<cfparam name="nextBarcode" default="0000001">
		<cfif getNextBarcode.RecordCount IS NOT 0>
		<cfoutput query="getNextBarcode" startrow="#getNextBarcode.RecordCount#">
			<cfset nextBarcode = Evaluate(Right(getNextBarcode.barcode,7)+1)>
		</cfoutput>
		</cfif>
		<cfset zeroes = "">
		<cfloop from="1" to="#evaluate(7-Len(nextBarcode))#" index="i">
			<cfset zeroes = "#zeroes#" & "0">
		</cfloop>
		<cfset zeroes1 = ""> --->
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

          <cfquery name="updateBarcodes" datasource="#datasource#">
			INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
				VALUES
			(#arguments.g_id#,'#gid#',#session.user_id#,#session.user_community#)
		  </cfquery>
		
		 <cfreturn gid />
	</cffunction>
</cfcomponent>