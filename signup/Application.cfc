<cfcomponent>
<cfset this.name = "cyba_signup">
<cfset this.Sessionmanagement = true>
<cfset this.loginstorage = "session">

<cffunction name="onApplicationStart" output="true">
	<cfscript>
		var jarPaths = arrayNew(1);
		var getJarFiles = "";
		var getFilePaths = "";
		var filePathList = "";
		application.myJavaLoaderKey = "de1cfcda-27e2-14e5-b345-feff819cdc9f_javaloader";
	    myJavaLoaderKey = application.myJavaLoaderKey;
		// Define the application settings. 
		this.name = hash( getCurrentTemplatePath() );
		this.applicationTimeout = createTimeSpan( 0, 0, 10, 0 );
		// Get the current directory and the root directory so that we can
		// set up the mappings to our components.
		this.appDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
		this.projectDirectory = ( this.appDirectory & "../" );
		// Map to our Lib folder so we can access our project components.
		this.mappings[ "/lib" ] = ( this.projectDirectory & "com/" );
	</cfscript>
	
	 <cftry>
		<!--- list all jars within the POI directory (and its subdirectories) --->
		<cfdirectory action="list" directory="#ExpandPath('/com/poi-3.12/')#" name="getJarFiles" recurse="true" filter="*.jar">

		<!--- construct the full file paths for all jar files --->
		<cfquery name="getFilePaths" dbtype="query">
			SELECT    Directory +'/'+ Name AS FilePath
			FROM    getJarFiles
		</cfquery>

		<!--- if the javaLoader was not created yet --->
		<cfif NOT structKeyExists(server, application.myJavaLoaderKey)>
			<!--- create an array of jar file paths --->
			<cfset filePathList = replace( valueList(getFilePaths.FilePath, "|"), "\", "/", "all")>
			<cfset jarPaths = listToArray(filePathList, "|")>

			<!---  create an instance of the JavaLoader and store it in the server scope --->
			<cflock name="#Hash(myJavaLoaderKey)#" type="exclusive" timeout="10">
				<!---  re-verify it was not created yet --->
				<cfif NOT structKeyExists(server, application.myJavaLoaderKey)>
					<cfset server[application.myJavaLoaderKey] = createObject("component", "com.javaloader.JavaLoader").init( jarPaths )>
				</cfif>
			</cflock>
		</cfif>
		<cfcatch><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
</cffunction>
</cfcomponent>