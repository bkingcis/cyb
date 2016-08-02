<cftry>
<cfif isDefined("g_id")>
	<cfquery datasource="#datasource#" name="qGuest">
		select g.g_fname,g.g_lname,g.g_id,gv.g_permanent 
		from guests g join guestvisits gv on g.g_id = gv.g_id
		where g.r_id = <cfqueryparam value="#session.user_id#" cfsqltype="CF_SQL_INTEGER" />
		and g.g_id = <cfqueryparam value="#val(g_id)#" cfsqltype="CF_SQL_INTEGER" />
	</cfquery>
<cfelse>
	<cfparam name="error" default="0" >

	<!--- first validate that names were not submitted blank --->
	<cfloop collection="#form#" item="field">
		<!--- <cfif field contains "LNAME">
			<cfif trim(evaluate("form."&field)) is "">
				<cfsavecontent variable="errorHTML">
					<div align="center"><p><!--- There was an error with your submission. ---></p>  
					<strong>A Selected Arriving Guest Name Was Not Provided.</strong>
					<p>Please Go Back And Try Again</p></div>
					<div align="center"><input type="button" value="  Go Back  " onclick="history.back();" style="color:Red;"></div><br /><br />
				</cfsavecontent>
				<cfset error = 1>			
			</cfif>
		</cfif> --->
		<cfif field contains "dashpass">
			<cfif trim(evaluate("form."&field)) is "email" and NOT evaluate("form."&replaceNoCase(field,'dashpass','Email')) contains '@'>
				<cfsavecontent variable="errorHTML">
					<!--- <cfoutput>evaluate("form."&replace(field,'dashpass','Email'))<br />
					form.#replace(field,'dashpass','Email')#-#evaluate("form."&replaceNoCase(field,'dashpass','Email'))#<br /></cfoutput>
					 ---><div align="center"><p><!--- There was an error with your submission. ---></p>  
					<strong>A Selected Arriving Guest Email Address Was NOT Entered.</strong>
					<p>Please Go Back And Try Again</p></div>
					<div align="center"><input type="button" value="  Go Back  " onclick="history.back();" style="color:Red;"></div><br /><br />
				</cfsavecontent>
				<cfset error = 1>
			</cfif>
		</cfif>
	</cfloop>


	<cfif error neq 1>
		<!--- Next:  check to make sure that there were no 24/7 guests here --->

		<cfset listOfBadIndexes = ''>
		<cfloop collection="#form#" item="field">
			<cfif field contains "LNAME" and len(evaluate('form.'&field))>
				<!--- pull out index for the field names --->
				<cfset guestIndex = replaceNoCase(field,'lname','')>
				<cfquery datasource="#datasource#" name="qExisting247">
					select g.g_id,gv.g_permanent 
					from guests g join guestvisits gv on g.g_id = gv.g_id
					where g.r_id = <cfqueryparam value="#session.user_id#" cfsqltype="CF_SQL_INTEGER" />
					and g_lname= <cfqueryparam value="#evaluate('form.lname'&guestindex)#" cfsqltype="CF_SQL_VARCHAR" />
					and g_fname=<cfqueryparam value="#evaluate('form.fname'&guestindex)#" cfsqltype="CF_SQL_VARCHAR" />
					and g_email=<cfqueryparam value="#evaluate('form.email'&guestindex)#" cfsqltype="CF_SQL_VARCHAR" />
					and gv.g_permanent is not null
				</cfquery>
				<cfif qExisting247.recordcount and val(qExisting247.g_permanent)>
					<cfset listOfBadIndexes = listappend(listOfBadIndexes,guestIndex)>		
				</cfif>
			</cfif>		
		</cfloop>
		<cfif listLen(listOfBadIndexes)>
		<cfsavecontent variable="errorHTML">
			<div align="center"><strong>
			<span style="color:red;">Notice</span><br><br>			
			<cfif listLen(listOfBadIndexes) eq 1>
				The following guest is already scheduled for 24/7 access.
			<cfelse>
				The following guests are already scheduled for 24/7 access.
			</cfif>
			</strong><br /><br />
			<cfoutput>
			<!--- List of bad indexes: #listOfBadIndexes# --->
			<span style="font-size:13pt;">
			<cfloop list="#listOfBadIndexes#" index="badLine">
				#ucase(evaluate('form.lname'&badLine))#, #ucase(evaluate('form.fname'&badLine))#<br />
			</cfloop></span>

			<br /><br />
			<form action="/residents/popup/announce2.cfm" method="post">
			<!--- <input type="button" value="  Edit 24/7 Guests  " onclick="self.location='/residents/permguest.cfm';" style="color:Red;"> --->
			<cfif listLen(listOfBadIndexes) lt val(form.number_of_guests)>
				<cfset itt = 0>
				<cfloop from="1" to="#val(form.number_of_guests)#" index="origFieldIndex">
					<cfif NOT ListFind(listOfBadIndexes,origFieldIndex)>
					<cfset itt = itt + 1>
					<input type="hidden" name="lname#itt#" value="#evaluate('form.lname'&origFieldIndex)#" >
					<input type="hidden" name="fname#itt#" value="#evaluate('form.fname'&origFieldIndex)#" >
					<input type="hidden" name="email#itt#" value="#evaluate('form.email'&origFieldIndex)#" >

					<input type="hidden" name="dashpass#itt#" value="#evaluate('form.dashpass'&origFieldIndex)#" >
					<input type="hidden" name="email_map#itt#" value="#evaluate('form.email_map'&origFieldIndex)#" >
					<input type="hidden" name="notify#itt#" value="#evaluate('form.notify'&origFieldIndex)#" >
					</cfif>
				</cfloop>

				<input type="hidden" name="number_of_guests" value="#number_of_guests-listLen(listOfBadIndexes)#"> 

				<input type="submit" value="  Continue Announcing Remaining Guest(s)  " style="color:Green;">
			</cfif>
			</cfoutput>
			</form>
			</div><br /><br />
		</cfsavecontent>
		<cfset error = 1>	
		</cfif>
	</cfif>

</cfif>
<cfcatch><cfdump var="#cfcatch#"><cfabort>
</cfcatch></cftry>
