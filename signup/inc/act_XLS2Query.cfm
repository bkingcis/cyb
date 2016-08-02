<cftry>
	<!--- Create an instance of the POIUtility.cfc. 
	// get a reference to the javaLoader --->
	<cfset javaLoader = server[application.myJavaLoaderKey]>
	
	<cfset objPOI = createObject('component','com.POIUtility')>
	
	<!--- 
		Read in the Exercises excel sheet. This has Push, Pull,
		and Leg exercises split up on to three different sheets.
		By default, the POI Utilty will read in all three sheets
		from the workbook. Since our excel sheet has a header
		row, we want to strip it out of our returned queries.
	--->
	<cfparam name="newfile" default="uploadTest.xls" />
	
	<cfif isObject(objPOI)>
		<cfset arrSheets = objPOI.ReadExcel( 
			FilePath = ExpandPath( "/userFiles/#newFile#" ),
			HasHeaderRow = true
			) />

		<!--- <cfdump var="#arrSheets#"> --->
	<cfelse>
		<h2>There was an error reading the file.  Please try converting the 
		file to an alternate format or contact us directly and we can assist.</h2>
	</cfif>
		<cfcatch type="any">
			<h3>Err: <cfoutput>#cfcatch.message#</cfoutput></h3>
			<cfdump var="#theUpload#">
			<cfdump var="#cfcatch#">
	<cfabort></cfcatch>
	</cftry>
	<!--- 
		The ReadExcel() has returned an array of sheet object.
		Let's loop over sheets and output the data. NOTE: This
		could be also done to insert into a DATABASE!
	--->